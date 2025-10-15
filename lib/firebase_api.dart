import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dqueuedoc/controller/managers/auth_manager.dart';
import 'package:dqueuedoc/view/ui/starting_screens/online_requests_scren.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'controller/managers/online_consult_manager.dart';
import 'controller/managers/state_manager.dart';
import 'model/helper/service_locator.dart';

/// Single, global plugin
final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

/// ANDROID CHANNELS (top-level; immutable once created)
const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'General notifications',
  importance: Importance.high,
);

const AndroidNotificationChannel scheduledIn10Channel =
    AndroidNotificationChannel(
      'booking_alert_in_10',
      'Booking in 10 Notifications',
      description: 'Reminders with custom sound',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound(
        'today',
      ), // today.wav/ogg in res/raw
    );

// Default channel equivalent
const DarwinNotificationDetails defaultDarwinDetails =
    DarwinNotificationDetails(
      categoryIdentifier:
          'default_category', // matches setNotificationCategories
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

// Scheduled in 10 channel equivalent
const DarwinNotificationDetails
scheduledIn10DarwinDetails = DarwinNotificationDetails(
  categoryIdentifier: 'booking_alert_category', // define new category
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
  sound:
      'booking_alert_in_10.aiff', // must match the custom sound file in ios/Runner
);

/// MUST be top-level for background isolate
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  log(
    "message is notification fetch from background ${message.notification!.toMap()}",
  );
  log("message ${message.data}");
  log("message ${message.notification!.body}");
  log("message ${message.notification!.android!.channelId}");
  log("message");

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp();
  // await NotificationServiceAndroid.instance.showFromMessage(message);
  // NotificationServiceAndroid.instance.handleAction(message);
  if (message.notification == null) {
    await NotificationServiceAndroid.instance.showFromMessage(message);
  }
  NotificationServiceAndroid.instance.handleAction(message);
}

// 🔑 Must be top-level
@pragma('vm:entry-point')
Future<void> notificationTapBackgroundHandler(
  NotificationResponse response,
) async {
  // Re-initialize Firebase if needed
  if (Firebase.apps.isEmpty) await Firebase.initializeApp();
  final payload = response.payload;
  if (payload != null) {
    final msg = RemoteMessage.fromMap(jsonDecode(payload));
    NotificationServiceAndroid.instance.handleAction(msg);
  }
}

