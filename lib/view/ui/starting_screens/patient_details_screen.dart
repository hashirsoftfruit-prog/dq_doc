import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../images_open_widget.dart';
import '../../../model/core/patients_details_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../../pdf_view_screen.dart';
import '../../theme/constants.dart';

class BookingDetailsScreen extends StatefulWidget {
  final int? bookingID;
  final bool? hideHealthDetails;
  const BookingDetailsScreen(
    this.bookingID, {
    super.key,
    this.hideHealthDetails,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen>
    with SingleTickerProviderStateMixin {
  // DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // getIt<OnlineConsultManager>().getPatientRequestList();
    getIt<OnlineConsultManager>().getPatientDetails(
      bookingID: widget.bookingID!,
    );
    getIt<OnlineConsultManager>().getQuestionareAnswers(
      bookingID: widget.bookingID!,
    );
    // getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        getHead(title) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(title, style: TextStyles.pDetails1b),
          );
        }

        fieldItem(title, value, {bool? fullwidth}) {
          return SizedBox(
            width: fullwidth == null ? w10p * 4 : w10p * 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.pDetails2b),
                  Text(value, style: TextStyles.pDetails3b),
                ],
              ),
            ),
          );
        }

        qnAnswerWidget(Questionnaire qn) {
          String answer =
              qn.descriptiveAnswer != null && qn.descriptiveAnswer!.isNotEmpty
              ? qn.descriptiveAnswer!
              : qn.options != null && qn.options!.isNotEmpty
              ? qn.options!.map((e) => e.option).toList().join(', ')
              : 'N/A';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Qn.', style: TextStyles.pDetails2),
                    horizontalSpace(8),
                    Expanded(
                      child: SizedBox(
                        child: Text(
                          qn.questionnaire ?? "",
                          style: TextStyles.pDetails3,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('An.', style: TextStyles.pDetails2),
                    horizontalSpace(8),
                    Expanded(child: Text(answer, style: TextStyles.pDetails2)),
                  ],
                ),
                const Divider(indent: 1, color: Colours.lightBlu),
              ],
            ),
          );
        }

        EdgeInsets padValue = const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 18,
        );

        return Consumer<OnlineConsultManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              backgroundColor: Colors.white,
              // appBar: getIt<SmallWidgets>().appBarWidget(
              //     title: "Patient Info",
              //     height: h10p * 0.9,
              //     width: w10p,
              //     fn: () {
              //       Navigator.pop(context);
              //     }),
              // appBar: AppBar(
              //
              //   leading: Image.asser,
              //   title:Text("Patient Info",style: TextStyles.consult3,), backgroundColor:Colours.primaryblue,),
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
                      child: Column(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // const Spacer(),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12.0,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/back-arrow.svg",

                                        // color: Colors.white,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Row(
                                    children: [
                                      Text("Patient Info", style: t500_20),
                                    ],
                                  ),
                                ),
                                const Spacer(),

                                // verticalSpace(16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        // getIt<OnlineConsultManager>().getPatientRequestList();
                        // getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());

                        getIt<OnlineConsultManager>().getPatientDetails(
                          bookingID: widget.bookingID!,
                        );
                        getIt<OnlineConsultManager>().getQuestionareAnswers(
                          bookingID: widget.bookingID!,
                        );
                      },
                      child: Entry(
                        yOffset: -100,
                        // opacity: .5,
                        // angle: 3.1415,
                        delay: const Duration(milliseconds: 0),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.decelerate,
                        child: Builder(
                          builder: (context) {
                            String time =
                                '${getIt<StateManager>().stringToTime(mgr.bookingDetails?.time) ?? ""}';
                            String date =
                                '${getIt<StateManager>().getFormattedDate3(mgr.bookingDetails?.date) ?? ""}';
                            String bookingType =
                                '${mgr.bookingDetails?.bookingType ?? ""} ';
                            String clinicDetails = getIt<StateManager>()
                                .buildAddress([
                                  mgr.bookingDetails?.clinicName,
                                  mgr.bookingDetails?.clinicAddress1,
                                  mgr.bookingDetails?.clinicAddress2,
                                  mgr.bookingDetails?.clinicCity,
                                  mgr.bookingDetails?.clinicState,
                                  mgr.bookingDetails?.clinicCountry,
                                  mgr.bookingDetails?.clinicPincode,
                                ]);

                            // '${ ?? ""} ${mgr.bookingDetails?.clinicAddress1 ?? ""} ${mgr.bookingDetails?.clinicAddress2 ?? ""} ${mgr.bookingDetails?.clinicCity ?? ""} ${mgr.bookingDetails?.clinicState ?? ""}';

                            String name =
                                '${mgr.patientDetails?.firstName ?? ""} ${mgr.patientDetails?.lastName ?? ""}';
                            String gender =
                                '${mgr.patientDetails?.gender ?? ""} ';
                            String dateOfB =
                                '${mgr.patientDetails?.dateOfBirth ?? ""} ';
                            String referId =
                                '${mgr.patientDetails?.patientReferenceId ?? ""} ';
                            String appoinmentId =
                                '${mgr.bookingDetails?.appointmentId ?? ""} ';
                            // String email = '${mgr.patientDetails?.firstName ?? ""} ';

                            String height =
                                '${mgr.patientDetails?.height ?? "N/A"} ';
                            String weight =
                                '${mgr.patientDetails?.weight ?? "N/A"} ';
                            String bloodGrp =
                                '${mgr.patientDetails?.bloodGroup ?? "N/A"} ';
                            String bloodSugar =
                                '${mgr.patientDetails?.bloodSugar ?? "N/A"} ';
                            String bloodPrsr =
                                '${mgr.patientDetails?.bloodPressure ?? "N/A"} ';
                            String serumC =
                                '${mgr.patientDetails?.serumCreatinine ?? "N/A"} ';

                            return Column(
                              // shrinkWrap: true,
                              children: [
                                // mgr.consultations!=null && mgr.consultations!.isNotEmpty?
                                // pad(horizontal: w1p*4,vertical: h1p,
                                //     child: Text("Recent patients",style: TextStyles.textStyle6,)):SizedBox(),
                                verticalSpace(h1p),
                                mgr.bookingDetailsLoader == true
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: h10p,
                                        ),
                                        child: const Center(child: AppLoader()),
                                      )
                                    : mgr.patientDetails == null
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: h10p,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "No patient details found",
                                            style: TextStyles.textStyle2,
                                          ),
                                        ),
                                      )
                                    : pad(
                                        horizontal: w1p * 4,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            getHead("Booking Details"),
                                            Container(
                                              width: maxWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xffFBFBFB),
                                              ),
                                              child: Padding(
                                                padding: padValue,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        fieldItem(
                                                          "Appointment Id",
                                                          appoinmentId,
                                                        ),
                                                        fieldItem(
                                                          "Type of Appointment",
                                                          bookingType,
                                                        ),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      indent: 1,
                                                      color: Colours.lightBlu,
                                                    ),

                                                    Row(
                                                      children: [
                                                        fieldItem("Time", time),
                                                        fieldItem("Date", date),
                                                      ],
                                                    ),
                                                    clinicDetails.isNotEmpty
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Divider(
                                                                indent: 1,
                                                                color: Colours
                                                                    .lightBlu,
                                                              ),
                                                              fieldItem(
                                                                "Clinic Details",
                                                                clinicDetails,
                                                                fullwidth: true,
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox(),

                                                    // fieldItem("Phone", "0909040340"),
                                                    // fieldItem("Email", email),
                                                    // Divider(indent: 1,color: Colours.lightBlu,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            getHead("Personal Details"),
                                            Container(
                                              width: maxWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xffFBFBFB),
                                              ),
                                              child: Padding(
                                                padding: padValue,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    fieldItem(
                                                      "Reference Id",
                                                      referId,
                                                    ),
                                                    const Divider(
                                                      indent: 1,
                                                      color: Colours.lightBlu,
                                                    ),
                                                    fieldItem(
                                                      "Full Name",
                                                      name,
                                                    ),
                                                    const Divider(
                                                      indent: 1,
                                                      color: Colours.lightBlu,
                                                    ),

                                                    // fieldItem("Phone", "0909040340"),
                                                    // fieldItem("Email", email),
                                                    Row(
                                                      children: [
                                                        fieldItem(
                                                          "Gender",
                                                          gender,
                                                        ),
                                                        fieldItem(
                                                          "Date of Birth",
                                                          dateOfB,
                                                        ),
                                                      ],
                                                    ),
                                                    // Divider(indent: 1,color: Colours.lightBlu,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            verticalSpace(h1p),
                                            widget.hideHealthDetails != true
                                                ? getHead("Health info")
                                                : const SizedBox(),
                                            widget.hideHealthDetails != true
                                                ? Container(
                                                    width: maxWidth,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      color: const Color(
                                                        0xffFBFBFB,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: padValue,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              fieldItem(
                                                                "Height",
                                                                height,
                                                              ),
                                                              fieldItem(
                                                                "Weight",
                                                                weight,
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(
                                                            indent: 1,
                                                            color: Colours
                                                                .lightBlu,
                                                          ),

                                                          Row(
                                                            children: [
                                                              fieldItem(
                                                                "Blood Group",
                                                                bloodGrp,
                                                              ),
                                                              fieldItem(
                                                                "Blood Sugar",
                                                                bloodSugar,
                                                              ),
                                                            ],
                                                          ),

                                                          // fieldItem("Email", email),
                                                          const Divider(
                                                            indent: 1,
                                                            color: Colours
                                                                .lightBlu,
                                                          ),
                                                          Row(
                                                            children: [
                                                              fieldItem(
                                                                "Blood Pressure",
                                                                bloodPrsr,
                                                              ),
                                                              fieldItem(
                                                                "Serum Creatinin",
                                                                serumC,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),

                                widget.hideHealthDetails != true &&
                                        mgr.patientDetails?.documents != null &&
                                        mgr
                                            .patientDetails!
                                            .documents!
                                            .isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  MedicalRecordsListScreen(
                                                    maxH: maxHeight,
                                                    maxW: maxWidth,
                                                    medicalRecords: mgr
                                                        .patientDetails!
                                                        .documents!
                                                        .map((e) => e.file!)
                                                        .toList(),
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Medical Records",
                                                style: TextStyles.textStyle7d,
                                              ),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),

                                verticalSpace(h1p),

                                widget.hideHealthDetails != true &&
                                        mgr.questionnaire != null &&
                                        mgr.questionnaire!.isNotEmpty
                                    ? pad(
                                        horizontal: w1p * 4,
                                        child: Builder(
                                          builder: (context) {
                                            List<Widget> questionAnsers = [];

                                            for (var item
                                                in mgr.questionnaire!) {
                                              questionAnsers.add(
                                                qnAnswerWidget(item),
                                              );
                                            }
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                getHead(
                                                  "Questionnaire answers",
                                                ),
                                                pad(
                                                  horizontal: 8,
                                                  child: Text(
                                                    'The following results provide insights into the patient\'s condition.',
                                                    style: TextStyles.pDetails4,
                                                  ),
                                                ),
                                                verticalSpace(8),
                                                Column(
                                                  children: questionAnsers,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    : const SizedBox(),

                                // mgr.questionnaire!=null? Column(children:mgr.questionnaire!.map((e)=>
                                //
                                //     qnAnswerWidget(e)
                                // ).toList()
                                // ):SizedBox()
                                mgr.bookingDetails?.cancellationStatus == 1
                                    ? pad(
                                        vertical: 24,
                                        child: GestureDetector(
                                          onTap: () async {
                                            bool? res = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CloseAlert(
                                                  msg:
                                                      "Are you sure you want to cancel this booking?",
                                                );
                                              },
                                            );

                                            if (res != null && res == true) {
                                              var result =
                                                  await getIt<
                                                        OnlineConsultManager
                                                      >()
                                                      .cancelBooking(
                                                        bookingId:
                                                            widget.bookingID!,
                                                      );
                                              if (result.status == true) {
                                                getIt<OnlineConsultManager>()
                                                    .getPatientDetails(
                                                      bookingID:
                                                          widget.bookingID!,
                                                    );

                                                Fluttertoast.showToast(
                                                  msg: result.message ?? "",
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: result.message ?? "",
                                                );
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: w1p * 6,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(
                                                    0xffEB0000,
                                                  ),
                                                  width: 0.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xffFFF9F9),
                                                boxShadow: [boxShadow9],
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0,
                                                  vertical: 8,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Cancel Booking",
                                                    style:
                                                        TextStyles.textStyle11d,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            );
                          },
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

// class ConsultationItem extends StatelessWidget {
//
//   double w1p;
//   double h1p;
//   String date;
//   int? bookingID;
//   String name;
//   String appoinmentId;
//   String img;
//   bool isOnline;
//   String gender;
//   String age;
//   String sheduledTime;
//   String patientname;
//   // DateTime? startTime;
//   // DateTime? endTime;
//   ConsultationItem({
//     required this.w1p,
//     required this.h1p,
//     required this.sheduledTime,
//     required this.bookingID,
//     required this.appoinmentId,
//     required this.date,
//     required this.gender,
//     required this.age,
//     required this.isOnline,
//     required this.patientname,
//     // required this.isApplicable,
//     required this.name,
//     // required this.startTime,
//     // required this.endTime,
//     required this.img,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return   Padding(
//       padding: const EdgeInsets.only(bottom: 4.0),
//       child: Container(
//         decoration: BoxDecoration(      color: Color(0xffF9F9F9),
//
//           borderRadius: BorderRadius.circular(10),
//                  ),
//
//         child: Column(
//           children: [
//             pad(
//               horizontal: w1p*2,
//               vertical: h1p,
//               child: Row(children: [
//                 pad(
//                   horizontal: w1p*1,
//
//                   child: Container(
//                     height:80,
//                     width:80,
//                     decoration: BoxDecoration(gradient: linearGrad2,shape: BoxShape.circle),
//                     child: Center(
//                       child: Container(
//
//                         height:70,
//                         width:70,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Image.asset(gender.toUpperCase()=="MALE"?"assets/images/person-man.png":"assets/images/person-women.png"),
//                         ),
//                         decoration: BoxDecoration(color: Colours.primaryblue,
//                           // border: Border.,
//                             borderRadius: BorderRadius.circular(100)),),
//                     ),
//                   ),
//                 ),
//                 horizontalSpace(w1p),
//
//                 Expanded(
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.max,
//                         children: [
//
//                           Text(name??"",style: TextStyles.consult1,),
//                           Text('${gender}, ${age}',style: TextStyles.consult1,),
//                           Container(
//                               decoration: BoxDecoration(border: Border.all(color: Colors.black38,),borderRadius:
//                               BorderRadius.circular(6)),
//                               child: pad(horizontal: w1p*2,vertical: w1p*0.5,
//                                 child: Row(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//
//                                     Text("Medical Records",style: TextStyles.consult2,),
//
//
//                                   ],
//                                 ),
//                               )),
//
//                         ],),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.start,mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Row(mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(date??"",style: TextStyles.consult4,),horizontalSpace(w1p),
//                               Text(sheduledTime ?? "",style: TextStyles.consult4,),                      ],
//                           ),
//                          SizedBox(height: 50,child: VerticalDivider(),),
//                          Row(mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//
//                               Container(
//                              height: 30,
//                                   decoration: BoxDecoration(
//                                 color:Colors.green,
// shape: BoxShape.circle
//                               ),
//                                   child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: SvgPicture.asset(isOnline?"assets/images/icon-online.svg":"assets/images/icon-online.svg",),
//                               )),
//
//                             ],
//                           )
//                         ],),
//                     ],
//                   ),
//                 ),
//
//
//               ],
//               ),
//             ),
//
//
//
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }

class MedicalRecordsListScreen extends StatelessWidget {
  final double maxH;
  final double maxW;
  final List<String> medicalRecords;

  const MedicalRecordsListScreen({
    super.key,
    required this.maxH,
    required this.maxW,
    required this.medicalRecords,
  });

  @override
  Widget build(BuildContext context) {
    double maxHeight = maxH;
    double maxWidth = maxW;
    // double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    // double w1p = maxWidth * 0.01;

    imageContainer(String url) {
      return InkWell(
        onTap: () {
          // showModalBottomSheet(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero ),
          //     backgroundColor: Colors.black12,
          //     isScrollControlled: false,
          //     useSafeArea: true,
          //     // showDragHandle: true,
          //     context: context,
          //     builder: (context) =>
          //         PhotoViewContainer(w1p: w1p,h1p: h1p,url: url));

          showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            showDragHandle: true,
            barrierColor: Colors.white,
            useSafeArea: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            // showDragHandle: true,
            context: context,
            builder: (context) =>
                // PhotoViewContainer(w1p: w1p,h1p: h1p,url: url!)
                GalleryImageViewWrapper(
                  paginationFn: () {
                    // print("jfdfahdjsfhsadjfasf");
                    // getIt<CordManager>().incrementPageIndex();
                    // getIt<CordManager>().getGalleryImages();
                  },
                  titleGallery: 'Gallery',
                  galleryItems: [url].map((e) {
                    var indxx = [url].indexOf(e);

                    return GalleryItemModel(
                      id: getIt<StateManager>().generateRandomString(),
                      index: indxx,
                      imageUrl: e,
                    );
                  }).toList(),
                  backgroundColor: Colors.white,
                  initialIndex: 0,
                  loadingWidget: null,
                  errorWidget: null,
                  maxScale: 10,
                  minScale: 0.5,
                  reverse: false,
                  showListInGalley: false,
                  showAppBar: false,
                  closeWhenSwipeUp: false,
                  closeWhenSwipeDown: true,
                  radius: 0,
                  imageList: [url],
                ),
          );
        },
        child: SizedBox(child: Image.network(url, fit: BoxFit.cover)),
      );
    }

    pdfContainer(String url) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PdfViewerPage(url)),
          );
        },
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset(
              "assets/images/pdf-thumbnail.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getIt<SmallWidgets>().appBarWidget(
        title: "Medical Records",
        height: h10p,
        width: w10p,
        fn: () {
          Navigator.pop(context);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: medicalRecords.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of items in one row
              crossAxisSpacing: 8, // Spacing between items horizontally
              mainAxisSpacing: 8, // Spacing between items vertically
              childAspectRatio: 1, // Adjust this value to control item height
            ),
            itemBuilder: (context, index) {
              var file = medicalRecords[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colours.boxblue,
                    child: file.endsWith('.pdf')
                        ? pdfContainer('${StringConstants.baseUrl}$file')
                        : imageContainer('${StringConstants.baseUrl}$file'),
                  ),
                ],
              );
            },
          ),
        ),

        // ListView(
        //     children: medicalRecords.map((file) {
        //       var indx = medicalRecords.indexOf(file);
        //
        //       return  file!=null?Padding(
        //         padding:  EdgeInsets.only(bottom:medicalRecords.length-1==indx?h1p*10: 16.0),
        //         child: Container(margin: EdgeInsets.symmetric(horizontal: w1p*4),
        //           decoration: BoxDecoration(boxShadow:[ BoxShadow(
        //               color: Colors.grey.withOpacity(0.1),
        //               spreadRadius: 2,
        //               blurRadius: 2,
        //               offset: const Offset(1, 1))],),
        //
        //           child: Column(
        //             children: [
        //               file!.endsWith('.pdf')?pdfContainer(StringConstants.imgBaseUrl+file!):imageContainer('${StringConstants.imgBaseUrl}${file}'),
        //               verticalSpace(2),
        //               Container(width: maxWidth,
        //                 decoration: BoxDecoration(
        //                   // border: Border.all(color: Colours.lightBlu),
        //                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        //                   color: Colors.white,
        //
        //                 ),
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       // Text(e.typeOfRecord??"",style: TextStyles.textStyle4,),
        //                       // Text(e.createdDate??"",style: TextStyles.textStyle4,),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ):SizedBox();
        //     }
        //
        //
        //     ).toList()
        //
        //
        // ),
      ),
    );
  }
}
