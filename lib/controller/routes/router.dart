import 'package:dqueuedoc/controller/routes/routnames.dart';
import 'package:dqueuedoc/view/ui/starting_screens/online_requests_scren.dart';
import 'package:dqueuedoc/view/ui/starting_screens/settings_screen.dart';
import 'package:flutter/material.dart';

import '../../view/ui/starting_screens/splash_scren.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteNames.onlineReqScreen:
        return MaterialPageRoute(builder: (_) => const OnlineReqScreen());
      // case RouteNames.chat:
      //   return MaterialPageRoute(builder: (_) => ChatPage("ssd"));

      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

// case '/coursePage':
// return MaterialPageRoute(builder: (_) => CoursePage());
// case '/enquiryScreen':
//   SingleCourse data = settings.arguments as SingleCourse;
//
//   return MaterialPageRoute(
//       settings: settings,
//       builder: (_) => EnquiryScreen(data));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