class NotificationServiceAndroid {
  NotificationServiceAndroid._();
  static final NotificationServiceAndroid instance =
      NotificationServiceAndroid._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await Firebase.initializeApp();
    final settings = await _messaging.requestPermission();
    if (kDebugMode) {
      print('Authorization status: ${settings.authorizationStatus}');
    }
    await _initLocal();
    await _initPush();
  }

  Future<void> _initLocal() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) async {
        final msg = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        handleAction(msg);
      },
      onDidReceiveBackgroundNotificationResponse:
          notificationTapBackgroundHandler, // ✅ FIXED
    );

    final android = localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(defaultChannel);
    await android?.createNotificationChannel(scheduledIn10Channel);

    // --- iOS specific setup ---
    final ios = localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _initPush() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // Tapped from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((m) {
      if (m != null) handleAction(m);
    });

    // Tapped from background
    FirebaseMessaging.onMessageOpenedApp.listen(handleAction);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((m) async {
      log(
        "message is notification fetch from foreground ${m.notification!.toMap()}",
      );
      // await showFromMessage(m);
      handleAction(m);
      await showFromMessage(m);

      if (m.notification == null) {}
      // handleAction(m);
    });

    // try {
    //   if (Platform.isIOS) {
    //     String? apnsToken = await _messaging.getAPNSToken();
    //     if (apnsToken != null) {
    //       final token = await _messaging.getToken();
    //       log('FCM apnsToken token: $token');
    //     } else {
    //       await Future<void>.delayed(const Duration(seconds: 3));
    //       apnsToken = await _messaging.getAPNSToken();
    //       if (apnsToken != null) {
    //         final token = await _messaging.getToken();
    //         log('FCM token: $token');
    //       }
    //     }
    //   } else {
    //     final token = await FirebaseMessaging.instance.getToken();
    //     log('FCM token: $token');
    //   }
    // } catch (e) {
    //   log('Unable to get FCM token: $e');
    // }

    try {
      if (Platform.isIOS) {
        String? apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) log('FCM apnsToken: $apnsToken');
      } else {
        final token = await _messaging.getToken();
        log('FCM token: $token');
      }
    } catch (e) {
      log('Unable to get FCM token: $e');
    }
  }

  /// Shows a local notification using the correct Android channel
  Future<void> showFromMessage(RemoteMessage message) async {
    final n = message.notification;
    if (n == null) return;

    // final channel = _pickChannel(message);
    // log(channel.id);
    try {
      final details = _pickChannel(message);

      await localNotifications.show(
        n.hashCode, // notification id
        n.title, // notification title
        n.body, // notification body
        details, // cross-platform NotificationDetails
        payload: jsonEncode(message.toMap()), // pass data for click handling
      );
    } catch (e, s) {
      log('Local notification error: $e $s');
    }
  }

  NotificationDetails _pickChannel(RemoteMessage m) {
    log("notification channel check ");
    final docModel = getIt<AuthManager>().docDetailsModel;
    bool soundOn = docModel == null ? true : docModel.isSoundEnabled!;

    // Determine which “channel” or category to use
    final isBookingAlert = soundOn && (m.data['type'] == 'booking_alert_in_10');

    // --- Android details ---
    final androidDetails = AndroidNotificationDetails(
      isBookingAlert ? scheduledIn10Channel.id : defaultChannel.id,
      isBookingAlert ? scheduledIn10Channel.name : defaultChannel.name,
      channelDescription: isBookingAlert
          ? scheduledIn10Channel.description
          : defaultChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      playSound: isBookingAlert ? true : true, // always play if sound is on
      sound: isBookingAlert ? scheduledIn10Channel.sound : null,
      icon: '@mipmap/ic_launcher',
    );

    // --- iOS details ---
    final iOSDetails = DarwinNotificationDetails(
      categoryIdentifier: isBookingAlert
          ? 'booking_alert_category'
          : 'default_category',
      presentAlert: true,
      presentBadge: true,
      presentSound: soundOn,
      sound: isBookingAlert ? 'booking_alert_in_10.aiff' : "default",
    );

    return NotificationDetails(android: androidDetails, iOS: iOSDetails);
  }

  /// App-specific actions based on data['type']
  void handleAction(RemoteMessage m) async {
    // log("message ${m.data}");
    final type = m.data['type'];
    log(type.toString());
    switch (type) {
      case 'online_patient_request':
        getIt<StateManager>().changeHomeIndex(2);
        getIt<OnlineConsultManager>().getPatientRequestList();
        break;
      case 'booking_alert_in_10':
      case 'scheduled_request':
        getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
        break;
      case 'booking_alert_on_time':
        await Future.delayed(const Duration(seconds: 1));
        getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
        break;
      case 'active_call_alert':
        final inCall = getIt<StateManager>().getInCallStatus();
        final inChat = getIt<StateManager>().getInChatStatus();
        if (!inCall) {
          _showCallAlert(
            name: m.data['patient_full_name'],
            appoinmId: m.data['appointment_id'],
            imag: m.data['patient_image'],
            bookid: int.tryParse(m.data['booking_id']),
            inChatStatus: inChat,
          );
        }
        break;
      case 'appointment_cancellation':
      case 'booking_request_update':
        getIt<OnlineConsultManager>().getPatientRequestList();
        break;
      case 'anatomy_points':
        getIt<OnlineConsultManager>().setSelectedSmallPoint(m.data['point']);
        break;
      default:
        log('Unknown type: $type');
    }
  }
}

void _showCallAlert({
  required String name,
  required String appoinmId,
  required String? imag,
  required int? bookid,
  required bool inChatStatus,
}) {
  showDialog(
    context: getIt<NavigationService>().navigatorkey.currentContext!,
    builder: (context) => CallRequestPopup(
      name: name,
      appoinmentId: appoinmId,
      img: imag ?? '',
      bookingId: bookid!,
      inChatStatus: inChatStatus,
    ),
  );
}
