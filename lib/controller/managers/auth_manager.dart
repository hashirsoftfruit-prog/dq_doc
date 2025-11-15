// import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer';
import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/basic_response_model.dart';
import '../../model/core/doctor_profile_model.dart';
import '../../model/core/login_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class AuthManager extends ChangeNotifier {
  bool logoutLoader = false;
  DocDetailsModel? docDetailsModel;

  //saving server token
  saveToken(String val) {
    getIt<SharedPreferences>().setString(StringConstants.token, val);
  }

  //saving user name
  saveUserName(String val) {
    getIt<SharedPreferences>().setString(StringConstants.userName, val);
  }

  // saving user id
  saveUserId(int val) {
    getIt<SharedPreferences>().setInt(StringConstants.userId, val);
  }

  //userlogin function with user name and password
  Future<LoginResponseData> userLogin({
    required String usrName,
    required String pass,
  }) async {
    String endpoint = Endpoints.login;
    Map<String, dynamic> data = {"username": usrName, "password": pass};
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, null);
    log("login response $responseData");
    if (responseData != null) {
      var result = LoginResponseData.fromJson(responseData);
      return result;
    } else {
      return LoginResponseData(status: false, message: "no data");
    }
  }

  //logout funciton
  logoutFn() async {
    logoutLoader = true;
    // await Future.delayed(Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.logout;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    //fcm token not getting on iOS 26 simulator, so logout will not happen on iOS Simulator as of 13th November 2025
    //future update will fix the issue,
    //working on real device
    var fcmTokn = await getIt<AuthManager>().getfcmToken();

    Map<String, dynamic> data = {"user_type": 1, "fcm": fcmTokn};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    log(responseData.toString());
    log(responseData['status'].toString());

    if (responseData != null && responseData['status'] == true) {
      // if (responseData != null) {
      getIt<SharedPreferences>().clear();

      getIt<StateManager>().logoutFn();
      docDetailsModel = null;

      logoutLoader = false;
    }

    notifyListeners();
  }

  //saving fcm token to server after login
  Future<BasicResponseModel?> saveFcmApi() async {
    try {
      String endpoint = Endpoints.saveFcm;
      //fcm token not getting on iOS 26 simulator, so logout will not happen on iOS Simulator as of 13th November 2025
      //future update will fix the issue,
      var fcmTokn = await getfcmToken();
      var deviceTkn = await getDeviceIdentifier();

      Map<String, dynamic> data = {
        "fcm": fcmTokn,
        "device_id": deviceTkn,
        "type": Platform.isAndroid
            ? "android"
            : Platform.isIOS
            ? "ios"
            : "web",
      };
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      if (responseData != null) {
        var result = BasicResponseModel.fromJson(responseData);
        return result;
      } else {
        return BasicResponseModel(status: false, message: "Server error");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  //getting doctor details from server
  getDoctorDetails() async {
    try {
      String endpoint = Endpoints.doctorProfile;

      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
      if (responseData != null) {
        docDetailsModel = DoctorProfileModel.fromJson(responseData).doctors;
        getIt<SharedPreferences>().setString(
          StringConstants.proImage,
          docDetailsModel?.image ?? "",
        );

        notifyListeners();

        // docDetailsModel = responseData;
      } else {}
    } catch (e, s) {
      if (kDebugMode) {
        print("error : $e \n $s");
      }
    }
  }

  //not work on IOS 26 Simulator but work on real device.
  Future<String?> getfcmToken() async {
    FirebaseMessaging messaging;

    String? token;

    messaging = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      await messaging.getAPNSToken();
    }
    token = await messaging.getToken();

    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString("fcm_id", value);
    return token;
  }

  //device id used for troubleshooting
  Future<String> getDeviceIdentifier() async {
    String deviceIdentifier = "unknown";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceIdentifier = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceIdentifier = iosInfo.identifierForVendor!;
    }
    return deviceIdentifier;
  }

  //change the sound notification from settings page
  //is_sound_enabled used for sending notificaiton with sound
  Future<void> setSoundNotificationEnabled(bool val) async {
    try {
      String endpoint = Endpoints.updateNotificationSound;

      Map<String, dynamic> data = {"is_sound_enabled": val};
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

      dynamic responseData = await getIt<DioClient>().post(
        endpoint,
        data,
        tokn,
      );
      if (responseData != null) {
        final data = responseData["is_sound_enabled"];
        docDetailsModel!.isSoundEnabled = data;
        notifyListeners();
      } else {
        //nothing do
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}







// getToken()