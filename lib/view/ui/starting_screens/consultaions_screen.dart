import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:dqueuedoc/view/ui/starting_screens/patient_details_screen.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../model/core/consultations_list__model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'analytics_screen.dart';

class ConsultaionsScreen extends StatefulWidget {
  // bool? isFilterOn;
  final bool? hideBackBtn;
  const ConsultaionsScreen({super.key, this.hideBackBtn});

  @override
  State<ConsultaionsScreen> createState() => _ConsultaionsScreenState();
}

class _ConsultaionsScreenState extends State<ConsultaionsScreen> {
  // DateTime _selectedDate = DateTime.now();
  //   int index = 1;

  @override
  void initState() {
    // getIt<OnlineConsultManager>().getPatientRequestList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<OnlineConsultManager>().getConsultations(isRefresh: true);
    });
    // getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    getIt<OnlineConsultManager>().setDateInteval(isDispose: true);

    super.dispose();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // print("pagination");
      // index++;
      getIt<OnlineConsultManager>().getConsultations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<OnlineConsultManager>(
          builder: (context, mgr, child) {
            List<Consultations>? consultations =
                mgr.consultationsModel?.consultations ?? [];

            return Scaffold(
              backgroundColor: Colors.white,
              body: RefreshIndicator(
                onRefresh: () async {
                  getIt<OnlineConsultManager>().getConsultations(
                    isRefresh: true,
                  );
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: kToolbarHeight + 15,
                      collapsedHeight: kToolbarHeight + kToolbarHeight,
                      pinned: true,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: gradientColors),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),

                              GestureDetector(
                                onTap: () {
                                  // Navigator.pop(context);
                                  // Navigator.popUntil(context, ModalRoute.withName(RouteNames.home));
                                },
                                child: Row(
                                  children: [
                                    // SizedBox(
                                    //     height: 20,
                                    //     child: Image.asset(
                                    //       "assets/images/back-cupertino.png",
                                    //       color: Colors.white,
                                    //       // colorFilter: ColorFilter.mode(
                                    //       //     clrFFFFFF, BlendMode.srcIn),
                                    //     )),
                                    // horizontalSpace(12),
                                    Text("My Consultations", style: t500_20),
                                    // Text(
                                    //       "Consultations",
                                    //       style: t500_20,
                                    //     ),
                                  ],
                                ),
                              ),
                              verticalSpace(16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 4,
                                          ),
                                          child: Text(
                                            "Total Bookings : ${mgr.consultationsModel?.totalBookingCount ?? 0}",
                                            style: TextStyles.textStyle22
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            PickerDateRange?
                                            result = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CalenderWidget();
                                              },
                                            );

                                            if (result != null) {
                                              // getIt<SettlementsManager>().doctorWeeklySettles(startDate: result.startDate,endDate: result.endDate,);
                                              getIt<OnlineConsultManager>()
                                                  .setDateInteval(
                                                    startDay: result.startDate,
                                                    endDay: result.endDate,
                                                  );

                                              getIt<OnlineConsultManager>()
                                                  .getConsultations(
                                                    isRefresh: true,
                                                  );
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                                child: VerticalDivider(),
                                              ),
                                              const Icon(
                                                Icons.calendar_month_outlined,
                                                color: Colors.white,
                                              ),
                                              horizontalSpace(8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  mgr
                                                                  .consultationsDateIntervals
                                                                  ?.startDate !=
                                                              null &&
                                                          mgr
                                                                  .consultationsDateIntervals
                                                                  ?.endDate !=
                                                              null
                                                      ? Text(
                                                          "${getIt<StateManager>().getMonthDay(mgr.consultationsDateIntervals!.startDate!)} - ${getIt<StateManager>().getMonthDay(mgr.consultationsDateIntervals!.endDate!)}",
                                                          style: TextStyles
                                                              .textStyledoc2
                                                              .copyWith(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        )
                                                      : Text(
                                                          "Select Date",
                                                          style: TextStyles
                                                              .textStyledoc2
                                                              .copyWith(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        ),
                                                  horizontalSpace(8),
                                                  mgr
                                                                  .consultationsDateIntervals
                                                                  ?.startDate !=
                                                              null &&
                                                          mgr
                                                                  .consultationsDateIntervals
                                                                  ?.endDate !=
                                                              null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            getIt<
                                                                  OnlineConsultManager
                                                                >()
                                                                .setDateInteval();
                                                            getIt<
                                                                  OnlineConsultManager
                                                                >()
                                                                .getConsultations(
                                                                  isRefresh:
                                                                      true,
                                                                );
                                                          },
                                                          child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: Image.asset(
                                                              "assets/images/icon-close2.png",
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    mgr.isLoading!
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: LogoLoader()),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: consultations.length,
                              (ctx, index) {
                                var e = consultations[index];
                                return ConsultationItem(
                                  loaderBookingID: mgr.loaderBookingId,
                                  isCompleted: e.bookingStatus == "Completed",
                                  h1p: h1p,
                                  gender: e.patientGender ?? "",
                                  age: e.patientAge ?? "",
                                  w1p: w1p,
                                  name: getIt<StateManager>()
                                      .capitalizeFirstLetter(
                                        e.patientFirstName ?? "",
                                      ),
                                  img: "e.",
                                  date: e.date != null
                                      ? getIt<StateManager>().getMonthDay(
                                          DateTime.parse(e.date!),
                                        )
                                      : "",
                                  bookingType: e.bookingType ?? "",
                                  sheduledTime: e.time != null
                                      ? getIt<StateManager>().convertTime(
                                          e.time!,
                                        )
                                      : "",
                                  patientname: e.patientFirstName ?? "",
                                  appoinmentId: e.appointmentId ?? "",
                                  bookingID: e.id,
                                );
                              },
                            ),
                          ),
                    // : SliverToBoxAdapter(
                    //     child: Entry(
                    //       yOffset: -100,
                    //       // opacity: .5,
                    //       // angle: 3.1415,
                    //       delay: const Duration(milliseconds: 0),
                    //       duration: const Duration(milliseconds: 1500),
                    //       curve: Curves.decelerate,

                    //       // child: ListView(controller: _controller,
                    //       // child: Column(
                    //       //     mainAxisSize: MainAxisSize.min,

                    //       //     // controller: _controller,
                    //       //     children: [
                    //       //       Padding(
                    //       //         padding:
                    //       //             const EdgeInsets.symmetric(vertical: 8.0),
                    //       //         child: Row(
                    //       //           mainAxisAlignment:
                    //       //               MainAxisAlignment.spaceBetween,
                    //       //           children: [
                    //       //             Expanded(
                    //       //               child: SizedBox(
                    //       //                 child: Padding(
                    //       //                   padding: EdgeInsets.symmetric(
                    //       //                       horizontal: w1p * 4),
                    //       //                   child: Text(
                    //       //                     "Total Bookings : ${mgr.consultationsModel?.totalBookingCount ?? 0}",
                    //       //                     style: TextStyles.textStyle22,
                    //       //                   ),
                    //       //                 ),
                    //       //               ),
                    //       //             ),
                    //       //             Expanded(
                    //       //               child: Container(
                    //       //                 decoration: const BoxDecoration(
                    //       //                     borderRadius:
                    //       //                         BorderRadius.vertical(
                    //       //                             top:
                    //       //                                 Radius.circular(10))),
                    //       //                 child: InkWell(
                    //       //                   onTap: () async {
                    //       //                     PickerDateRange? result =
                    //       //                         await showDialog(
                    //       //                       context: context,
                    //       //                       builder:
                    //       //                           (BuildContext context) {
                    //       //                         return CalenderWidget();
                    //       //                       },
                    //       //                     );

                    //       //                     if (result != null) {
                    //       //                       // getIt<SettlementsManager>().doctorWeeklySettles(startDate: result.startDate,endDate: result.endDate,);
                    //       //                       getIt<OnlineConsultManager>()
                    //       //                           .setDateInteval(
                    //       //                         startDay: result.startDate,
                    //       //                         endDay: result.endDate,
                    //       //                       );

                    //       //                       getIt<OnlineConsultManager>()
                    //       //                           .getConsultations(
                    //       //                               isRefresh: true);
                    //       //                     }
                    //       //                   },
                    //       //                   child: Row(
                    //       //                     children: [
                    //       //                       const SizedBox(
                    //       //                           height: 15,
                    //       //                           child: VerticalDivider()),
                    //       //                       const Icon(
                    //       //                           Icons
                    //       //                               .calendar_month_outlined,
                    //       //                           color: Colors.grey),
                    //       //                       horizontalSpace(8),
                    //       //                       Row(
                    //       //                         mainAxisAlignment:
                    //       //                             MainAxisAlignment
                    //       //                                 .spaceBetween,
                    //       //                         children: [
                    //       //                           mgr.consultationsDateIntervals
                    //       //                                           ?.startDate !=
                    //       //                                       null &&
                    //       //                                   mgr.consultationsDateIntervals
                    //       //                                           ?.endDate !=
                    //       //                                       null
                    //       //                               ? Text(
                    //       //                                   "${getIt<StateManager>().getMonthDay(mgr.consultationsDateIntervals!.startDate!)} - ${getIt<StateManager>().getMonthDay(mgr.consultationsDateIntervals!.endDate!)}",
                    //       //                                   style: TextStyles
                    //       //                                       .textStyledoc2)
                    //       //                               : Text("Select Date",
                    //       //                                   style: TextStyles
                    //       //                                       .textStyledoc2),
                    //       //                           horizontalSpace(8),
                    //       //                           mgr.consultationsDateIntervals
                    //       //                                           ?.startDate !=
                    //       //                                       null &&
                    //       //                                   mgr.consultationsDateIntervals
                    //       //                                           ?.endDate !=
                    //       //                                       null
                    //       //                               ? GestureDetector(
                    //       //                                   onTap: () {
                    //       //                                     getIt<OnlineConsultManager>()
                    //       //                                         .setDateInteval();
                    //       //                                     getIt<OnlineConsultManager>()
                    //       //                                         .getConsultations(
                    //       //                                             isRefresh:
                    //       //                                                 true);
                    //       //                                   },
                    //       //                                   child: SizedBox(
                    //       //                                       width: 20,
                    //       //                                       height: 20,
                    //       //                                       child: Image.asset(
                    //       //                                           "assets/images/icon-close2.png")))
                    //       //                               : const SizedBox()
                    //       //                         ],
                    //       //                       ),
                    //       //                     ],
                    //       //                   ),
                    //       //                 ),
                    //       //               ),
                    //       //             ),
                    //       //           ],
                    //       //         ),
                    //       //       ),
                    //       //       // mgr.consultations!=null && mgr.consultations!.isNotEmpty?
                    //       //       // pad(horizontal: w1p*4,vertical: h1p,
                    //       //       //     child: Text("Recent patients",style: TextStyles.textStyle6,)):SizedBox(),

                    //       //       verticalSpace(h1p),

                    //       //       Expanded(
                    //       //           child: SizedBox(
                    //       //         child:
                    //       //             mgr.paginationLoader != true &&
                    //       //                     consultations.isEmpty
                    //       //                 ? Padding(
                    //       //                     padding: EdgeInsets.symmetric(
                    //       //                         vertical: h10p),
                    //       //                     child: Center(
                    //       //                       child: Text(
                    //       //                         "No Consultations found",
                    //       //                         style: TextStyles.textStyle2,
                    //       //                       ),
                    //       //                     ),
                    //       //                   )
                    //       //                 : consultations.isNotEmpty
                    //       //                     ? pad(
                    //       //                         child: ListView(
                    //       //                             controller: _controller,
                    //       //                             children: consultations
                    //       //                                 .map((e) {
                    //       //                               var index =
                    //       //                                   consultations
                    //       //                                       .indexOf(e);
                    //       //                               return Column(
                    //       //                                 children: [
                    //       //                                   InkWell(
                    //       //                                     onTap: () {
                    //       //                                       // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: 'temporary',bookingId: 0000,isCallAvailable: false,)));
                    //       //                                     },
                    //       //                                     child: ConsultationItem(
                    //       //                                         loaderBookingID: mgr
                    //       //                                             .loaderBookingId,
                    //       //                                         isCompleted: e
                    //       //                                                 .bookingStatus ==
                    //       //                                             "Completed",
                    //       //                                         h1p: h1p,
                    //       //                                         gender:
                    //       //                                             e.patientGender ??
                    //       //                                                 "",
                    //       //                                         age:
                    //       //                                             e.patientAge ??
                    //       //                                                 "",
                    //       //                                         w1p: w1p,
                    //       //                                         name: getIt<StateManager>()
                    //       //                                             .capitalizeFirstLetter(
                    //       //                                                 e.patientFirstName ??
                    //       //                                                     ""),
                    //       //                                         img: "e.",
                    //       //                                         date: e.date !=
                    //       //                                                 null
                    //       //                                             ? getIt<StateManager>()
                    //       //                                                 .getMonthDay(
                    //       //                                                     DateTime.parse(e.date!))
                    //       //                                             : "",
                    //       //                                         bookingType: e.bookingType ?? "",
                    //       //                                         sheduledTime: e.time != null ? getIt<StateManager>().convertTime(e.time!) : "",
                    //       //                                         patientname: e.patientFirstName ?? "",
                    //       //                                         appoinmentId: e.appointmentId ?? "",
                    //       //                                         bookingID: e.id),
                    //       //                                   ),
                    //       //                                   index ==
                    //       //                                               consultations.length -
                    //       //                                                   1 &&
                    //       //                                           mgr.consultationsModel
                    //       //                                                   ?.next !=
                    //       //                                               null
                    //       //                                       ? const Padding(
                    //       //                                           padding:
                    //       //                                               EdgeInsets.all(
                    //       //                                                   8.0),
                    //       //                                           child: Center(
                    //       //                                               child: CircularProgressIndicator(
                    //       //                                             strokeWidth:
                    //       //                                                 1,
                    //       //                                             color: Colours
                    //       //                                                 .boxblue,
                    //       //                                           )),
                    //       //                                         )
                    //       //                                       : const SizedBox()
                    //       //                                 ],
                    //       //                               );
                    //       //                             }).toList()),
                    //       //                       )
                    //       //                     : Padding(
                    //       //                         padding: EdgeInsets.symmetric(
                    //       //                             vertical: h10p),
                    //       //                         child: Center(
                    //       //                             child: AppLoader()),
                    //       //                       ),
                    //       //       ))
                    //       //     ]),
                    //       child: ListView.builder(
                    //         shrinkWrap: true,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: consultations.length,
                    //         itemBuilder: (context, index) {
                    //           var e = consultations[index];
                    //           return ConsultationItem(
                    //             loaderBookingID: mgr.loaderBookingId,
                    //             isCompleted: e.bookingStatus == "Completed",
                    //             h1p: h1p,
                    //             gender: e.patientGender ?? "",
                    //             age: e.patientAge ?? "",
                    //             w1p: w1p,
                    //             name: getIt<StateManager>()
                    //                 .capitalizeFirstLetter(
                    //                   e.patientFirstName ?? "",
                    //                 ),
                    //             img: "e.",
                    //             date: e.date != null
                    //                 ? getIt<StateManager>().getMonthDay(
                    //                     DateTime.parse(e.date!),
                    //                   )
                    //                 : "",
                    //             bookingType: e.bookingType ?? "",
                    //             sheduledTime: e.time != null
                    //                 ? getIt<StateManager>().convertTime(
                    //                     e.time!,
                    //                   )
                    //                 : "",
                    //             patientname: e.patientFirstName ?? "",
                    //             appoinmentId: e.appointmentId ?? "",
                    //             bookingID: e.id,
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ConsultationItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String date;
  final int? bookingID;
  final int? loaderBookingID;
  final String name;
  final String appoinmentId;
  final String img;
  final String bookingType;
  final String gender;
  final String age;
  final String sheduledTime;
  final String patientname;
  final bool isCompleted;

  // DateTime? startTime;
  // DateTime? endTime;
  const ConsultationItem({
    super.key,
    required this.w1p,
    required this.h1p,
    required this.sheduledTime,
    required this.bookingID,
    required this.loaderBookingID,
    required this.appoinmentId,
    required this.date,
    required this.isCompleted,
    required this.gender,
    required this.age,
    required this.bookingType,
    required this.patientname,
    // required this.isApplicable,
    required this.name,
    // required this.startTime,
    // required this.endTime,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 2),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BookingDetailsScreen(bookingID, hideHealthDetails: true),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: w1p * 4),
          decoration: BoxDecoration(
            boxShadow: [boxShadow8],
            // color: Color(0xffF9F9F9),
            color: const Color(0xffFFFFFF),

            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              pad(
                horizontal: w1p * 2,
                vertical: h1p,
                child: Row(
                  children: [
                    pad(
                      horizontal: w1p * 1,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          gradient: linearGrad2,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colours.primaryblue,
                              // border: Border.,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                gender.toUpperCase() == "MALE"
                                    ? "assets/images/person-man.png"
                                    : "assets/images/person-women.png",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(w1p),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(name, style: TextStyles.consult1b),
                              Text('$gender, $age', style: TextStyles.consult1),

                              // InkWell(
                              //   onTap: (){
                              //     Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingDetailsScreen(bookingID)));
                              //
                              //   },
                              //   child: Container(
                              //       decoration: BoxDecoration(color: Colors.white,
                              //           boxShadow: [boxShadow5],
                              //           border: Border.all(color: Colors.black38,),borderRadius:
                              //       BorderRadius.circular(6)),
                              //       child: pad(horizontal: w1p*2,vertical: w1p*0.5,
                              //         child: Row(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,
                              //           children: [
                              //
                              //             Text("Booking Details",style: TextStyles.consult2,),
                              //
                              //
                              //           ],
                              //         ),
                              //       )),
                              // ),
                              isCompleted != true
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: [
                                          loaderBookingID != bookingID
                                              ? InkWell(
                                                  onTap: () async {
                                                    getIt<
                                                          OnlineConsultManager
                                                        >()
                                                        .loadingSpecificBooking(
                                                          bookingID,
                                                        );
                                                    var res =
                                                        await getIt<
                                                              OnlineConsultManager
                                                            >()
                                                            .confirmCallCompletion(
                                                              bookingID,
                                                            );

                                                    if (res.status == true) {
                                                      getIt<
                                                            OnlineConsultManager
                                                          >()
                                                          .markConsultationStartedLocally(
                                                            bookingID,
                                                          );
                                                    }

                                                    getIt<
                                                          OnlineConsultManager
                                                        >()
                                                        .loadingSpecificBooking(
                                                          null,
                                                        );
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [boxShadow5],
                                                      border: Border.all(
                                                        color: Colors.black38,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: pad(
                                                      horizontal: w1p * 2,
                                                      vertical: w1p * 0.5,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Mark Completed",
                                                            style: TextStyles
                                                                .consult2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          loaderBookingID == bookingID
                                              ? const Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 8.0,
                                                  ),
                                                  child: SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 1,
                                                        ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(date, style: TextStyles.consult4),
                                  horizontalSpace(w1p),
                                  Text(
                                    sheduledTime,
                                    style: TextStyles.consult4,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                                child: VerticalDivider(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: bookingType == "Online"
                                          ? const Color(0xff00C165)
                                          : bookingType == "Scheduled Online"
                                          ? const Color(0xff0075FF)
                                          : const Color(0xff0075FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: bookingType == "Online"
                                          ? Image.asset(
                                              "assets/images/icon-online2.png",
                                              color: Colors.white,
                                            )
                                          : bookingType == "Scheduled Online"
                                          ? Image.asset(
                                              "assets/images/icon-scheduled-online.png",
                                              color: Colors.white,
                                            )
                                          : SvgPicture.asset(
                                              "assets/images/icon-offline.svg",
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
