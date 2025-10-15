import 'dart:developer';
import 'dart:io';

import 'package:dqueuedoc/controller/managers/auth_manager.dart';
import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:dqueuedoc/view/ui/chat_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/patient_details_screen.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../controller/managers/home_manager.dart';
import '../../../model/core/app_details_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // DateTime _selectedDate = DateTime.now();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   // getIt<HomeManager>().initFns();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  // print("djfladjflkajdfs");
  //
  //
  // }

  @override
  void initState() {
    requestFilePermission();
    getIt<HomeManager>().initFns();
    super.initState();
  }

  Map<String, List<Permission>> platformPermissions = {
    "ios": [Permission.camera, Permission.microphone, Permission.photos],
    "android": [
      Permission.camera,
      Permission.microphone,
      // Permission.bluetoothConnect,
      Permission.phone,
      Permission.storage,
    ],
  };

  Future<void> requestFilePermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) {}
    bool blocked = false;
    List<Permission>? notGranted = [];
    // PermissionStatus result;
    List<Permission>? permissions = Platform.isAndroid
        ? platformPermissions["android"]
        : platformPermissions["ios"];
    Map<Permission, PermissionStatus>? statuses = await permissions?.request();
    statuses!.forEach((key, status) {
      if (status.isDenied) {
        blocked = true;
      } else if (!status.isGranted) {
        notGranted.add(key);
      }
    });

    if (notGranted.isNotEmpty) {
      notGranted.request();
    }

    // if (blocked) {
    //   await openAppSettings();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final EasyInfiniteDateTimelineController controller =
        EasyInfiniteDateTimelineController();

    AppDetailsModel? appStatus = Provider.of<HomeManager>(
      context,
    ).appDetailsModel;

    bool loader = Provider.of<OnlineConsultManager>(context).consultLoader;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<OnlineConsultManager>(
          builder: (context, mgr, child) {
            for (var element in mgr.patientsReqListId.entries) {
              if (element.value == false) {
                final e = mgr.patientsReqList.firstWhere(
                  (p) => p.id.toString() == element.key,
                  orElse: () => mgr.patientsReqList.first,
                );

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // showGeneralDialog(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   barrierLabel: "Appointment",
                  //   transitionDuration: const Duration(milliseconds: 300),
                  //   pageBuilder: (ctx, anim1, anim2) {
                  //     return Scaffold(
                  //       backgroundColor: Colors.black.withOpacity(0.6),
                  //       body: Center(
                  //         child: Container(
                  //           margin: const EdgeInsets.symmetric(
                  //               horizontal: 20, vertical: 40),
                  //           padding: const EdgeInsets.all(16),
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(24),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.black.withOpacity(0.2),
                  //                 blurRadius: 15,
                  //                 offset: const Offset(0, 6),
                  //               )
                  //             ],
                  //           ),
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               // Title
                  //               const Row(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Icon(Icons.calendar_today,
                  //                       color: Colors.blue, size: 26),
                  //                   SizedBox(width: 8),
                  //                   Text(
                  //                     "Incoming Appointment",
                  //                     style: TextStyle(
                  //                       fontSize: 20,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //               const SizedBox(height: 20),

                  //               // Glowing Avatar
                  //               AvatarGlow(
                  //                 glowColor: Colours.grad1,
                  //                 // endRadius: 90,
                  //                 duration: const Duration(milliseconds: 2000),
                  //                 repeat: true,
                  //                 // showTwoGlows: true,
                  //                 child: CircleAvatar(
                  //                   radius: 50,
                  //                   backgroundColor: Colours.primaryblue,
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(8.0),
                  //                     child: Image.asset(
                  //                       e.gender!.toUpperCase() == "MALE"
                  //                           ? "assets/images/person-man.png"
                  //                           : "assets/images/person-women.png",
                  //                       fit: BoxFit.contain,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const SizedBox(height: 20),

                  //               // Patient info
                  //               Text(
                  //                 e.firstName ?? "Unknown",
                  //                 style: const TextStyle(
                  //                     fontSize: 22, fontWeight: FontWeight.bold),
                  //               ),
                  //               const SizedBox(height: 6),
                  //               Text(
                  //                 "Age: ${e.age}, Gender: ${e.gender ?? '-'}",
                  //                 style: const TextStyle(
                  //                     fontSize: 16, color: Colors.grey),
                  //               ),
                  //               const SizedBox(height: 30),

                  //               // Action buttons (Ignore / Consult)
                  //               mgr.consultLoader == true
                  //                   ? AppLoader()
                  //                   : Row(
                  //                       mainAxisAlignment:
                  //                           MainAxisAlignment.spaceEvenly,
                  //                       children: [
                  //                         ElevatedButton.icon(
                  //                           onPressed: () async {
                  //                             FlutterRingtonePlayer().stop();
                  //                             getIt<OnlineConsultManager>()
                  //                                 .setConsultLoader(true);

                  //                             var result = await getIt<
                  //                                     OnlineConsultManager>()
                  //                                 .rejectPatientCall(e.id!);

                  //                             if (result.status == true) {
                  //                               getIt<OnlineConsultManager>()
                  //                                   .getPatientRequestList();
                  //                             } else {
                  //                               Fluttertoast.showToast(
                  //                                   msg: result.message ?? "");
                  //                             }
                  //                             Navigator.of(ctx).pop();
                  //                             getIt<OnlineConsultManager>()
                  //                                 .setConsultLoader(false);
                  //                           },
                  //                           style: ElevatedButton.styleFrom(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 24, vertical: 16),
                  //                             backgroundColor: Colors.red,
                  //                             shape: RoundedRectangleBorder(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(50),
                  //                             ),
                  //                           ),
                  //                           icon: const Icon(Icons.close,
                  //                               color: Colors.white, size: 28),
                  //                           label: const Text("Ignore",
                  //                               style: TextStyle(
                  //                                   color: Colors.white,
                  //                                   fontSize: 16)),
                  //                         ),
                  //                         ElevatedButton.icon(
                  //                           onPressed: () async {
                  //                             FlutterRingtonePlayer().stop();
                  //                             getIt<OnlineConsultManager>()
                  //                                 .setConsultLoader(true);

                  //                             var result = await getIt<
                  //                                     OnlineConsultManager>()
                  //                                 .acceptPatientRequest(e.id!);

                  //                             if (result.status == true) {
                  //                               getIt<OnlineConsultManager>()
                  //                                   .disposePriscrip();
                  //                               Navigator.of(ctx)
                  //                                   .pop(); // Close dialog
                  //                               Navigator.push(
                  //                                 context,
                  //                                 MaterialPageRoute(
                  //                                   builder: (_) => ChatPage(
                  //                                     appId: e.appoinmentId!,
                  //                                     bookingId: result.bookingId!,
                  //                                     isCallAvailable: true,
                  //                                     isDirectToCall: true,
                  //                                   ),
                  //                                 ),
                  //                               );
                  //                             } else {
                  //                               await getIt<OnlineConsultManager>()
                  //                                   .getPatientRequestList();
                  //                               Fluttertoast.showToast(
                  //                                   msg: result.message ?? "");
                  //                               Navigator.of(ctx)
                  //                                   .pop(); // Close dialog
                  //                             }

                  //                             getIt<OnlineConsultManager>()
                  //                                 .setConsultLoader(false);
                  //                           },
                  //                           style: ElevatedButton.styleFrom(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 28, vertical: 16),
                  //                             backgroundColor: Colors.green,
                  //                             shape: RoundedRectangleBorder(
                  //                               borderRadius:
                  //                                   BorderRadius.circular(50),
                  //                             ),
                  //                           ),
                  //                           icon: const Icon(Icons.video_call,
                  //                               color: Colors.white, size: 30),
                  //                           label: const Text("Consult",
                  //                               style: TextStyle(
                  //                                   color: Colors.white,
                  //                                   fontSize: 16)),
                  //                         ),
                  //                       ],
                  //                     )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   transitionBuilder: (ctx, anim1, anim2, child) {
                  //     return FadeTransition(
                  //       opacity: anim1,
                  //       child: ScaleTransition(
                  //         scale: CurvedAnimation(
                  //           parent: anim1,
                  //           curve: Curves.easeOutBack,
                  //         ),
                  //         child: child,
                  //       ),
                  //     );
                  //   },
                  // );
                });

                // Mark this request as already shown so it won't trigger again
                getIt<OnlineConsultManager>().addPatientId(element.key, true);

                // 👇 Important: break so only one dialog is shown per build frame
                break;
              }
            }

            if (mgr.patientsReqList.isNotEmpty &&
                !mgr.patientsReqListId.containsKey(
                  mgr.patientsReqList.first.id.toString(),
                )) {
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   getIt<OnlineConsultManager>()
              //       .addPatientId(mgr.patientsReqList.first.id.toString());
              //   var e = mgr.patientsReqList.first;
              //   showDialog(
              //     context: context,
              //     builder: (ctx) => AlertDialog(
              //       title: const Text("You Have an Appointment"),
              //       content: OnlineRequestBox(
              //         consultFn: () async {
              //           FlutterRingtonePlayer().stop();

              //           getIt<OnlineConsultManager>().setConsultLoader(true);
              //           var result = await getIt<OnlineConsultManager>()
              //               .acceptPatientRequest(e.id!);
              //           if (result.status == true) {
              //             getIt<OnlineConsultManager>().disposePriscrip();

              //             // await getIt<OnlineConsultManager>().getPatientRequestList();
              //             //  Navigator.push(context, MaterialPageRoute(builder: (_)=>OnlineConsultLanding(appoinmentId: e.appoinmentId!,directToCall: true, bookingId:result.bookingId!)));
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (_) => ChatPage(
              //                           appId: e.appoinmentId!,
              //                           bookingId: result.bookingId!,
              //                           isCallAvailable: true,
              //                           isDirectToCall: true,
              //                         )));

              //             // getIt<OnlineConsultManager>().getRecentPatientsList();
              //           } else {
              //             await getIt<OnlineConsultManager>()
              //                 .getPatientRequestList();

              //             Fluttertoast.showToast(msg: result.message ?? "");
              //           }
              //           getIt<OnlineConsultManager>().setConsultLoader(false);
              //         },
              //         declineFn: () async {
              //           FlutterRingtonePlayer().stop();

              //           getIt<OnlineConsultManager>().setConsultLoader(true);

              //           var result = await getIt<OnlineConsultManager>()
              //               .rejectPatientCall(e.id!);
              //           if (result.status == true) {
              //             getIt<OnlineConsultManager>().getPatientRequestList();
              //           } else {
              //             Fluttertoast.showToast(msg: result.message ?? "");
              //           }
              //           getIt<OnlineConsultManager>().setConsultLoader(false);
              //         },
              //         h1p: h1p,
              //         w1p: w1p,
              //         patientGender: e.gender ?? "-",
              //         patientAge: e.age.toString() ?? "-",
              //         patientName: e.firstName ?? "",
              //       ),
              //       actions: [
              //         TextButton(
              //           onPressed: () => Navigator.of(ctx).pop(),
              //           child: const Text("OK"),
              //         ),
              //       ],
              //     ),
              //   );
              // });
            }

            return Scaffold(
              backgroundColor: Colors.white,
              // appBar: AppBar(
              //   toolbarHeight: 100,
              //   flexibleSpace: Padding(
              //     padding:
              //         EdgeInsets.symmetric(horizontal: w1p * 4, vertical: 12),
              //     child: SafeArea(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           SizedBox(
              //               width: w1p * 25,
              //               child:
              //                   Image.asset("assets/images/logo-with-text.png")),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.end,
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               InkWell(
              //                   onTap: () async {
              //                     await Navigator.push(
              //                         context,
              //                         MaterialPageRoute(
              //                             builder: (_) =>
              //                                 const NotificationsScreen()));
              //                     getIt<HomeManager>().getDoctorAppDetails();
              //                   },
              //                   child: Container(
              //                     width: 40,
              //                     height: 40,
              //                     child: Stack(
              //                       alignment: Alignment.center,
              //                       children: [
              //                         const Icon(
              //                           Icons.notifications_none_sharp,
              //                           color: Colors.white,
              //                           size: 30,
              //                         ),
              //                         appStatus?.unreadNotificationCount !=
              //                                     null &&
              //                                 appStatus
              //                                         ?.unreadNotificationCount !=
              //                                     0
              //                             ? Align(
              //                                 alignment: Alignment.topRight,
              //                                 child: Container(
              //                                   margin: const EdgeInsets.all(4),
              //                                   decoration: BoxDecoration(
              //                                       color: Colours.callRed,
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               10)),
              //                                   child: Text(
              //                                     " ${appStatus?.unreadNotificationCount ?? 0} ",
              //                                     style: TextStyles.textStyle17,
              //                                   ),
              //                                 ))
              //                             : const SizedBox(),
              //                       ],
              //                     ),
              //                   )),
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Text(
              //                     "Instant Availability",
              //                     style: t400_12,
              //                   ),
              //                   Padding(
              //                     padding: const EdgeInsets.only(left: 8),
              //                     child: ToggleSwitch(
              //                       minHeight: 20,
              //                       borderColor: const [
              //                         Colors.white,
              //                         Colors.white
              //                       ],
              //                       borderWidth: 1,
              //                       minWidth: 38.0,
              //                       cornerRadius: 15.0,
              //                       activeBgColors: [
              //                         [Colors.red[800]!],
              //                         [Colors.green[800]!],
              //                       ],
              //                       activeFgColor: Colors.white,
              //                       inactiveBgColor: Colours.primaryblue,
              //                       customTextStyles: const [
              //                         TextStyles.textStyle50b,
              //                         TextStyles.textStyle50b,
              //                       ],
              //                       inactiveFgColor: Colors.white,
              //                       initialLabelIndex:
              //                           appStatus?.doctorInstantAvailability ==
              //                                   true
              //                               ? 1
              //                               : 0,
              //                       totalSwitches: 2,
              //                       labels: const ['OFF', 'ON'],
              //                       radiusStyle: false,
              //                       onToggle: (index) async {
              //                         // getIt<StateManager>().setOnlineAvailablity(index!);

              //                         var result = await getIt<HomeManager>()
              //                             .setOnlineStatus(index: index!);

              //                         if (result.status == true) {
              //                           showDialog(
              //                             context: context,
              //                             builder: (context) =>
              //                                 OnlineStatusAlertBox(
              //                                     result.message ?? ""),
              //                           );
              //                           await getIt<HomeManager>()
              //                               .getDoctorAppDetails();
              //                         } else {
              //                           showDialog(
              //                             context: context,
              //                             builder: (context) =>
              //                                 OnlineStatusAlertBox(
              //                                     result.message ?? ""),
              //                           );
              //                           await getIt<HomeManager>()
              //                               .getDoctorAppDetails();
              //                         }
              //                       },
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   backgroundColor: Colours.primaryblue,
              // ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    systemOverlayStyle: SystemUiOverlayStyle.light,
                    expandedHeight: kToolbarHeight * 2,
                    collapsedHeight: kToolbarHeight * 2,
                    pinned: true,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        ),
                        gradient: LinearGradient(colors: gradientColors),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: w1p * 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            const Spacer(),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final data =
                                          getIt<AuthManager>().docDetailsModel;
                                      log(data.toString());
                                    },
                                    child: SizedBox(
                                      width: w1p * 25,
                                      child: Image.asset(
                                        "assets/images/logo-with-text.png",
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const NotificationsScreen(),
                                            ),
                                          );
                                          getIt<HomeManager>()
                                              .getDoctorAppDetails();
                                        },
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              const Icon(
                                                Icons.notifications_none_sharp,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              appStatus?.unreadNotificationCount !=
                                                          null &&
                                                      appStatus
                                                              ?.unreadNotificationCount !=
                                                          0
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colours.callRed,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          " ${appStatus?.unreadNotificationCount ?? 0} ",
                                                          style: TextStyles
                                                              .textStyle17,
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Instant Availability", style: t700_16),

                                  // ElevatedButton(
                                  //   onPressed: () async {
                                  //     try {
                                  //       await localNotifications.show(
                                  //         0,
                                  //         'Hello',
                                  //         'This is a test',
                                  //         const NotificationDetails(
                                  //           android: AndroidNotificationDetails(
                                  //             'high_importance_channel',
                                  //             'High Importance Notifications',
                                  //             channelDescription:
                                  //                 'General notifications',
                                  //             importance: Importance.high,
                                  //           ),
                                  //           iOS: DarwinNotificationDetails(
                                  //             presentAlert: true,
                                  //             presentSound: true,
                                  //             presentBadge: true,
                                  //           ),
                                  //         ),
                                  //       );
                                  //       log("notificaiontz");
                                  //     } on Exception catch (e) {
                                  //       // TODO
                                  //       log(e.toString());
                                  //     }
                                  //   },
                                  //   child: Text('Test Notification'),
                                  // ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: ToggleSwitch(
                                          minHeight: 30,
                                          borderColor: const [
                                            Colors.white,
                                            Colors.white,
                                          ],
                                          borderWidth: 1,
                                          minWidth: 50.0,
                                          cornerRadius: 15.0,
                                          activeBgColors: [
                                            [Colors.red[800]!],
                                            [Colors.green[800]!],
                                          ],
                                          activeFgColor: Colors.white,
                                          inactiveBgColor: Colours.primaryblue,
                                          customTextStyles: const [
                                            TextStyle(
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Marvel",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0,
                                            ),
                                            TextStyle(
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Marvel",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 12.0,
                                            ),
                                          ],
                                          inactiveFgColor: Colors.white,
                                          initialLabelIndex:
                                              appStatus
                                                      ?.doctorInstantAvailability ==
                                                  true
                                              ? 1
                                              : 0,
                                          totalSwitches: 2,
                                          labels: const ['OFF', 'ON'],
                                          radiusStyle: false,
                                          onToggle: (index) async {
                                            // getIt<StateManager>().setOnlineAvailablity(index!);

                                            var result =
                                                await getIt<HomeManager>()
                                                    .setOnlineStatus(
                                                      index: index!,
                                                    );

                                            if (result.status == true) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    OnlineStatusAlertBox(
                                                      result.message ?? "",
                                                    ),
                                              );
                                              await getIt<HomeManager>()
                                                  .getDoctorAppDetails();
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    OnlineStatusAlertBox(
                                                      result.message ?? "",
                                                    ),
                                              );
                                              await getIt<HomeManager>()
                                                  .getDoctorAppDetails();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            verticalSpace(5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        getIt<HomeManager>().initFns();
                        // getIt<OnlineConsultManager>().getPatientRequestList();
                        // getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
                        // getIt<OnlineConsultManager>().getRecentPatientsList();
                      },
                      child: Entry(
                        yOffset: -100,
                        // opacity: .5,
                        // angle: 3.1415,
                        delay: const Duration(milliseconds: 0),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.decelerate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(width: 34,height: 34,color: Colors.redAccent,),
                            mgr.patientsReqList.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: h1p,
                                      horizontal: w1p * 4,
                                    ),
                                    child: Text(
                                      "Online consultation request",
                                      style: TextStyles.textStyle5,
                                    ),
                                  )
                                : const SizedBox(),

                            mgr.patientsReqLoader == true
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: h10p,
                                    ),
                                    child: const Center(child: LogoLoader()),
                                  )
                                : mgr.patientsReqList.isNotEmpty
                                ? Column(
                                    children: mgr.patientsReqList
                                        .map(
                                          (e) => Stack(
                                            children: [
                                              OnlineRequestBox(
                                                consultFn: () async {
                                                  FlutterRingtonePlayer()
                                                      .stop();

                                                  getIt<OnlineConsultManager>()
                                                      .setConsultLoader(true);
                                                  var result =
                                                      await getIt<
                                                            OnlineConsultManager
                                                          >()
                                                          .acceptPatientRequest(
                                                            e.id!,
                                                          );
                                                  if (result.status == true) {
                                                    getIt<
                                                          OnlineConsultManager
                                                        >()
                                                        .disposePriscrip();

                                                    // await getIt<OnlineConsultManager>().getPatientRequestList();
                                                    //  Navigator.push(context, MaterialPageRoute(builder: (_)=>OnlineConsultLanding(appoinmentId: e.appoinmentId!,directToCall: true, bookingId:result.bookingId!)));

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => ChatPage(
                                                          appId:
                                                              e.appoinmentId!,
                                                          bookingId:
                                                              result.bookingId!,
                                                          isCallAvailable: true,
                                                          isDirectToCall: true,
                                                        ),
                                                      ),
                                                    );

                                                    getIt<
                                                          OnlineConsultManager
                                                        >()
                                                        .getRecentPatientsList();
                                                  } else {
                                                    await getIt<
                                                          OnlineConsultManager
                                                        >()
                                                        .getPatientRequestList();

                                                    Fluttertoast.showToast(
                                                      msg: result.message ?? "",
                                                    );
                                                  }
                                                  getIt<OnlineConsultManager>()
                                                      .setConsultLoader(false);
                                                },
                                                declineFn: () async {
                                                  FlutterRingtonePlayer()
                                                      .stop();

                                                  getIt<OnlineConsultManager>()
                                                      .setConsultLoader(true);

                                                  var result =
                                                      await getIt<
                                                            OnlineConsultManager
                                                          >()
                                                          .rejectPatientCall(
                                                            e.id!,
                                                          );
                                                  if (result.status == true) {
                                                    getIt<
                                                          OnlineConsultManager
                                                        >()
                                                        .getPatientRequestList();
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg: result.message ?? "",
                                                    );
                                                  }
                                                  getIt<OnlineConsultManager>()
                                                      .setConsultLoader(false);
                                                },
                                                h1p: h1p,
                                                w1p: w1p,
                                                patientGender: e.gender ?? "-",
                                                patientAge: e.age.toString(),
                                                patientName: e.firstName ?? "",
                                              ),
                                              loader == true
                                                  ? Container(
                                                      width: maxWidth,
                                                      color: Colors.black26,
                                                      child: const Center(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: LogoLoader(),
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),

                                          // Container(width: 34,height: 34,color: Colors.redAccent,)
                                        )
                                        .toList(),
                                  )
                                : const SizedBox(),

                            pad(
                              horizontal: w1p * 4,
                              vertical: h1p * 2,
                              child: Text(
                                "Scheduled bookings",
                                style: t700_18.copyWith(color: Colors.black),
                              ),
                            ),

                            pad(
                              horizontal: w1p * 0,
                              child: EasyInfiniteDateTimeLine(
                                dayProps: dayDropsStyle(height: 100),
                                activeColor: Colours.primaryblue,
                                controller: controller,
                                showTimelineHeader: false,
                                firstDate: DateTime.now(),
                                focusDate: mgr.selectedDt,
                                lastDate: DateTime.now().add(
                                  const Duration(days: 60),
                                ),
                                onDateChange: (selectedDate) {
                                  getIt<OnlineConsultManager>()
                                      .getScheduledBookings(selectedDate);
                                },
                              ),
                            ),
                            verticalSpace(h1p * 0.5),

                            mgr.scheduledBookloader
                                ? myLoader(
                                    width: maxWidth,
                                    height: h10p * 3,
                                    visibility: true,
                                  )
                                : mgr.upcomingAppointments!.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: h10p,
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            radius: 50,
                                            child: Icon(
                                              Icons.calendar_month,
                                              size: 50,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          verticalSpace(5),
                                          Text(
                                            "You have no appointments",
                                            style: t500_16.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SizedBox(
                                      // height: h10p*3,
                                      child: Column(
                                        children: mgr.upcomingAppointments!
                                            .map(
                                              (e) => Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 2.0,
                                                  top: 2,
                                                ),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            BookingDetailsScreen(
                                                              e.id,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: AppoinmentsHomeScreenItem(
                                                    bookingStatus:
                                                        e.bookingStatus,
                                                    bookingType: e.bookingType,
                                                    loadingBookingId:
                                                        mgr.loaderBookingId,
                                                    bookingId: e.id,
                                                    appointmentId:
                                                        e.appointmentId,
                                                    bookingStartTime:
                                                        DateTime.tryParse(
                                                          e.bookingStartTime ??
                                                              "",
                                                        ),
                                                    bookingEndTime:
                                                        DateTime.tryParse(
                                                          e.bookingEndTime ??
                                                              "",
                                                        ),
                                                    h1p: h1p,
                                                    w1p: w1p,
                                                    patientGender:
                                                        e.patientGender ?? "",
                                                    subtitle:
                                                        e.speciality ??
                                                        e.subSpeciality ??
                                                        "",
                                                    patientName:
                                                        e.patientFirstName ??
                                                        "",
                                                    patientAge: e.patientAge
                                                        .toString(),
                                                    dTime: e.time ?? "",
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),

                            mgr.recentPatients != null &&
                                    mgr.recentPatients!.isNotEmpty
                                ? pad(
                                    horizontal: w1p * 4,
                                    vertical: h1p,
                                    child: Text(
                                      "Recent patients",
                                      style: TextStyles.textStyle6,
                                    ),
                                  )
                                : const SizedBox(),

                            mgr.recentPatients != null &&
                                    mgr.recentPatients!.isNotEmpty
                                ? pad(
                                    horizontal: w1p * 4,
                                    child: Column(
                                      children: mgr.recentPatients!
                                          .map(
                                            (e) => GestureDetector(
                                              onTap: () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: 'temporary',bookingId: 0000,isCallAvailable: false,)));
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        BookingDetailsScreen(
                                                          e.bookingId,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: RecentPatientBox(
                                                h1p: h1p,
                                                w1p: w1p,
                                                data: e,
                                                btnClick: () {
                                                  bool isConsultNow =
                                                      DateTime.now().isBefore(
                                                        DateTime.parse(
                                                          e.endDateTime!,
                                                        ),
                                                      );
                                                  getIt<OnlineConsultManager>()
                                                      .disposePriscrip();

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => ChatPage(
                                                        appId: e.appointmentId!,
                                                        bookingId: e.bookingId!,
                                                        isCallAvailable:
                                                            isConsultNow,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class CustomTransitionDialog extends StatefulWidget {
  const CustomTransitionDialog({super.key});

  @override
  _CustomTransitionDialogState createState() => _CustomTransitionDialogState();
}

class _CustomTransitionDialogState extends State<CustomTransitionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Enter Your Name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 50, color: Colors.indigo),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type your name here',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              String name = _textController.text;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    name.isEmpty
                        ? 'You didn\'t enter a name!'
                        : 'Hello, $name!',
                  ),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class OnlineStatusAlertBox extends StatelessWidget {
  final String message;
  const OnlineStatusAlertBox(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Alert', style: TextStyles.scrollWheelSelected),
      content: Text(message, style: t400_16.copyWith(color: clr2D2D2D)),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: clr5A6BE2,
              boxShadow: [
                BoxShadow(
                  color: clr757575.withOpacity(0.2),
                  offset: const Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 16,
              ),
              child: Text('Done', style: t500_16),
            ),
          ),
        ),
      ],
    );
  }
}
