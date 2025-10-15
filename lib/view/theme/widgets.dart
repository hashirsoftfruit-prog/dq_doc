import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../controller/managers/online_consult_manager.dart';
import '../../controller/managers/state_manager.dart';
import '../../model/core/recent_patients_response_model.dart';
import '../../model/helper/service_locator.dart';
import '../ui/chat_screen.dart';
import 'constants.dart';

class SmallWidgets {
  Widget cachedImg(
    String img, {
    String? placeholderImage,
    BoxFit? fit,
    bool? noPlaceHolder,
  }) {
    return CachedNetworkImage(
      fit: fit ?? BoxFit.cover,
      // fit: widget.fit,
      imageUrl: StringConstants.baseUrl + img,
      placeholder: (context, url) => noPlaceHolder == true
          ? const SizedBox()
          : Opacity(
              opacity: 0.5,
              child: Image.asset(
                placeholderImage ?? "assets/images/no-image-placeholder.png",
              ),
            ),
      errorWidget: (context, url, error) => noPlaceHolder == true
          ? const SizedBox()
          : Image.asset(
              placeholderImage ?? "assets/images/no-image-placeholder.png",
              fit: BoxFit.cover,
            ),
    );
  }

  AppBar appBarWidget({
    required String title,
    required double height,
    required double width,
    required Function fn,
    Widget? child,
    bool? hideBackBtn,
  }) {
    return AppBar(
      // toolbarHeight: height-height*0.1,
      automaticallyImplyLeading: false,
      backgroundColor: Colours.primaryblue,
      elevation: 0,
      leadingWidth: hideBackBtn == true ? width * 0.4 : 40,
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () {
          fn();
        },
        child: (hideBackBtn == true)
            ? const SizedBox()
            : SizedBox(
                height: 20,
                width: 30,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
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
      title: Text(
        title,
        // style: TextStyles.prescript3,
        style: TextStyles.consult3,
      ),
      actions: [child ?? const SizedBox()],
      // flexibleSpace: Container(
      //
      //   // height: height-height*0.1,
      //   color: Colours.primaryblue,
      //   child: pad(horizontal: width * 0.4,vertical: 1,
      //     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //
      //             SizedBox(
      //               width: width * 0.1,
      //             ),
      //
      //           ],
      //         ),
      //
      //       ],
      //     ),
      //   ),
      // )
    );
  }
}

class OnlineRequestBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final Function consultFn;
  final Function declineFn;
  const OnlineRequestBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.patientGender,
    required this.patientAge,
    required this.patientName,
    required this.consultFn,
    required this.declineFn,
  });

  @override
  Widget build(BuildContext context) {
    bool loader = Provider.of<OnlineConsultManager>(context).consultLoader;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w1p * 4),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xff5054E5).withOpacity(0.5),
              blurRadius: 5.0,
              offset: const Offset(0.0, 0.75),
            ),
          ],
        ),
        child: Stack(
          children: [
            pad(
              vertical: h1p * 2,
              horizontal: w1p * 2,
              child: Column(
                children: [
                  Row(
                    children: [
                      AvatarGlow(
                        animate: true,
                        glowColor: Colours.grad1,
                        glowRadiusFactor: 0.5,
                        child: Container(
                          height: h1p * 8,
                          width: h1p * 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colours.primaryblue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              patientGender.toUpperCase() == "MALE"
                                  ? "assets/images/person-man.png"
                                  : "assets/images/person-women.png",
                            ),
                          ),
                        ),
                      ),
                      pad(
                        horizontal: w1p * 2,
                        child: SizedBox(
                          height: h1p * 10,
                          child: const VerticalDivider(
                            color: Colors.grey,
                            width: 1,
                            thickness: 1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Patient Name",
                                    style: TextStyles.textStyle2,
                                  ),
                                  Text(
                                    patientName,
                                    style: TextStyles.textStyle3,
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Age", style: TextStyles.textStyle2),
                                  Text(
                                    patientAge,
                                    style: TextStyles.textStyle3,
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Gender", style: TextStyles.textStyle2),
                                  Text(
                                    patientGender,
                                    style: TextStyles.textStyle3,
                                  ),
                                ],
                              ),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    declineFn();
                                  },
                                  child: Container(
                                    decoration: bxDec(
                                      radius: 5,
                                      color: Colours.callRed,
                                    ),
                                    child: pad(
                                      vertical: h1p * 0.5,
                                      child: Center(
                                        child: Text(
                                          "Ignore",
                                          style: TextStyles.textStyle4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                loader
                                    ? Container(
                                        decoration: bxDec(
                                          radius: 5,
                                          color: Colors.white24,
                                        ),
                                        child: pad(
                                          vertical: h1p * 0.5,
                                          child: Center(
                                            child: Text(
                                              "Ignore",
                                              style: TextStyles.textStyle4,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          horizontalSpace(w1p),
                          Expanded(
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    consultFn();
                                  },
                                  child: Container(
                                    decoration: bxDec(
                                      radius: 5,
                                      color: Colours.callGreen,
                                    ),
                                    child: pad(
                                      vertical: h1p * 0.5,
                                      child: Center(
                                        child: Text(
                                          "Consult",
                                          style: TextStyles.textStyle4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                loader
                                    ? Container(
                                        decoration: bxDec(
                                          radius: 5,
                                          color: Colors.white24,
                                        ),
                                        child: pad(
                                          vertical: h1p * 0.5,
                                          child: Center(
                                            child: Text(
                                              "Consult",
                                              style: TextStyles.textStyle4,
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          horizontalSpace(w1p),
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
    );
  }
}

class AppoinmentsHomeScreenItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String patientName;
  final String subtitle;
  final String patientGender;
  final String patientAge;
  final String dTime;
  final DateTime? bookingStartTime;
  final DateTime? bookingEndTime;
  final String? appointmentId;
  final String? bookingStatus;
  final String? bookingType;
  final int? bookingId;
  final int? loadingBookingId;

  const AppoinmentsHomeScreenItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.patientGender,
    required this.loadingBookingId,
    required this.subtitle,
    required this.patientName,
    required this.patientAge,
    required this.dTime,
    required this.bookingStartTime,
    required this.bookingEndTime,
    required this.appointmentId,
    required this.bookingId,
    required this.bookingStatus,
    required this.bookingType,
  });

  @override
  Widget build(BuildContext context) {
    Widget divider = pad(
      horizontal: 8,
      child: Container(width: 0.8, height: 25, color: const Color(0xffB9B9B9)),
    );
    return Padding(
      padding: EdgeInsets.only(left: w1p * 4, right: w1p * 4, top: h1p),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xff5054E5).withOpacity(0.3),
              blurRadius: 3.0,
              offset: const Offset(0.0, 0.75),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: w1p * 4,
            right: w1p * 4,
            top: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getIt<StateManager>().capitalizeFirstLetter(
                            patientName,
                          ),
                          style: t700_16.copyWith(color: clr444444),
                        ),
                        Text(
                          subtitle,
                          style: t400_12.copyWith(color: clr444444),
                        ),
                        Text(
                          bookingType ?? "",
                          style: t400_12.copyWith(
                            color: const Color(0xff2E3192),
                          ),
                        ),
                      ],
                    ),
                  ),
                  divider,
                  SizedBox(
                    width: 74,
                    child: Center(
                      child: Text(
                        '$patientGender ($patientAge)',
                        style: TextStyles.textStyle10,
                      ),
                    ),
                  ),
                  divider,

                  Text(
                    getIt<StateManager>().getFormattedTime(dTime),
                    style: TextStyles.textStyle11,
                  ),

                  // SizedBox(height:h1p*3,child: SvgPicture.asset("assets/images/forward-arrow.svg"))
                ],
              ),
              bookingStartTime != null &&
                      bookingEndTime != null &&
                      DateTime.now().isAfter(bookingStartTime!) &&
                      bookingType != "Offline" &&
                      DateTime.now().isBefore(bookingEndTime!)
                  // &&DateTime.now().isBefore(bookingEndTime!)
                  ? InkWell(
                      onTap: () {
                        getIt<OnlineConsultManager>().disposePriscrip();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(
                              appId: appointmentId!,
                              isDirectToCall: false,
                              bookingId: bookingId!,
                            ),
                          ),
                        );

                        // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: appointmentId!,bookingId: bookingId!,isCallAvailable: true,)));
                        getIt<OnlineConsultManager>().sendConsultedStatus(
                          bookingId!,
                        );
                      },
                      child: const BtnInAppointmentItem("Consult Now"),
                    )
                  : bookingStartTime != null &&
                        bookingEndTime != null &&
                        DateTime.now().isAfter(bookingStartTime!) &&
                        bookingType == "Offline" &&
                        loadingBookingId != bookingId &&
                        bookingStatus != "Completed"
                  ? InkWell(
                      onTap: () async {
                        getIt<OnlineConsultManager>().disposePriscrip();

                        // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: appointmentId!,isDirectToCall: false, bookingId:bookingId!)));

                        // Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatPage(appId: appointmentId!,bookingId: bookingId!,isCallAvailable: true,)));

                        getIt<OnlineConsultManager>().loadingSpecificBooking(
                          bookingId,
                        );
                        var res = await getIt<OnlineConsultManager>()
                            .confirmCallCompletion(bookingId);

                        if (res.status == true) {
                          getIt<OnlineConsultManager>()
                              .markAppointmentsStartedLocally(bookingId);
                        }
                        getIt<OnlineConsultManager>().loadingSpecificBooking(
                          null,
                        );

                        // getIt<OnlineConsultManager>().sendConsultedStatus( bookingId!);
                      },
                      child: const BtnInAppointmentItem(
                        "Mark consultation started",
                      ),
                    )
                  : const SizedBox(),
              loadingBookingId == bookingId
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 1),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class BtnInAppointmentItem extends StatelessWidget {
  final String txt;
  const BtnInAppointmentItem(this.txt, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff00C165)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
          child: Text(txt, style: TextStyles.textStyle11),
        ),
      ),
    );
  }
}

class RecentPatientBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final RecentPatients data;
  final Function btnClick;

  const RecentPatientBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.data,
    required this.btnClick,
  });

  @override
  Widget build(BuildContext context) {
    // Widget divider = pad(
    //   horizontal: w1p * 2,
    //   child: Container(
    //     width: 0.8,
    //     height: 50,
    //     color: const Color(0xffB9B9B9),
    //   ),
    // );

    return Padding(
      padding: EdgeInsets.only(bottom: h1p),
      child: Container(
        // padding: EdgeInsets.symmetric(vertical:h1p*1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xff5054E5).withOpacity(0.4),
              blurRadius: 3.0,
              offset: const Offset(0.0, 0.75),
            ),
          ],
        ),
        child: pad(
          horizontal: w1p * 4,
          vertical: h1p * 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: clr8467A6,
                child: Image.asset(
                  data.gender!.toUpperCase() == "MALE"
                      ? "assets/images/person-man.png"
                      : "assets/images/person-women.png",
                  height: 35,
                ),
              ),
              horizontalSpace(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      getIt<StateManager>().capitalizeFirstLetter(
                        data.firstName ?? "",
                      ),
                      style: TextStyles.prescript5,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Text(
                          data.gender ?? "",
                          style: TextStyles.textStyle10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        horizontalSpace(2),
                        Text(
                          '(${data.age})',
                          style: t400_14.copyWith(color: clr757575),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              horizontalSpace(8),
              InkWell(
                onTap: () {
                  btnClick();
                },
                child: Container(
                  height: 40,
                  width: w1p * 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: data.endDateTime != null &&
                    //         DateTime.now()
                    //             .isBefore(DateTime.parse(data.endDateTime!))
                    //     ? Colors.green
                    //     : Colours.primaryblue,
                    gradient: LinearGradient(
                      colors:
                          (data.endDateTime != null &&
                              DateTime.now().isBefore(
                                DateTime.parse(data.endDateTime!),
                              ))
                          ? [clr5D5AAB, clr8467A6]
                          : gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    data.endDateTime != null &&
                            DateTime.now().isBefore(
                              DateTime.parse(data.endDateTime!),
                            )
                        ? "Consult"
                        : "Chat",
                    style: TextStyles.textStyle7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class ConsultationItem extends StatelessWidget {
//   double w1p;
//   double h1p;
//   Consultations data;
//   Function btnClick;
//
//   ConsultationItem(
//       {
//         required this.h1p,
//         required this.w1p,
//         required this.data,
//         required this.btnClick,
//
//
//       }
//
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     Widget divider = pad(
//       horizontal: w1p*2,
//       child: Container(width: 0.8,height: h1p*4,color: Color(0xffB9B9B9),),
//     );
//     return  Padding(
//       padding: EdgeInsets.only(bottom: h1p),
//       child: Container(
//         // padding: EdgeInsets.symmetric(vertical:h1p*1.5),
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,boxShadow: <BoxShadow>[
//           BoxShadow(
//               color: Color(0xff5054E5).withOpacity(0.1),
//               blurRadius: 3.0,
//               offset: Offset(0.0, 0.75)
//           )
//         ],),
//         child: pad(horizontal: w1p*4,vertical:h1p*2,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(flex:2,child: SizedBox(child: Text(getIt<StateManager>().capitalizeFirstLetter(data.firstName ?? ""),style: TextStyles.prescript5,))),
//               Text('${data.age}',style: TextStyles.prescript5,),
//               Expanded(flex:1,child: SizedBox(child: Center(child: Text(data.gender ?? "",style: TextStyles.prescript5,)))),
//               InkWell(
//
//                 onTap: (){
//                   btnClick();
//
//
//                 },
//                 child: Container(height: h1p*4,
//                     width: w1p*25,
//                     decoration:BoxDecoration(
//
//                         borderRadius: BorderRadius.circular(8),color:data.endDateTime!=null&&DateTime.now().isBefore(DateTime.parse(data.endDateTime!))?Colors.green: Colours.primaryblue),
//
//                     child: Center(child: Text(data.endDateTime!=null&&DateTime.now().isBefore(DateTime.parse(data.endDateTime!))?"Consult":"Record",style: TextStyles.textStyle7,))),
//               )
//
//             ],),
//         ),
//       ),
//     );
//   }
// }

class MyTextFormField extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String hnt;
  final TextEditingController cntrolr;
  final bool? isNumber;
  final bool? readOnly;
  final String type;
  final Function(String)? onsubmit;
  const MyTextFormField({
    super.key,
    // required this.h1p,
    // required this.w1p,
    required this.hnt,
    required this.cntrolr,
    this.isNumber,
    required this.type,
    this.onsubmit,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: cntrolr,
      keyboardType: isNumber == true ? TextInputType.number : null,
      decoration: inputDec4(isEmpty: cntrolr.text.isEmpty, hnt: hnt),
      style: TextStyles.txtBox1,
      validator: (v) => v!.trim().isEmpty
          ? null
          : getIt<StateManager>().validateFieldValues(v, type),
      onFieldSubmitted: onsubmit,
    );
  }
}

class MyTextFormField2 extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String hnt;
  final int? maxLine;
  final int? minLine;
  final TextEditingController? cntrolr;
  final bool? isNumber;
  final bool? readOnly;
  final String type;
  final String? initialvalue;
  final Function(String)? onsubmit;
  final Function? onTap;
  const MyTextFormField2({
    super.key,
    // required this.h1p,
    // required this.w1p,
    required this.hnt,
    this.cntrolr,
    this.isNumber,
    required this.type,
    this.maxLine,
    this.minLine,
    this.onsubmit,
    this.readOnly,
    this.onTap,
    this.initialvalue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialvalue,
      controller: cntrolr,
      keyboardType: isNumber == true ? TextInputType.number : null,
      readOnly: readOnly == true ? true : false,
      decoration: inputDec5(hnt: hnt),
      style: TextStyles.txtBox1,
      maxLines: maxLine ?? 1,
      minLines: minLine ?? 1,
      validator: (v) => v!.trim().isEmpty
          ? null
          : getIt<StateManager>().validateFieldValues(v, type),
      onFieldSubmitted: onsubmit,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
    );
  }
}

// class  ListAlertBox extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     Row listItemWithCheck({required String title,required bool selected}){
//       return Row(
//       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Checkbox(value: selected, onChanged: (val){
//             // getIt<OnlineConsultManager>().setUpDiagnosisList(title);
//           }),
//           Text(title)
//         ]);}
//     List<String> items = ["Fever","Headache","Facial Pain","Abdominal Pain","Back Pain","Breast Pain","Chest Pain","Ear Pain","EyePain"];
//
//     return AlertDialog(
//       title: Text("Diagnosis List",style: TextStyles.prescript4,),
//       content: SingleChildScrollView(
//         child: Column(
//           children: List.generate(
//             items.length,
//                 (index) {
//               return listItemWithCheck(title: items[index],selected: [].contains(items[index]));
//             },
//           ),
//         ),
//       ),actionsPadding: EdgeInsets.only(bottom: 18,right: 10),
//       contentPadding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),shape:RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(11))),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),TextButton(
//           onPressed: () {
//             // getIt<OnlineConsultManager>().addDiagnosis(selectedItems.join(", "));
//             // getIt<OnlineConsultManager>().clearSelectedDiagns();
//             Navigator.of(context).pop();
//
//
//           },
//           child: Text('Add'),
//         ),
//       ],
//     );
//
//   }
// }

// class  DrugTypesList extends StatelessWidget {
//   List<Param> drugTypes;
//   Param? selectedDrugType;
//
//
//   DrugTypesList({required this.drugTypes,  this.selectedDrugType});
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     Row listItemWithCheck({required Param  item, required bool selected}) {
//       return Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Checkbox(value: selected, onChanged: (val) {
//               getIt<OnlineConsultManager>().setUpDrugType(item);
//               Navigator.pop(context);
//
//
//             }),
//             Text(item.title??"")
//           ]);
//     }
//
//
//
//     return AlertDialog(
//       title: Text("Select Drug type", style: TextStyles.prescript4,),
//       content: SingleChildScrollView(
//         child: Column(
//           children: List.generate(
//             drugTypes.length,
//                 (index) {
//               return listItemWithCheck(item: drugTypes[index],
//                   selected:selectedDrugType!=null? selectedDrugType!.id == drugTypes[index].id:false);
//             },
//           ),
//         ),
//       ),
//       actionsPadding: EdgeInsets.only(bottom: 18, right: 10),
//       contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(11))),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//
//       ],
//     );
//   }
// }
// class  DrugUnitList extends StatelessWidget {
//   List<Param> drugUnits;
//   int? selectedUnitId;
//
//
//   DrugUnitList({required this.drugUnits,  this.selectedUnitId});
//
//
//   @override
//   Widget build(BuildContext context) {
//     Row listItemWithCheck({required Param item,required bool selected}) {
//       return Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Checkbox(value: selected, onChanged: (val) {
//               getIt<OnlineConsultManager>().setUpDrugUnit(item);
//               Navigator.pop(context);
//             }),
//             Text(item.title??"")
//           ]);
//     }
//
//
//
//     return AlertDialog(
//       title: Text("Select Drug type", style: TextStyles.prescript4,),
//       content: SingleChildScrollView(
//         child: Column(
//           children: List.generate(
//             drugUnits.length,
//                 (index) {
//               return listItemWithCheck(item: drugUnits[index] ,
//                   selected: selectedUnitId == drugUnits[index].id);
//             },
//           ),
//         ),
//       ),
//       actionsPadding: EdgeInsets.only(bottom: 18, right: 10),
//       contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(11))),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//
//       ],
//     );
//   }
// }

Widget cachedImg(String img) {
  return CachedNetworkImage(
    fit: BoxFit.cover,
    // fit: widget.fit,
    imageUrl:
        // StringConstants.imgBaseUrl+
        img,
    placeholder: (context, url) => Opacity(
      opacity: 0.5,
      child: SvgPicture.asset("assets/images/appicon.svg"),
    ),
    errorWidget: (context, url, error) =>
        Image.asset("assets/images/speciality-placeholder.png"),
  );
}

class DosesList extends StatelessWidget {
  // List<Param> doses;
  final String dTime;
  // int? selectedUnitId;

  const DosesList({super.key, required this.dTime});

  @override
  Widget build(BuildContext context) {
    TextEditingController tCntrl = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text("Type Dosage", style: TextStyles.prescript4),
      content: TextFormField(
        autofocus: true,
        controller: tCntrl,
        decoration: inputDec6(hnt: "Add value"),
        keyboardType: TextInputType.number,
      ),
      actionsPadding: const EdgeInsets.only(bottom: 18, right: 10),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
            if (double.tryParse(tCntrl.text) != null) {
              Navigator.pop(context, tCntrl.text);
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

class LogoLoader extends StatefulWidget {
  final double? size;
  final Color? color;

  const LogoLoader({super.key, this.size = 100, this.color});

  @override
  State<LogoLoader> createState() => _LogoLoaderState();
}

class _LogoLoaderState extends State<LogoLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                "assets/images/appicon.svg",
                // colorFilter: ColorFilter.mode(widget.color!, BlendMode.srcIn),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppLoader extends StatelessWidget {
  final double? size;
  final Color? color;
  const AppLoader({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.twoRotatingArc(
        color: color ?? clr5A6BE2,
        size: size ?? 40,
      ),
    );
  }
}

class RadioBtnItem extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String txt;
  final bool selected;
  const RadioBtnItem({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.txt,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: w1p * 1),
      child: Row(
        children: [
          SizedBox(
            // width: w1p*15,
            height: w1p * 4,
            child: SvgPicture.asset(
              fit: BoxFit.contain,
              selected
                  ? "assets/images/circle-selected.svg"
                  : "assets/images/circle-unselected.svg",
            ),
          ),
          horizontalSpace(8),
          Text(txt, style: TextStyles.addDrugTxt3),
        ],
      ),
    );
  }
}

class BillBox extends StatelessWidget {
  final double w1p;
  final double h1p;
  final String? subTotal;
  final String? totalAmt;
  final String? serviceFee;
  final bool? isLoading;

  const BillBox({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.subTotal,
    required this.serviceFee,
    required this.totalAmt,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      // color: Colours.boxblue,
      // strokeWidth: 1,
      options: RectDottedBorderOptions(color: Colours.boxblue, strokeWidth: 1),

      child: Padding(
        padding: EdgeInsets.all(w1p * 3),
        child: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.twoRotatingArc(
                  color: Colours.primaryblue,
                  size: 30,
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: TextStyles.billTxt5),
                      Text('₹$totalAmt', style: TextStyles.billTxt6),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class CloseAlert extends StatelessWidget {
  // double w1p;
  // double h1p;
  final String? msg; // String type;
  final bool? isMsgOnly;
  // String currentClinicAddress;
  // Function bookOnlineOnClick;
  // Function bookClinicOnClick;
  const CloseAlert({
    super.key,
    required this.msg,
    this.isMsgOnly,
    // required this.w1p,
    // required this.h1p,
    // required this.experience,
    // required this.onlineTimeSlot,
    // required this.type,
    // required this.offlineTimeSlot,
    // required this.currentClinicAddress,
    // required this.bookOnlineOnClick,
    // required this.bookClinicOnClick,
  });

  @override
  Widget build(BuildContext context) {
    String msgss = msg ?? "";

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Message', style: TextStyles.textStyle3c),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Container(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msgss),

              // verticalSpace(h1p),
              // Text(msg),
            ],
          ),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.primaryblue),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 5),
              child: Text("Cancel", style: TextStyles.textStyle3f),
            ),
          ),
        ),
        isMsgOnly == true
            ? const SizedBox()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // gradient: linearGrad
                  color: Colours.callRed,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 28.0,
                      vertical: 5,
                    ),
                    child: Text("Proceed", style: TextStyles.textStyle3g),
                  ),
                ),
              ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
