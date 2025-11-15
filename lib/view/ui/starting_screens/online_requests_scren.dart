import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../chat_screen.dart';
import '../zoom_screens/call_screen.dart';

class OnlineReqScreen extends StatefulWidget {
  const OnlineReqScreen({Key? key}) : super(key: key);

  @override
  State<OnlineReqScreen> createState() => _OnlineStateReqScreen();
}

class _OnlineStateReqScreen extends State<OnlineReqScreen>
    with SingleTickerProviderStateMixin {
  // DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    getIt<OnlineConsultManager>().getPatientRequestList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxHeight = constraints.maxHeight;
          double maxWidth = constraints.maxWidth;
          double h1p = maxHeight * 0.01;
          double h10p = maxHeight * 0.1;
          double w10p = maxWidth * 0.1;
          double w1p = maxWidth * 0.01;

          return Consumer<OnlineConsultManager>(
            builder: (context, mgr, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: getIt<SmallWidgets>().appBarWidget(
                  title: "Online Consultation Requests",
                  height: h10p * 0.9,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  },
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await getIt<OnlineConsultManager>()
                          .getPatientRequestList();
                    },
                    child: ListView(
                      children: [
                        // Container(width: 34,height: 34,color: Colors.redAccent,),
                        mgr.patientsReqLoader == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: h10p),
                                child: Center(child: AppLoader()),
                              )
                            : mgr.patientsReqList.isNotEmpty
                            ? Column(
                                children: mgr.patientsReqList
                                    .map(
                                      (e) => OnlineRequestBox(
                                        consultFn: () async {
                                          var result =
                                              await getIt<
                                                    OnlineConsultManager
                                                  >()
                                                  .acceptPatientRequest(e.id!);
                                          if (result.status == true) {
                                            // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: e.appoinmentId!,bookingId: result.bookingId!)));

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ChatPage(
                                                  appId: e.appoinmentId!,
                                                  isDirectToCall: true,
                                                  bookingId: result.bookingId!,
                                                ),
                                              ),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: result.message ?? "",
                                            );
                                          }
                                        },
                                        declineFn: () async {
                                          var result =
                                              await getIt<
                                                    OnlineConsultManager
                                                  >()
                                                  .rejectPatientCall(e.id!);
                                          if (result.status == true) {
                                            getIt<OnlineConsultManager>()
                                                .getPatientRequestList();
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: result.message ?? "",
                                            );
                                          }
                                        },
                                        h1p: h1p,
                                        w1p: w1p,
                                        patientGender: e.gender ?? "-",
                                        patientAge: e.age.toString(),
                                        patientName: e.firstName ?? "",
                                      ),

                                      // Container(width: 34,height: 34,color: Colors.redAccent,)
                                    )
                                    .toList(),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(vertical: h10p),
                                child: Center(
                                  child: Text(
                                    "No Requests found",
                                    style: TextStyles.textStyle2,
                                  ),
                                ),
                              ),

                        // InkWell(
                        //
                        //     onTap:(){
                        //
                        //
                        //       Navigator.push(context,MaterialPageRoute(builder: (_)=>CallScreen(
                        //           displayName: "sdsds",role: "1",isJoin: true,sessionIdleTimeoutMins: "40",sessionName: "qwerty",sessionPwd: "qwerty123")));
                        //
                        //               },child: Center(child: Text("start call"))),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CallRequestPopup extends StatefulWidget {
  final String name;
  final String img;
  // String qualification;
  final int bookingId;
  // int docId;
  final String appoinmentId;
  final bool inChatStatus;
  final int tempBookingId;

  // double ma
  const CallRequestPopup({
    super.key,
    required this.name,
    // required this.qualification,
    required this.img,
    // required this.docId,
    required this.appoinmentId,
    required this.bookingId,
    required this.inChatStatus,
    required this.tempBookingId,
  });

  @override
  State<CallRequestPopup> createState() => _CallRequestPopupState();
}

class _CallRequestPopupState extends State<CallRequestPopup> {
  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer().playRingtone();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double h1p = maxHeight * 0.01;
    // double h10p = maxHeight * 0.1;
    // double w10p = maxWidth * 0.1;
    // double w1p = maxWidth * 0.01;

    Widget btn({required bool isAcceptBtn}) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isAcceptBtn == true
              ? const Color(0xff00b94d)
              : const Color(0xfff03a14),
        ),
        child: pad(
          horizontal: 18,
          vertical: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                child: Image.asset(
                  isAcceptBtn == true
                      ? "assets/images/accept_call.png"
                      : "assets/images/decline_call.png",
                  color: Colors.white,
                ),
              ),
              horizontalSpace(4),
              Text(
                isAcceptBtn == true ? "Accept" : "Decline",
                style: TextStyles.textStyle42,
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      child: Container(
        color: Colors.white,
        // extendBody: true,
        // backgroundColor: Colors.r=tr,
        child: SizedBox(
          child: pad(
            horizontal: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: '${StringConstants.baseUrl}${widget.img}',
                          placeholder: (context, url) => Image.asset(
                            "assets/images/doctor-placeholder.jpg",
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/doctor-placeholder.jpg",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(8),
                Text(widget.name, style: TextStyles.textStyledoc1),

                verticalSpace(8),

                // Text(qualification,style: TextStyles.textStyledoc2,),
                // verticalSpace(8),
                const Text('is calling you...', style: TextStyles.textStyle34),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          getIt<OnlineConsultManager>().cancelInitiatedBooking(
                            bookingId: widget.tempBookingId,
                          );
                        },
                        child: btn(isAcceptBtn: false),
                      ),
                    ),
                    horizontalSpace(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: InkWell(
                        onTap: () {
                          if (widget.inChatStatus == true) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CallScreen(
                                  displayName:
                                      getIt<SharedPreferences>().getString(
                                        StringConstants.userName,
                                      ) ??
                                      "Unknown",
                                  role: "0",
                                  isJoin: true,
                                  sessionIdleTimeoutMins: "40",
                                  sessionName: widget.appoinmentId,
                                  sessionPwd: 'Qwerty123',
                                  bookingId: widget.bookingId,
                                ),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(
                                  appId: widget.appoinmentId,
                                  isCallAvailable: true,
                                  bookingId: widget.bookingId,
                                  isDirectToCall: true,
                                ),
                              ),
                            );
                          }

                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ChatSc()));
                        },
                        child: btn(isAcceptBtn: true),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
