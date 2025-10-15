// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dqueuedoc/firebase_api.dart';
import 'package:dqueuedoc/view/theme/constants.dart';
import 'package:dqueuedoc/view/ui/starting_screens/splash_scren.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:provider/provider.dart';

import 'controller/managers/auth_manager.dart';
import 'controller/managers/chat_manager.dart';
import 'controller/managers/home_manager.dart';
import 'controller/managers/online_consult_manager.dart';
import 'controller/managers/settlements_manager.dart';
import 'controller/managers/state_manager.dart';
import 'controller/routes/router.dart';
import 'firebase_options.dart';
import 'model/helper/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase only once
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await setupServiceLocator();
  // await FirebaseApi().initNotification();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  await NotificationServiceAndroid.instance.init();

  // InitConfig initConfig = InitConfig(
  //   domain: "zoom.us",
  //   enableLog: true,
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the subscription when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String label = StringConstants.tempIconViewStatus == true
        ? 'DoctorOnQ'
        : 'Medico';

    var zoom = ZoomVideoSdk();

    InitConfig initConfig = InitConfig(domain: "zoom.us", enableLog: true);

    try {
      zoom.initSdk(initConfig);
    } catch (e) {
      if (kDebugMode) {
        print("Initialization error: $e");
      }
    }
    // String? tokn = getIt<SharedPreferences>().getString(StringConstants.token);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colours.primaryblue,
        statusBarIconBrightness: Brightness.light, // Status bar color
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => getIt<StateManager>()),
        ChangeNotifierProvider(create: (context) => getIt<AuthManager>()),
        ChangeNotifierProvider(
          create: (context) => getIt<OnlineConsultManager>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<SettlementsManager>(),
        ),
        ChangeNotifierProvider(create: (context) => getIt<HomeManager>()),
        ChangeNotifierProvider(create: (context) => getIt<ChatProvider>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // onGenerateRoute: Routers.generateRoute,
        // initialRoute: RouteNames.splash,
        routes: const {
          // "Join": (context) => const JoinScreen(),
          // "Intro": (context) => const IntroScreen(),
          // '/chat': (context) => ChatPage("appId"),
          // Define more routes as needed
        },
        onGenerateRoute: Routers.generateRoute,
        navigatorKey: getIt<NavigationService>().navigatorkey,
        // home:ApplyCouponScreen(),
        home: const SplashScreen(),
        // home:ChatPage(appId: 'DQ-505-3656',bookingId: 23214,isCallAvailable: true,isDirectToCall: true,),

        // home:ChatPage('DOQ-ZM-2224',9),
        title: label,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
    );
  }
}

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text(
          "Please check your internet connection and try again.",
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
}
