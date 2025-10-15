import 'package:dqueuedoc/controller/managers/home_manager.dart';
import 'package:dqueuedoc/view/ui/starting_screens/analytics_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/home_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'consultaions_screen.dart';
import 'forum_screen.dart';
import 'widgets/custom_navigation_bar.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // The app has come to the foreground
      if (kDebugMode) {
        print("App is in the foreground");
      }

      getIt<HomeManager>().initFns();

      // You can perform actions here when the app is resumed
    }
  }

  @override
  Widget build(BuildContext context) {
    int btNavIndex = Provider.of<StateManager>(context).btmNavIndex;
    // StudentDashBoard? stDash = Provider.of<StudentManager>(context).stDash;

    // int selectedIndex = 0;

    DateTime? currentBackPressTime;

    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        try {
          if (btNavIndex == 2) {
            Fluttertoast.showToast(msg: "Press back again to exit");
          } else {
            getIt<StateManager>().changeHomeIndex(2);
          }
        } catch (e) {
          // debugPrint(e.toString());
        }

        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        // double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        // double w1p = maxWidth * 0.01;

        Widget navBarItem({
          required String img,
          required String title,
          required TextStyle txtstyle,
          required Color iconColor,
        }) {
          return SizedBox(
            height: h10p * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: h10p * 0.4,
                  child: SvgPicture.asset(img, color: iconColor),
                ),
                Text(title, style: txtstyle),
              ],
            ),
          );
        }

        Widget navBarIcon({
          required String img,
          required String title,
          required TextStyle txtstyle,
          required Color iconColor,
        }) {
          return SizedBox(
            height: h10p * 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: h1p * 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: SvgPicture.asset(img, color: iconColor),
                  ),
                ),
                Text(title, style: txtstyle),
              ],
            ),
          );
        }

        Widget bNavIcon(String loc) {
          return SizedBox(
            height: h1p * 4,
            child: SvgPicture.asset(loc, color: Colours.primaryblue),
          );
        }

        // double floatButtonwidth = 70;

        List<Widget> screens = [
          const ProfileScreen(),
          const ConsultaionsScreen(hideBackBtn: true),
          const HomeScreen(),
          const AnalyticsScreen(),
          const ForumScreen(),
          // Container(color:Colors.white,child: Center(child: Text("Coming soon")),),
          // HomeScreen(),
          // ScannedReciepts(),
          // ExpenseGroups(),
          // Profile()
        ];

        return WillPopScope(
          onWillPop: onWillPop,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: screens[btNavIndex],
            // floatingActionButton: InkWell(
            //   onTap: () {
            //     getIt<StateManager>().changeHomeIndex(2);
            //   },
            //   child: Container(
            //     width: floatButtonwidth,
            //     height: floatButtonwidth,
            //     decoration: BoxDecoration(
            //       boxShadow: const [
            //         BoxShadow(
            //           color: Colours.btnHash,
            //           spreadRadius: 1,
            //           blurRadius: 1,
            //         )
            //       ],
            //       shape: BoxShape.circle,
            //       color: btNavIndex == 2
            //           ? Colours.primaryblue
            //           : Colors.white,
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(18.0),
            //       child: SizedBox(
            //           child: SvgPicture.asset(
            //               "assets/images/btnav_home.svg",
            //               color: btNavIndex == 2
            //                   ? Colors.white
            //                   : const Color(0xff5B5B5B))),
            //     ),
            //   ),
            // ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
            // floatingActionButtonAnimator:
            //     FloatingActionButtonAnimator.scaling,
            // bottomNavigationBar: BottomAppBar(
            //     color: Colors.white,
            //     elevation: 1,
            //     padding: const EdgeInsets.symmetric(horizontal: 4),
            //     height: h10p * 1.1,
            //     child: ClipRRect(
            //       borderRadius: const BorderRadius.vertical(
            //           top: Radius.circular(20)),
            //       child: Container(
            //         decoration: const BoxDecoration(
            //             color: Colors.white,
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.grey,
            //                 spreadRadius: 3,
            //                 blurRadius: 3,
            //               )
            //             ]),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             SizedBox(
            //               width: (maxWidth - floatButtonwidth) / 2,
            //               child: Row(
            //                 mainAxisAlignment:
            //                     MainAxisAlignment.spaceEvenly,
            //                 children: [
            //                   btNavIndex == 0
            //                       ? navBarItem(
            //                           img:
            //                               "assets/images/btnav_profile.svg",
            //                           title: "Profile",
            //                           txtstyle: TextStyles.btNavTxt,
            //                           iconColor: Colours.primaryblue,
            //                         )
            //                       : InkWell(
            //                           onTap: () {
            //                             getIt<StateManager>()
            //                                 .changeHomeIndex(0);
            //                           },
            //                           child: navBarItem(
            //                               img:
            //                                   "assets/images/btnav_profile.svg",
            //                               title: "Profile",
            //                               txtstyle:
            //                                   TextStyles.btNavTxt2,
            //                               iconColor:
            //                                   const Color(0xff5B5B5B))),
            //                   btNavIndex == 1
            //                       ? navBarItem(
            //                           img:
            //                               "assets/images/btnav_bookings.svg",
            //                           title: "Consultations",
            //                           txtstyle: TextStyles.btNavTxt,
            //                           iconColor: Colours.primaryblue)
            //                       : InkWell(
            //                           onTap: () {
            //                             getIt<StateManager>()
            //                                 .changeHomeIndex(1);
            //                           },
            //                           child: navBarItem(
            //                               img:
            //                                   "assets/images/btnav_bookings.svg",
            //                               title: "Consultations",
            //                               txtstyle:
            //                                   TextStyles.btNavTxt2,
            //                               iconColor:
            //                                   const Color(0xff5B5B5B))),
            //                 ],
            //               ),
            //             ),
            //             SizedBox(
            //               width: (maxWidth - floatButtonwidth) / 2,
            //               child: Row(
            //                 mainAxisAlignment:
            //                     MainAxisAlignment.spaceEvenly,
            //                 children: [
            //                   btNavIndex == 3
            //                       ? navBarItem(
            //                           img:
            //                               "assets/images/btnav_analytics.svg",
            //                           title: "Analytics",
            //                           txtstyle: TextStyles.btNavTxt,
            //                           iconColor: Colours.primaryblue)
            //                       : InkWell(
            //                           onTap: () async {
            //                             getIt<StateManager>()
            //                                 .changeHomeIndex(3);
            //                           },
            //                           child: navBarIcon(
            //                               img:
            //                                   "assets/images/btnav_analytics.svg",
            //                               title: "Analytics",
            //                               txtstyle:
            //                                   TextStyles.btNavTxt2,
            //                               iconColor:
            //                                   const Color(0xff5B5B5B))),
            //                   btNavIndex == 4
            //                       ? navBarIcon(
            //                           img:
            //                               "assets/images/btnav_forum.svg",
            //                           title: "Forum",
            //                           txtstyle: TextStyles.btNavTxt,
            //                           iconColor: Colours.primaryblue)
            //                       : InkWell(
            //                           onTap: () {
            //                             getIt<StateManager>()
            //                                 .changeHomeIndex(4);
            //                           },
            //                           child: navBarIcon(
            //                               img:
            //                                   "assets/images/btnav_forum.svg",
            //                               title: "Forum",
            //                               txtstyle:
            //                                   TextStyles.btNavTxt2,
            //                               iconColor:
            //                                   const Color(0xff5B5B5B))),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //     // bottomNavigationBar:ClipRRect(borderRadius: BorderRadius.vertical(top:Radius.circular(30) ),
            //     //   child: Container(decoration: BoxDecoration(
            //     //       color: Colors.white,
            //     //       boxShadow: [
            //     //     BoxShadow(color: Colors.grey,spreadRadius: 3,blurRadius: 3,)
            //     //   ]),
            //     //     height: h10p*1,
            //     //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     //       children: [
            //     //         btNavIndex==0?navBarItem(img: "assets/images/btnav_home.svg", title: "Home",txtstyle: TextStyles.btNavTxt,iconColor: Color(0xff2E3192))
            //     //             :InkWell(
            //     //             onTap:(){
            //     //               getIt<StateManager>().changeHomeIndex(0);
            //     //
            //     //             },child: navBarItem(img: "assets/images/btnav_home.svg", title: "Home",txtstyle: TextStyles.btNavTxt2,iconColor: Color(0xff5B5B5B))),
            //     //         btNavIndex==1?navBarItem(img: "assets/images/btnav_bookings.svg", title: "Bookings",txtstyle: TextStyles.btNavTxt,iconColor: Color(0xff2E3192))
            //     //             :InkWell(
            //     //             onTap:(){
            //     //               getIt<StateManager>().changeHomeIndex(1);
            //     //
            //     //             },
            //     //             child: navBarItem(img: "assets/images/btnav_bookings.svg", title: "Bookings",txtstyle: TextStyles.btNavTxt2,iconColor: Color(0xff5B5B5B))),
            //     //
            //     //
            //     //         btNavIndex==2?navBarItem(img: "assets/images/btnav_analytics.svg", title: "Analytics",txtstyle: TextStyles.btNavTxt,iconColor: Color(0xff2E3192))
            //     //             :InkWell(
            //     //             onTap:(){
            //     //
            //     //
            //     //
            //     //                 getIt<StateManager>().changeHomeIndex(2);
            //     //
            //     //
            //     //
            //     //
            //     //
            //     //             },child: navBarItem(img: "assets/images/btnav_analytics.svg", title: "Analytics",txtstyle: TextStyles.btNavTxt2,iconColor: Color(0xff5B5B5B))),
            //     //         btNavIndex==3?
            //     //         navBarIcon( img: "assets/images/btnav_profile.svg",title: "Profile",txtstyle: TextStyles.btNavTxt,iconColor:  Color(0xff2E3192))
            //     //             :InkWell(
            //     //             onTap:(){
            //     //               getIt<StateManager>().changeHomeIndex(3);
            //     //
            //     //             },child: navBarIcon( img: "assets/images/btnav_profile.svg",title: "Profile",txtstyle: TextStyles.btNavTxt2,iconColor:  Color(0xff5B5B5B))),
            //     //       ],
            //     //     ),
            //     //   ),
            //     // )

            //     ),
            bottomNavigationBar: CustomBottomNav(
              btNavIndex: btNavIndex,
              maxWidth: MediaQuery.of(context).size.width,
              h10p: MediaQuery.of(context).size.height * 0.1,
            ),
          ),
        )
        // resizeToAvoidBottomInset: false,
        // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        ;
      },
    );
  }
}
