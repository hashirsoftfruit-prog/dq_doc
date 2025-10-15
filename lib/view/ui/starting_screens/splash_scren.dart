import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'landing_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
    _navigateHome();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _navigateHome() async {
    await Future.delayed(const Duration(seconds: 3), () async {
      var usrId = getIt<SharedPreferences>().getInt(StringConstants.userId);

      if (usrId == null) {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(navigateLogin(), (route) => false);
      } else {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(navigateHome(), (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool? showIcon = StringConstants.tempIconViewStatus;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        // double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Scaffold(
          // extendBody: true,
          backgroundColor: Colors.white,
          body: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // double size = h10p*1.5;
              // double size2 = _controller.value* w1p*2+w1p*2;
              return Container(
                color: Colours.primaryblue.withOpacity(_controller.value),
                width: maxWidth,
                height: maxHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        double size = h10p * 1.5;
                        double size2 = _controller.value * w1p * 2 + w1p * 2;
                        return SizedBox(
                          width: size,
                          height: size,
                          child: Stack(
                            children: [
                              Entry.scale(
                                scale: 10,
                                // scale: 20,
                                delay: const Duration(milliseconds: 2000),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeIn,

                                child: Opacity(
                                  opacity: _controller.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [boxShadow4],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    width: size,
                                    height: size,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size,
                                height: size,
                                child: Padding(
                                  padding: EdgeInsets.all(size2),
                                  child: showIcon == true
                                      ? SvgPicture.asset(
                                          "assets/images/appicon.svg",
                                        )
                                      : Image.asset(
                                          "assets/images/temp-app-icon.png",
                                        ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Route navigateHome() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const LandingScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

Route navigateLogin() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const LoginScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
