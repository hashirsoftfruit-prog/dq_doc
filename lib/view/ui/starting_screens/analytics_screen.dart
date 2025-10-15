import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:dqueuedoc/view/ui/starting_screens/consultaions_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/revenue_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/settlement_history_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../controller/managers/settlements_manager.dart';
import '../../../model/core/analytics_model.dart';
import '../../../model/core/revenue_screen_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/text_styles.dart';
import '../chat_screen.dart' hide CloseAlert;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getIt<SettlementsManager>().doctorWeeklySettles();
  }

  @override
  Widget build(BuildContext context) {
    String label = StringConstants.tempIconViewStatus == true ? 'DQ' : 'Medico';

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        getColum(String title, String val) {
          return Container(
            decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.0)),
            margin: const EdgeInsets.all(1),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(title, style: TextStyles.billTxt2)),
                  const Text(":"),
                  Expanded(
                    child: Text(
                      val,
                      style: TextStyles.billTxt2,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        getRow({required String title, required String val}) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyles.analyticsTxt),
                Text('$val Patients', style: TextStyles.analyticsTxt),
              ],
            ),
          );
        }

        subtitle(String title) {
          return Padding(
            padding: EdgeInsets.only(bottom: h1p, top: h1p * 1.5),
            child: Text(title, style: t700_16.copyWith(color: Colors.black)),
          );
        }

        getSettlemBox({
          required String title,
          required String amount,
          required Color textColor,
        }) {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                // gradient: linearGrad1,
                // gradient: LinearGradient(
                //   colors: gradientColors,
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                // ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 0.5,
                    blurRadius: 2,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: t500_14.copyWith(color: Colors.grey.shade600),
                    ),
                    Text(
                      '₹$amount',
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        color: textColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // List<GraphData> data = [
        //   GraphData('MON', 21),
        //   GraphData('TUE', 13),
        //   GraphData('WED', 11),
        //   GraphData('THU', 51),
        //   GraphData('FRI', 16),
        //   GraphData('SAT', 26),
        //   GraphData('SUN', 32)
        // ];
        //
        // List<GraphData> data2 = [
        //   GraphData('MON', 21),
        //   GraphData('TUE', 13),
        //   GraphData('WED', 11),
        //
        // ];

        return Consumer<SettlementsManager>(
          builder: (context, mgr, child) {
            AnalyticsModel? analytModel = mgr.analyticsModel;

            List<GraphData> graphList =
                analytModel?.patientDetails?.dailyPatientCount
                    ?.map(
                      (e) => GraphData(
                        // '${getIt<StateManager>().getMonthDayFromString(e.date??"")}'
                        e.date ?? "",
                        e.dailyBookingsCount ?? 0,
                      ),
                    )
                    .toList() ??
                [];

            String? percChange =
                analytModel?.patientDetails?.percentageChangeFromLastWeek;
            int? patientCount = analytModel?.patientDetails?.totalPatientsCount;
            bool? progressStatus =
                analytModel?.patientDetails?.progressStatusFromLastWeek;
            String? total = analytModel?.totalSettledAmount;
            String? pending = analytModel?.amountToSettle;

            return ProgressHUD(
              indicatorColor: Colors.white,
              backgroundColor: Colours.primaryblue.withOpacity(0.1),
              padding: const EdgeInsets.all(24),
              child: Builder(
                builder: (context) {
                  final progress = ProgressHUD.of(context);
                  return Scaffold(
                    backgroundColor: Colors.white,

                    // appBar: getIt<SmallWidgets>().appBarWidget(
                    //     hideBackBtn: true,
                    //     title: "Analytics",
                    //     height: h10p * 0.9,
                    //     width: w10p,
                    //     fn: () {
                    //       Navigator.pop(context);
                    //     }),
                    body: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          expandedHeight: kToolbarHeight,
                          collapsedHeight: kToolbarHeight,
                          pinned: true,
                          flexibleSpace: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradientColors),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: w1p * 4,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Row(
                                      children: [
                                        Text("Analytics", style: t500_20),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),

                                  // verticalSpace(16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              getIt<SettlementsManager>().doctorWeeklySettles();
                            },
                            child: Column(
                              // shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                    vertical: h1p * 1,
                                  ),
                                  child: Row(
                                    children: [
                                      getSettlemBox(
                                        title: 'Amount to Settle',
                                        amount: pending ?? '0',
                                        textColor: clr5D5AAB,
                                      ),
                                      horizontalSpace(h1p * 1),
                                      getSettlemBox(
                                        title: 'Total Settlements',
                                        amount: total ?? '0',
                                        textColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                    vertical: 0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SettlementHistory(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        // gradient: linearGrad3,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade300,
                                            spreadRadius: 0.5,
                                            blurRadius: 2,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                          bottom: 8,
                                          left: 18.0,
                                          top: 8,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Settlement History',
                                              style: t500_16.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: h1p * 5,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: h1p,
                                                ),
                                                child: SvgPicture.asset(
                                                  "assets/images/forward-arrow.svg",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                verticalSpace(h1p),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      verticalSpace(h1p),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // InkWell(
                                          //     onTap: () async {
                                          //       PickerDateRange? result =
                                          //           await showDialog(
                                          //         context: context,
                                          //         builder:
                                          //             (BuildContext context) {
                                          //           return const CalenderWidget();
                                          //         },
                                          //       );

                                          //       if (result != null) {
                                          //         getIt<SettlementsManager>()
                                          //             .doctorWeeklySettles(
                                          //           startDate: result.startDate,
                                          //           endDate: result.endDate,
                                          //         );
                                          //       }
                                          //     },
                                          //     child: Container(
                                          //       decoration: BoxDecoration(
                                          //           gradient: LinearGradient(
                                          //             colors: gradientColors,
                                          //             begin:
                                          //                 Alignment.bottomCenter,
                                          //             end: Alignment.topCenter,
                                          //           ),
                                          //           borderRadius:
                                          //               const BorderRadius
                                          //                   .vertical(
                                          //                   top: Radius.circular(
                                          //                       10))),
                                          //       child: Padding(
                                          //         padding: EdgeInsets.symmetric(
                                          //             horizontal: 15,
                                          //             vertical: h1p),
                                          //         child: mgr.dateInterval
                                          //                         ?.startDate !=
                                          //                     null &&
                                          //                 mgr.dateInterval
                                          //                         ?.endDate !=
                                          //                     null
                                          //             ? Text(
                                          //                 '${getIt<StateManager>().getMonthDay(mgr.dateInterval!.startDate!)} - ${getIt<StateManager>().getMonthDay(mgr.dateInterval!.endDate!)}',
                                          //                 style:
                                          //                     TextStyles.dateTxt,
                                          //               )
                                          //             : const CircularProgressIndicator(
                                          //                 color: Colors.white,
                                          //               ),
                                          //       ),
                                          //     )),
                                          horizontalSpace(10),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              spreadRadius: 0.5,
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      subtitle(
                                                        "Total Consultations",
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            patientCount != null
                                                                ? patientCount
                                                                      .toString()
                                                                : "0",
                                                            style: TextStyles
                                                                .graphtxt,
                                                          ),
                                                          horizontalSpace(w1p),
                                                          progressStatus != null
                                                              ? Column(
                                                                  children: [
                                                                    Text(
                                                                      "$percChange%",
                                                                      style: TextStyles
                                                                          .graphtxt2,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                      child: Image.asset(
                                                                        progressStatus ==
                                                                                true
                                                                            ? "assets/images/sign-incr.png"
                                                                            : "assets/images/sign-decr.png",
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      PickerDateRange?
                                                      result = await showDialog(
                                                        context: context,
                                                        builder:
                                                            (
                                                              BuildContext
                                                              context,
                                                            ) {
                                                              return const CalenderWidget();
                                                            },
                                                      );

                                                      if (result != null) {
                                                        getIt<
                                                              SettlementsManager
                                                            >()
                                                            .doctorWeeklySettles(
                                                              startDate: result
                                                                  .startDate,
                                                              endDate: result
                                                                  .endDate,
                                                            );
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        // gradient:
                                                        //     LinearGradient(
                                                        //   colors:
                                                        //       gradientColors,
                                                        //   begin: Alignment
                                                        //       .bottomCenter,
                                                        //   end: Alignment
                                                        //       .topCenter,
                                                        // ),
                                                        color: clr5D5AAB,
                                                        borderRadius:
                                                            const BorderRadius.all(
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: h1p,
                                                            ),
                                                        child:
                                                            mgr.dateInterval?.startDate !=
                                                                    null &&
                                                                mgr
                                                                        .dateInterval
                                                                        ?.endDate !=
                                                                    null
                                                            ? Text(
                                                                '${getIt<StateManager>().getMonthDay(mgr.dateInterval!.startDate!)} - ${getIt<StateManager>().getMonthDay(mgr.dateInterval!.endDate!)}',
                                                                style: TextStyles
                                                                    .dateTxt,
                                                              )
                                                            : const CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w1p * 0,
                                                ),
                                                //Initialize the spark charts widget
                                                child: SizedBox(
                                                  height: h10p * 2,
                                                  child: SfCartesianChart(
                                                    //   onMarkerRender: (sdsd){
                                                    //   print("1");
                                                    // },onLegendTapped: (sdsd){
                                                    //   print("2");
                                                    // },onAxisLabelTapped: (sdsd){
                                                    //   print("3");
                                                    // },onDataLabelTapped: (sdsd){
                                                    //   print("4");
                                                    // },
                                                    plotAreaBorderColor:
                                                        Colors.transparent,
                                                    primaryXAxis: CategoryAxis(
                                                      axisLine: const AxisLine(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      labelStyle: TextStyles
                                                          .graphLabelStyle,
                                                      majorGridLines:
                                                          const MajorGridLines(
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                    ),
                                                    primaryYAxis: NumericAxis(
                                                      labelStyle: TextStyles
                                                          .graphLabelStyle,
                                                      isVisible: true,
                                                      axisLine: const AxisLine(
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                      desiredIntervals:
                                                          graphList
                                                              .map((e) {
                                                                if (e.count >
                                                                    5) {
                                                                  return true;
                                                                }
                                                              })
                                                              .toList()
                                                              .contains(true)
                                                          ? 4
                                                          : 1,
                                                      decimalPlaces: 0,
                                                    ),
                                                    series: [
                                                      StackedColumnSeries(
                                                        spacing: 0.1,
                                                        color: clr5D5AAB,
                                                        borderRadius:
                                                            const BorderRadius.vertical(
                                                              top:
                                                                  Radius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                        onPointTap: (ChartPointDetails dfdf) {
                                                          if (kDebugMode) {
                                                            print('sdsdsd');
                                                          }
                                                          getIt<
                                                                SettlementsManager
                                                              >()
                                                              .selectGraphItem(
                                                                date:
                                                                    graphList[dfdf
                                                                            .pointIndex!]
                                                                        .day,
                                                                count:
                                                                    graphList[dfdf
                                                                            .pointIndex!]
                                                                        .count
                                                                        .toString(),
                                                              );
                                                        },
                                                        dataSource: graphList,
                                                        xValueMapper: (d, int index) =>
                                                            getIt<
                                                                  StateManager
                                                                >()
                                                                .getMonthDayFromString(
                                                                  graphList[index]
                                                                      .day,
                                                                ),
                                                        yValueMapper:
                                                            (d, int index) =>
                                                                graphList[index]
                                                                    .count,
                                                      ),
                                                    ],
                                                    //Enable the trackball

                                                    //Enable marker
                                                    // marker: SparkChartMarker(
                                                    //     displayMode: SparkChartMarkerDisplayMode.all,),
                                                    //Enable data label
                                                  ),
                                                ),
                                              ),
                                              mgr.selectedGraphDay.isNotEmpty
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        color:
                                                            Colours.couponBgClr,
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await getIt<
                                                                OnlineConsultManager
                                                              >()
                                                              .setDateInteval(
                                                                startDay: getIt<StateManager>()
                                                                    .stringToDateTime(
                                                                      mgr
                                                                          .selectedGraphDay
                                                                          .first,
                                                                    ),
                                                                endDay: getIt<StateManager>()
                                                                    .stringToDateTime(
                                                                      mgr
                                                                          .selectedGraphDay
                                                                          .first,
                                                                    ),
                                                              );

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const ConsultaionsScreen(),
                                                            ),
                                                          );
                                                        },
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            const Divider(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            getColum(
                                                              "Date",
                                                              mgr
                                                                  .selectedGraphDay
                                                                  .first,
                                                            ),
                                                            getColum(
                                                              "Bookings",
                                                              mgr
                                                                  .selectedGraphDay
                                                                  .last,
                                                            ),
                                                          ],
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
                                ),

                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 0,
                                    vertical: 8,
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      progress!.show();
                                      if (mgr.dateInterval?.startDate != null &&
                                          mgr.dateInterval?.endDate != null) {
                                        RevenueModel? result =
                                            await getIt<SettlementsManager>()
                                                .getRevenueWithdrawal(
                                                  startDate: mgr
                                                      .dateInterval!
                                                      .startDate!,
                                                  endDate: mgr
                                                      .dateInterval!
                                                      .endDate!,
                                                );
                                        if (result.status == true) {
                                          String? popMsg = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RevenueScreen(result),
                                            ),
                                          );

                                          if (popMsg != null) {
                                            Fluttertoast.showToast(msg: popMsg);
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CloseAlert(
                                                msg: result.message ?? "",
                                                isMsgOnly: true,
                                              );
                                            },
                                          );
                                        }
                                      }
                                      progress.dismiss();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(w1p * 5),
                                      // margin: EdgeInsets.all(w1p * 5),
                                      decoration: BoxDecoration(
                                        // color: Colors.red,
                                        borderRadius: BorderRadius.circular(16),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                            "assets/images/analytics_card_bg.jpg",
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Background SVG
                                          // Positioned.fill(
                                          //   child: Image.asset(
                                          //     "assets/images/analytics_card_bg.jpg",
                                          //     fit: BoxFit.cover,
                                          //   ),
                                          // ),
                                          // Foreground content
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: w1p * 4,
                                              vertical: h1p * 3,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Total revenue in the selected dates",
                                                  style: t400_18,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    text: 'from',
                                                    style: t400_18,
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text: ' $label ',
                                                        style: t400_18.copyWith(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'App',
                                                        style: t400_18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: h1p * 2),
                                                Text(
                                                  "₹${analytModel?.patientDetails?.totalWeeklyRevenue ?? 0}",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 48,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(height: h1p * 1.5),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Withdraw",
                                                      style: t400_18,
                                                    ),
                                                    const Icon(
                                                      Icons.chevron_right,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 0.5,
                                        blurRadius: 2,
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: w1p * 4,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 2,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      analytModel?.countryCounts != null
                                          ? subtitle("Countries")
                                          : const SizedBox(),
                                      SizedBox(
                                        height:
                                            (analytModel
                                                    ?.countryCounts
                                                    ?.length ??
                                                0) *
                                            50,
                                        // tryCounts?.length??1,
                                        child: SfCartesianChart(
                                          isTransposed: true,
                                          plotAreaBorderColor:
                                              Colors.transparent,
                                          primaryXAxis: CategoryAxis(
                                            axisLine: const AxisLine(
                                              color: Colors.transparent,
                                            ),
                                            labelStyle: TextStyles.analyticsTxt,
                                            majorGridLines:
                                                const MajorGridLines(
                                                  color: Colors.transparent,
                                                ),
                                          ),
                                          primaryYAxis: NumericAxis(
                                            labelStyle:
                                                TextStyles.graphLabelStyle,
                                            isVisible: false,
                                            axisLine: const AxisLine(
                                              color: Colors.transparent,
                                            ),
                                            desiredIntervals: 4,
                                            decimalPlaces: 0,
                                          ),
                                          series: [
                                            StackedColumnSeries(
                                              spacing: 0.5,
                                              borderRadius:
                                                  const BorderRadius.horizontal(
                                                    right: Radius.circular(8),
                                                  ),
                                              // color: Csolours.primaryblue,
                                              gradient: LinearGradient(
                                                colors: gradientColors,
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                              ),
                                              dataSource:
                                                  analytModel?.countryCounts ??
                                                  [],
                                              xValueMapper: (d, int index) =>
                                                  analytModel
                                                      ?.countryCounts?[index]
                                                      .name ??
                                                  "",
                                              yValueMapper: (d, int index) =>
                                                  analytModel
                                                      ?.countryCounts?[index]
                                                      .value ??
                                                  0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                pad(
                                  horizontal: w1p * 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              spreadRadius: 0.5,
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              subtitle("Age Group"),
                                              getRow(
                                                title: "Below 15",
                                                val:
                                                    "${mgr.analyticsModel?.ageRanges?.below15 ?? 0}",
                                              ),
                                              getRow(
                                                title: "Between 15 to 30",
                                                val:
                                                    "${mgr.analyticsModel?.ageRanges?.i15To30 ?? 0}",
                                              ),
                                              getRow(
                                                title: "Above 30",
                                                val:
                                                    "${mgr.analyticsModel?.ageRanges?.above30 ?? 0}",
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Container(width: 34,height: 34,color: Colors.redAccent,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class GraphData {
  GraphData(this.day, this.count);
  final String day;
  final int count;
}

class CalenderWidget extends StatefulWidget {
  const CalenderWidget({super.key});

  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  PickerDateRange? pickedDateRange;

  // List<Param> doses;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Select Dates", style: TextStyles.addDrugTxt),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SfDateRangePicker(
              backgroundColor: Colours.lightBlu,
              // controller: _controller,
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              toggleDaySelection: true,
              maxDate: DateTime.now().subtract(const Duration(days: 1)),
              onSelectionChanged: (fd) {
                pickedDateRange = fd.value;
              },
              monthViewSettings: const DateRangePickerMonthViewSettings(
                enableSwipeSelection: false,
              ),
            ),
          ],
        ),
      ),
      titlePadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      actionsPadding: const EdgeInsets.only(bottom: 18, right: 10),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(11)),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            if (pickedDateRange?.startDate != null) {
              if (pickedDateRange?.endDate != null) {
                // int startWeek = pickedDateRange!.startDate!.weekday;
                // int endWeek = pickedDateRange!.endDate!.weekday;
                //
                // // Check if the day is Monday
                // bool isStaringMonday = startWeek == DateTime.monday;
                // bool isEndingSunday = endWeek == DateTime.sunday;
                //
                // int differenceInDays = pickedDateRange!.endDate!.difference(pickedDateRange!.startDate!).inDays;
                //
                // if(isStaringMonday&&isEndingSunday&&differenceInDays==6){
                Navigator.pop(context, pickedDateRange);

                // }else{
                //   Fluttertoast.showToast(msg: "Choose 1 week with range(MON-FRI)");
                //
                // }
              } else {
                Fluttertoast.showToast(msg: "Choose date");
              }
            } else {
              Fluttertoast.showToast(msg: "Invalid Input");
            }
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
