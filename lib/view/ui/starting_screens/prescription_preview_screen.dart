import 'dart:io';
import 'dart:ui' as ui;

import 'package:dqueuedoc/view/theme/constants.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../controller/managers/chat_manager.dart';
import '../../../controller/managers/online_consult_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/prescription_preview_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/widgets.dart';

class PrescriptionPreviewScreen extends StatelessWidget {
  final double maxWidth;
  final double maxHeight;
  final String appoinmentId;
  final Function(String) fn;
  final PrescriptionPreviewModel ppModel;
  const PrescriptionPreviewScreen(
      {super.key,
      required this.ppModel,
      required this.appoinmentId,
      required this.maxHeight,
      required this.fn,
      required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    bool loader = Provider.of<OnlineConsultManager>(context).priscriptionLoader;

    // ScreenshotController screenshotController = ScreenshotController();
    GlobalKey ssKey = GlobalKey();
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    PrescriptionDetails pd = ppModel.prescriptionDetails!;
    String doctorName =
        '${pd.doctorFirstName ?? ''} ${pd.doctorLastName ?? ''}';
    String docAddressCity = pd.doctorCity != null ? '${pd.doctorCity},' : '';
    String docAddressState = pd.doctorState != null ? '${pd.doctorState},' : '';
    String docAddressCountry =
        pd.doctorCountry != null ? '${pd.doctorCountry},' : '';
    String doctorAddress =
        '$docAddressCity $docAddressState $docAddressCountry';
    String doctorQualif = pd.doctorProfessionalQualifications ?? '';
    String? patientName = pd.patientName;
    String? patientAge = pd.patientAge ?? "";
    String? patientgender = pd.gender;
    String? patientAddress = pd.address;
    String instructions = pd.instructions ?? "";
    String? observations = pd.observations;
    String? complaints = pd.complaints;
    String? height = pd.height;
    String? weight = pd.weight;
    String? bGroup = pd.bloodGroup;
    String? diagnos = pd.diagnosis?.map((e) => e.diagnosis).toList().join(", ");

    logoContainer() {
      return Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: Container(
            width: 60,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: Offset(2, 2),
                      color: Colors.black12)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                  top: Radius.circular(10),
                )),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset("assets/images/app-icon-with-text.png"),
            )),
      );
    }

    headBox(String txt) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            Container(
                decoration: const BoxDecoration(
                    color: Colours.primaryblue,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text(
                    txt,
                    style: TextStyles.presPreviewtxt6,
                  ),
                )),
          ],
        ),
      );
    }

    subTextHead(String txt) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                txt,
                style: TextStyles.presPreviewtxt9,
              ),
            ),
          ],
        ),
      );
    }

    rowText(String txt) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: SizedBox(
            child: Text(
          txt,
          style: TextStyles.presPreviewtxt12,
        )),
      );
    }

    noteTxt(String txt) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
                child: SizedBox(
                    child: Text(
              'Note: $txt',
              style: TextStyles.presPreviewtxt1,
            ))),
          ],
        ),
      );
    }

    contentBorderBox({required Widget child}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
            decoration: BoxDecoration(
                // color: Colours.primaryblue,
                border: Border.all(color: Colours.lightBlu),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: child,
            )),
      );
    }
    // getRow({required String title,required String val,}){
    //   return    Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //       Text('$title : ',style: TextStyles.presPreviewtxt1,),
    //       Expanded(child: SizedBox(child: Text(val,style: TextStyles.presPreviewtxt1,))),
    //     ],),
    //   );
    // }

    medicinesHeadRow({
      required String drug,
      required String freq,
      required String duration,
      required String instruction,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: const BoxDecoration(color: Colours.btnHash2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        child: Text(
                      drug,
                      style: TextStyles.presPreviewtxt1,
                    ))),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                        child: Text(
                      freq,
                      style: TextStyles.presPreviewtxt1,
                    ))),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                        child: Text(
                      duration,
                      style: TextStyles.presPreviewtxt1,
                    ))),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                        child: Text(
                      instruction,
                      style: TextStyles.presPreviewtxt1,
                    ))),
              ],
            ),
          ),
        ),
      );
    }

    detailRow({required String title, required String value}) {
      return Row(
        children: [
          SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.presPreviewtxt4b,
                  ),
                  Text(
                    ":",
                    style: TextStyles.presPreviewtxt4,
                  ),
                ],
              )),
          horizontalSpace(5),
          Text(
            value,
            style: TextStyles.presPreviewtxt4,
          ),
        ],
      );
    }

    medicinesRow(
        {required String drug,
        required String freq,
        required String unit,
        required String? dosages,
        required String duration,
        required String instruction,
        required bool isOdd}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: isOdd
                  ? Colours.btnHash2.withOpacity(0.3)
                  : Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        child: Text(
                      drug,
                      style: TextStyles.presPreviewtxt7,
                    ))),
                Expanded(
                    child: SizedBox(
                        child: Text(
                  '$freq\n(${dosages ?? "-"}) $unit',
                  style: TextStyles.presPreviewtxt7,
                  textAlign: TextAlign.left,
                ))),
                Expanded(
                    child: SizedBox(
                        child: Text(
                  duration,
                  style: TextStyles.presPreviewtxt7,
                ))),
                Expanded(
                    child: SizedBox(
                        child: Text(
                  instruction,
                  style: TextStyles.presPreviewtxt7,
                ))),
              ],
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getIt<SmallWidgets>().appBarWidget(
            title: "Prescription",
            height: h10p * 0.9,
            width: w10p,
            fn: () {
              Navigator.pop(context);
            }),
        body: pad(
          horizontal: 1,
          vertical: 1,
          child: ListView(
            children: [
              RepaintBoundary(
                key: ssKey,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: maxWidth,
                        // decoration: BoxDecoration(border: Border.all()),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: maxWidth,
                                  color: Colours.primaryblue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(doctorName,
                                            style: TextStyles.presPreviewtxt10),
                                        Text(doctorQualif,
                                            style: TextStyles.presPreviewtxt11),
                                        Text(doctorAddress,
                                            style: TextStyles.presPreviewtxt11),
                                        // Text("Medical Reg No. 2545465451884",style: TextStyles.presPreviewtxt11,),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                            Positioned(bottom: 0, child: logoContainer())
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                verticalSpace(8),
                                detailRow(
                                    title: "Patient Name",
                                    value: patientName ?? ""),
                                detailRow(
                                    title: "Age & Gender",
                                    value: "$patientAge / $patientgender"),
                                height != null
                                    ? detailRow(
                                        title: "Height", value: "$height cm")
                                    : const SizedBox(),
                                weight != null
                                    ? detailRow(
                                        title: "Weight", value: "$weight kg")
                                    : const SizedBox(),
                                bGroup != null
                                    ? detailRow(
                                        title: "Blood Group", value: bGroup)
                                    : const SizedBox()
                              ],
                            ),
                            SizedBox(
                                width: w10p * 3,
                                child: Text(
                                  patientAddress ?? "",
                                  style: TextStyles.presPreviewtxt5,
                                  textAlign: TextAlign.right,
                                ))
                          ],
                        ),
                      ),

                      headBox("Clinical Notes"),
                      contentBorderBox(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Column(
                          children: [
                            diagnos != null
                                ? detailRow(
                                    title: "Diagnosis",
                                    value: diagnos,
                                  )
                                : const SizedBox(),
                            complaints != null
                                ? detailRow(
                                    title: "Complaints",
                                    value: complaints,
                                  )
                                : const SizedBox(),
                            observations != null
                                ? detailRow(
                                    title: "Clinical Findings",
                                    value: observations,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )),

                      pd.drugs != null && pd.drugs!.isNotEmpty
                          ? headBox("Medicines")
                          : const SizedBox(),
                      pd.drugs != null && pd.drugs!.isNotEmpty
                          ? medicinesHeadRow(
                              drug: "Drug",
                              freq: "Frequency",
                              duration: "Duration",
                              instruction: "Instruction")
                          : const SizedBox(),
                      pd.drugs != null
                          ? Column(
                              children: pd.drugs!.map((e) {
                              var index = pd.drugs!.indexOf(e);

                              int frequencyInOneDay = e.dosageList != null
                                  ? e.dosageList!.length
                                  : 0;
                              String frequenctText = frequencyInOneDay > 0
                                  ? "$frequencyInOneDay per day"
                                  : "";
                              String? dosagesText = frequencyInOneDay > 0
                                  ? e.dosageList!
                                      .map((e) => e.dosage.toString())
                                      .toList()
                                      .join(", ")
                                  : null;
                              String drugUnit = e.drugUnit ?? "";

                              return medicinesRow(
                                drug: e.drug ?? "",
                                duration: getIt<StateManager>()
                                    .getDayLabel(e.duration ?? 0),
                                freq: frequenctText,
                                dosages: dosagesText,
                                unit: drugUnit,
                                instruction: e.medicineInstruction ?? "",
                                isOdd: index % 2 != 0,
                              );
                            }).toList())
                          : const SizedBox(),

                      pd.labOrders != null &&
                              pd.labOrders!.isNotEmpty &&
                              pd.labOrders!.first.labTests != null
                          ? headBox("Lab Orders")
                          : const SizedBox(),
                      pd.labOrders != null &&
                              pd.labOrders!.isNotEmpty &&
                              pd.labOrders!.first.labTests != null
                          ? contentBorderBox(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subTextHead("Tests"),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: pd.labOrders!.first.labTests!
                                        .map((e) => rowText(
                                              e.labTest ?? "",
                                            ))
                                        .toList()),
                              ],
                            ))
                          : const SizedBox(),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            subTextHead("Instructions"),
                            rowText(
                                instructions.isNotEmpty ? instructions : "N/A")
                          ],
                        ),
                      ),

                      // instructions!=null?noteTxt(
                      //   instructions,
                      // ):SizedBox(),

                      Container(
                          color: Colours.logoWhite.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 8),
                            child: Text(
                              "Disclaimer:${StringConstants.prescriptionDeclaimer}",
                              style: TextStyles.presPreviewtxt8,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              verticalSpace(8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colours.btnHash),
                          child: pad(
                            vertical: h1p,
                            child: Text(
                              textAlign: TextAlign.center,
                              "Cancel",
                              style: TextStyles.prescript3b,
                            ),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(w1p * 2),
                    Expanded(
                      child: loader == false
                          ? InkWell(
                              onTap: () async {
                                RenderRepaintBoundary boundary =
                                    ssKey.currentContext!.findRenderObject()
                                        as RenderRepaintBoundary;
                                ui.Image img =
                                    await boundary.toImage(pixelRatio: 3);
                                ByteData? bytes = await img.toByteData(
                                    format: ui.ImageByteFormat.png);
                                Uint8List memoryImageData =
                                    bytes!.buffer.asUint8List();

                                File imgFile =
                                    await getIt<OnlineConsultManager>()
                                        .writeUint8ListToFile(
                                            memoryImageData, "prescptImg");
                                // ShowCapturedWidget(context, imgFile);

                                var result = await getIt<OnlineConsultManager>()
                                    .savePrescriptionImage(
                                        ppModel.prescriptionDetails!.id!,
                                        imgFile);

                                if (result.status == true &&
                                    result.prescriptionImg != null) {
                                  // ShowCapturedWidget(context, memoryImageData);
                                  // screenshotController.capture(delay: Duration(milliseconds: 10))
                                  //     .then((capturedImage) async {
                                  //   ShowCapturedWidget(context, capturedImage!);
                                  // }).catchError((onError) {
                                  //   print(onError);
                                  // });

                                  // final imgmsg = types.ImageMessage.fromJson({
                                  //   "author": {
                                  //     "firstName": "John",
                                  //     "id": '1',
                                  //     "lastName": "Doe"
                                  //   },
                                  //   "createdAt": DateTime.now().millisecondsSinceEpoch,
                                  //   "height": 1280,
                                  //   "id": const Uuid().v4(),
                                  //   "name": "madsdrid",
                                  //   "size": 585000,
                                  //   "status": "seen",
                                  //   "type": "image",
                                  //   "uri": '${StringConstants.imgBaseUrl}${result.prescriptionImg}',
                                  //   "width": 1920
                                  // });
                                  getIt<ChatProvider>().fireBSendMessage(
                                    id: const Uuid().v4(),
                                    roomId: appoinmentId,
                                    type: 'Image',
                                    msg: null,
                                    imageUrl: result.prescriptionImg,
                                    userID:
                                        '${getIt<SharedPreferences>().getInt(StringConstants.userId) ?? ''}',
                                  );

                                  // getIt<OnlineConsultManager>().addMessageToChat(imgmsg);
                                  // Navigator.popUntil(context, ModalRoute.withName('/chat'));
                                  Navigator.pop(context, true);
                                  // Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: result.message ?? "");
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colours.primaryblue),
                                child: pad(
                                  vertical: h1p,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Send",
                                    style: TextStyles.prescript3,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colours.primaryblue),
                              child: pad(
                                vertical: h1p,
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "Sending...",
                                  style: TextStyles.prescript3,
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
    );
  }
}

Future<dynamic> ShowCapturedWidget(BuildContext context, File capturedImage) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
      appBar: AppBar(
        title: const Text("Captured widget screenshot"),
      ),
      body: Center(child: Image.file(capturedImage)),
    ),
  );
}
