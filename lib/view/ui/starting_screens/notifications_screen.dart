import 'package:dqueuedoc/controller/managers/home_manager.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:dqueuedoc/view/ui/starting_screens/forum_details_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/patient_details_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_expandable_text/expandable_text.dart';
import 'package:provider/provider.dart';

import '../../../model/core/notifications_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
// DateTime _selectedDate = DateTime.now();
  int index = 1;

  @override
  void initState() {
    // getIt<OnlineConsultManager>().getPatientRequestList();
    getIt<HomeManager>().getNotifications(index: index);
    getIt<HomeManager>().notificationStatusChange();

    // getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      index++;
      getIt<HomeManager>().getNotifications(index: index);
    }
  }

  navigateNotification(Notifications notif) {
    if (notif.moduleId != null && notif.moduleId != 0) {
      switch (notif.module) {
        case 'Booking':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookingDetailsScreen(
                      notif.moduleId,
                    )),
          );
          break;
        case 'Public forum':
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ForumDetailsScreen(forumId: notif.moduleId!)),
          );
          break;

        // case 'dashboard':
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => DashboardScreen()),
        //   );
        //   break;
        default:
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomeScreen()),
          // );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<HomeManager>(builder: (context, mgr, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                  title: "Notifications",
                  height: h10p * 0.9,
                  width: w10p,
                  fn: () {
                    Navigator.pop(context);
                  }),
              body: RefreshIndicator(
                  onRefresh: () async {
                    // getIt<OnlineConsultManager>().getPatientRequestList();
                    // getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
                    getIt<HomeManager>().getNotifications(index: 1);
                  },
                  child: Entry(
                    yOffset: -100,
                    // opacity: .5,
                    // angle: 3.1415,
                    delay: const Duration(milliseconds: 0),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,
                    child: ListView(controller: _controller, children: [
                      // mgr.consultations!=null && mgr.consultations!.isNotEmpty?
                      // pad(horizontal: w1p*4,vertical: h1p,
                      //     child: Text("Recent patients",style: TextStyles.textStyle6,)):SizedBox(),

                      verticalSpace(h1p),
                      mgr.notificationLoader != true &&
                              mgr.notificationsModel.notifications != null &&
                              mgr.notificationsModel.notifications!.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: h10p),
                              child: Center(
                                child: Text(
                                  "No notifications found",
                                  style: TextStyles.textStyle2,
                                ),
                              ),
                            )
                          : mgr.notificationsModel.notifications != null &&
                                  mgr.notificationsModel.notifications!
                                      .isNotEmpty
                              ? pad(
                                  horizontal: w1p * 4,
                                  child: Column(
                                      children: mgr
                                          .notificationsModel.notifications!
                                          .map((e) {
                                    String date = getIt<StateManager>()
                                        .getMonthDay(
                                            DateTime.parse(e.dateTime!));
                                    String time = getIt<StateManager>()
                                        .getTimeFromDTime(
                                            DateTime.parse(e.dateTime!));
                                    var indx = mgr
                                        .notificationsModel.notifications!
                                        .indexOf(e);
                                    return InkWell(
                                      onTap: () {
                                        navigateNotification(e);

                                        // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: 'temporary',bookingId: 0000,isCallAvailable: false,)));
                                      },
                                      child: Column(
                                        children: [
                                          NotificationItem(
                                              h1p: h1p,
                                              title: e.title ?? "",
                                              subtitle: e.body ?? "",
                                              w1p: w1p,
                                              img: "e.",
                                              date: date,
                                              sheduledTime: time),
                                          mgr.notificationLoader == true &&
                                                  mgr.notificationsModel
                                                          .notifications !=
                                                      null &&
                                                  indx ==
                                                      mgr
                                                              .notificationsModel
                                                              .notifications!
                                                              .length -
                                                          1
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : const SizedBox()
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(vertical: h10p),
                                  child: Center(child: AppLoader()),
                                )
                    ]),
                  )));
        });
      }),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String date;
  // int? bookingID;
  final String title;
  final String subtitle;
  // String appoinmentId;
  final String img;
  // bool isOnline;
  // String gender;
  // String age;
  final String sheduledTime;
  // String patienttitle;
  // DateTime? startTime;
  // DateTime? endTime;
  const NotificationItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.sheduledTime,
    // required this.bookingID,
    // required this.appoinmentId,
    required this.date,
    // required this.gender,
    // required this.age,
    // required this.isOnline,
    // required this.patienttitle,
    // required this.isApplicable,
    required this.title,
    required this.subtitle,
    // required this.startTime,
    // required this.endTime,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF9F9F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w1p * 3),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pad(
                    horizontal: w1p * 1,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // gradient: linearGrad2,
                        boxShadow: const [
                          // BoxShadow(spreadRadius: 5, blurRadius: 11,color: Colors.grey.withOpacity(0.2),
                          // offset: Offset(-2,2)
                          // )
                        ],
                        borderRadius: BorderRadius.circular(20),
                        // shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/images/appicon.svg"),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpace(w1p * 2),
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            title,
                            style: TextStyles.notif1,
                          ),
                          // Text(subtitle??"",style: TextStyles.notif2,maxLines: 2,overflow:TextOverflow.ellipsis ,),
                          GenericExpandableText(
                            textAlign: TextAlign.start,
                            subtitle,
                            style: TextStyles.notif2,
                            readlessColor: Colours.primaryblue,
                            readmoreColor: Colours.primaryblue,
                            hasReadMore: true,
                            maxLines: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date,
                      style: TextStyles.consult4,
                    ),
                    horizontalSpace(w1p),
                    Text(
                      sheduledTime,
                      style: TextStyles.consult4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
