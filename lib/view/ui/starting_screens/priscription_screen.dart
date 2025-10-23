import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/ui/starting_screens/drop_down_list_popup.dart';
import 'package:dqueuedoc/view/ui/starting_screens/prescription_preview_screen.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../controller/managers/online_consult_manager.dart';
import '../../../model/core/basic_response_model.dart';
import '../../../model/core/drug_params_model.dart';
import '../../../model/core/prescription_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/widgets.dart';
import 'add_drug_screen.dart';

class PrescriptionScreen extends StatefulWidget {
  final int bookingId;
  final String appoinmentId;
  final bool navigatingFrmChat;
  const PrescriptionScreen({
    super.key,
    required this.navigatingFrmChat,
    required this.appoinmentId,
    required this.bookingId,
  });

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  // String fnameC = "";
  // String lnameC = "";
  // String ageC = "";
  // String genderC = "";
  // String relationC = "";
  // String maritalStatus = "";

  var hghtC = TextEditingController();
  var weightC = TextEditingController();

  var allergiesC = TextEditingController();
  var pastMedHistoryC = TextEditingController();
  var pastMedicationsC = TextEditingController();
  var complaintsC = TextEditingController();
  var examinationsC = TextEditingController();

  var remarks = TextEditingController();
  var doctorNoteC = TextEditingController();
  var instructionsC = TextEditingController();

  final DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    // fnameC = widget.user.firstName ?? "";
    // lnameC = widget.user.lastName ?? "";
    // ageC = widget.user.dateOfBirth ?? "";
    // genderC = widget.user.gender ?? "";
    // maritalStatus = widget.user.maritalStatus ?? "";
    // relationC =
    // widget.relation != null ? widget.relation! : widget.user.relation ?? "";
    // HghtC.text = widget.user.height ?? "";
    // weightC.text = widget.user.weight ?? "";
    // bSugarC.text = widget.user.bloodSugar ?? "";
    // BpC.text = widget.user.bloodPressure ?? "";
    // serumC.text = widget.user.serumCreatinine ?? "";
    // print(getIt<SharedPreferences>().getInt(StringConstants.userId));
    // print(widget.user.id);
    // print(widget.user.firstName);
    getIt<OnlineConsultManager>().getDrugParams();
  }

  @override
  void dispose() {
    super.dispose();
    // getIt<OnlineConsultManager>().disposePriscrip();
  }

  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    // double maxWidth = this.widget.maxWidth;
    double h1p = maxHeight * 0.01;
    double h10p = maxHeight * 0.1;
    double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;

    Container myBox({required String hint, required Widget child}) {
      return Container(
        width: maxWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colours.lightBlu),
        ),
        child: Padding(padding: const EdgeInsets.all(8.0), child: child),
      );
    }

    unFocusFn() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }

    Widget drugItem({required DrugItem item, required int index}) {
      FixedInterval e = item.fixedInterval ?? FixedInterval();
      String morningDsg = e.morningDosage != null
          ? '${e.morningDosage!.title}'
          : "0";
      String afterNoonDsg = e.afternoonDosage != null
          ? '${e.afternoonDosage!.title}'
          : "0";
      String eveningDsg = e.eveningDosage != null
          ? '${e.eveningDosage!.title}'
          : "0";
      String nightDsg = e.nightDosage != null ? '${e.nightDosage!.title}' : "0";

      String? fixedIntervalTxt =
          '$morningDsg - $afterNoonDsg - $eveningDsg - $nightDsg ${item.drugUnit?.title ?? ""}';

      String? dosage = item.variableInterval?.dosage.toString();
      String? interval = item.variableInterval?.interval.toString();
      String? intervalType = item.variableInterval?.intervalType;

      String? variableIntervalTxt =
          '$dosage ${item.drugUnit?.title ?? ""} - $interval - $intervalType';

      return Padding(
        padding: EdgeInsets.only(bottom: h1p * 0.5),
        child: Container(
          width: maxWidth,
          decoration: BoxDecoration(
            color: Colours.lightBlu,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: h1p,
                  horizontal: w1p * 3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(item.drug?.item ?? "", style: TextStyles.drugDet1),
                      ],
                    ),
                    item.drugType != null
                        ? Text(
                            item.drugType?.title ?? "",
                            style: TextStyles.drugDet3,
                          )
                        : const SizedBox(),
                    Row(
                      children: [
                        item.fixedInterval != null
                            ? Text(fixedIntervalTxt, style: TextStyles.drugDet2)
                            : Text(
                                variableIntervalTxt,
                                style: TextStyles.drugDet2,
                              ),
                      ],
                    ),
                    Text(item.instructions ?? "", style: TextStyles.drugDet2),
                  ],
                ),
              ),
              Positioned(
                right: 2,
                top: 2,
                child: InkWell(
                  onTap: () {
                    getIt<OnlineConsultManager>().removeDrugItem(index);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 25,
                      color: Colours.boxblue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Column titleHead(String title) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.prescript1),
          // Divider(color: Colours.grad1.withOpacity(0.1),),
          // verticalSpace(h1p * 1),
        ],
      );
    }

    Column subHead({required String title, bool? isRequired}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.textStyle10),
              isRequired == true
                  ? Text('*', style: TextStyles.textStyle10b)
                  : const SizedBox(),
            ],
          ),
          verticalSpace(h1p * 0.4),
        ],
      );
    }

    // List<String> langs = ["English","Malayalam"];
    //     List<String> genders = ["Male", "Female", "Other"];
    //     List<String> maritalStats = ["Married", "Unmarried"];
    //     List<String> items = ["Item 1", "Item 2", "Item 3 dfhdk  ", "Item 4","Item 1", "Item 2", "Item 3", "Item 4","Item 1", "Item 2", "Item 3", "Item 4",];
    //     List<bool> checked = [false, false, true, false,false, false, true, false,false, false, true, false,];

    return Consumer<OnlineConsultManager>(
      builder: (context, mgr, child) {
        PrescriptionModel presData = mgr.presModel;
        hghtC.text = hghtC.text.isEmpty
            ? presData.height != null
                  ? presData.height.toString()
                  : ""
            : hghtC.text;
        weightC.text = weightC.text.isEmpty
            ? presData.weight != null
                  ? presData.weight.toString()
                  : ""
            : weightC.text;
        // bg.text = bg.text.isEmpty? presData.bloodGroup!=null? presData.weight.toString():"":weightC.text;
        allergiesC.text = allergiesC.text.isEmpty
            ? presData.allergy != null
                  ? presData.allergy.toString()
                  : ""
            : allergiesC.text;
        pastMedHistoryC.text = pastMedHistoryC.text.isEmpty
            ? presData.pastMedHistory != null
                  ? presData.pastMedHistory.toString()
                  : ""
            : pastMedHistoryC.text;
        // pastMedicationsC.text = pastMedicationsC.text.isEmpty? presData.pastMedications!=null? presData.pastMedications.toString():"":pastMedicationsC.text;
        complaintsC.text = complaintsC.text.isEmpty
            ? presData.complaints != null
                  ? presData.complaints.toString()
                  : ""
            : complaintsC.text;
        examinationsC.text = examinationsC.text.isEmpty
            ? presData.observations != null
                  ? presData.observations.toString()
                  : ""
            : examinationsC.text;
        remarks.text = remarks.text.isEmpty
            ? presData.labTestRemark != null
                  ? presData.labTestRemark.toString()
                  : ""
            : remarks.text;
        doctorNoteC.text = doctorNoteC.text.isEmpty
            ? presData.doctorNote != null
                  ? presData.doctorNote.toString()
                  : ""
            : doctorNoteC.text;
        instructionsC.text = instructionsC.text.isEmpty
            ? presData.doctorInstructions != null
                  ? presData.doctorInstructions.toString()
                  : ""
            : instructionsC.text;
        String? bgroup = presData.bloodGroup;
        List<Param> diagnonises = mgr.drugParams?.commonDiagnosis ?? [];
        List<Param> labreports = mgr.drugParams?.labTest ?? [];
        List<Drug> drugs = mgr.drugParams?.drugs ?? [];

        return GestureDetector(
          onTap: () {
            unFocusFn();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: getIt<SmallWidgets>().appBarWidget(
              title: "Prescription",
              height: h10p * 0.7,
              width: w10p,
              fn: () {
                Navigator.pop(context);
              },
              child: Opacity(
                opacity: 0.8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colours.boxblue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: SvgPicture.asset(
                            "assets/images/calendar-fill.svg",
                            height: 15,
                          ),
                        ),
                        horizontalSpace(w1p),
                        Text(
                          getIt<StateManager>().getFormattedDate(
                            _selectedDate.toString(),
                          ),
                          style: TextStyles.prescript7b,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
            // extendBody: true,
            // backgroundColor: Colors.r=tr,
            body: SizedBox(
              height: maxHeight,
              width: maxWidth,
              child: Stack(
                children: [
                  pad(
                    horizontal: w1p * 4,
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          verticalSpace(h1p * 1.5),

                          // InkWell(
                          //     onTap: (){
                          //       showModalBottomSheet(isScrollControlled: true,useSafeArea: true,showDragHandle: true,
                          //         backgroundColor: Colors.white,
                          //         context: context,
                          //         builder: (BuildContext context) {
                          //           return SizedBox(height: 250,
                          //             child: Column(
                          //               children: [
                          //
                          //                 pad(horizontal:w1p*6,
                          //                   child: Row(
                          //                     mainAxisAlignment: MainAxisAlignment.end,
                          //                     children: [
                          //                     InkWell(
                          //                         onTap: (){
                          //                           setState(() {
                          //                             _selectedDate = DateTime.now();
                          //                           });
                          //
                          //                           Navigator.pop(context);
                          //                         },child: Text("Today",style: TextStyles.scrollWheelUnSelected,))
                          //                   ],),
                          //                 ),
                          //                 SizedBox(
                          //                   height: 220,
                          //                   child: ScrollDatePicker(
                          //                     // indicator: Text("sdsd"),
                          //                     selectedDate: _selectedDate,
                          //                     locale: Locale('en'),
                          //                     onDateTimeChanged: (DateTime value) {
                          //                       setState(() {
                          //                         _selectedDate = value;
                          //                       });
                          //                     },
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     },
                          //
                          //     child: Row(mainAxisAlignment: MainAxisAlignment.end,
                          //       children: [
                          //         Container(
                          //
                          //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),border: Border.all(color:Colours.boxblue)),
                          //             child: Padding(
                          //           padding: const EdgeInsets.all(5.0),
                          //           child: Row(
                          //             children: [SvgPicture.asset("assets/images/calendar-fill.svg"),
                          //               horizontalSpace(w1p),
                          //               Text(getIt<StateManager>().getFormattedDate(_selectedDate.toString()),
                          //               style: TextStyles.prescript7b,
                          //               ),
                          //             ],
                          //           ),
                          //         )),
                          //       ],
                          //     )),
                          ExpansionTile(
                            initiallyExpanded: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: titleHead("Patient details"),
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subHead(title: "Height(cm)"),
                                          SizedBox(
                                            // height: h1p * 6,
                                            child: MyTextFormField2(
                                              type: "height",
                                              cntrolr: hghtC,
                                              hnt: "",
                                              isNumber: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    horizontalSpace(w1p * 2),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subHead(title: "Weight(kg)"),
                                          SizedBox(
                                            // height: h1p * 6,
                                            child: MyTextFormField2(
                                              type: "weight",
                                              cntrolr: weightC,
                                              hnt: "",
                                              isNumber: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    horizontalSpace(w1p * 2),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          subHead(title: "Blood Group"),

                                          SizedBox(
                                            // height: h1p * 6,
                                            child: DropdownSearch<String>(
                                              selectedItem: bgroup,
                                              popupProps: const PopupProps.menu(
                                                showSelectedItems: false,
                                                showSearchBox: false,
                                                // showSelectedItems: true,
                                                // disabledItemFn: (String s) => s.startsWith('I'),
                                              ),
                                              // items: const [
                                              //   "A+",
                                              //   "A-",
                                              //   "B+",
                                              //   "B-",
                                              //   "AB+",
                                              //   "AB-",
                                              //   "O+",
                                              //   "O-"
                                              // ],
                                              items: bloodGroups,
                                              // (
                                              //   String filter,
                                              //   LoadProps? props,
                                              // ) async {
                                              //   // If you want filtering:
                                              //   if (filter.isEmpty)
                                              //     return bloodGroups;
                                              //   return bloodGroups
                                              //       .where(
                                              //         (item) => item
                                              //             .toLowerCase()
                                              //             .contains(
                                              //               filter
                                              //                   .toLowerCase(),
                                              //             ),
                                              //       )
                                              //       .toList();
                                              // },
                                              dropdownDecoratorProps:
                                                  DropDownDecoratorProps(
                                                    // dropdownSearchDecoration:
                                                    //     inputDec5(hnt: ""),
                                                  ),
                                              // dropdownDecoratorProps:
                                              //     DropDownDecoratorProps(
                                              //       dropdownSearchDecoration:
                                              //           inputDec5(hnt: ""),
                                              //     ),
                                              onChanged: (val) {
                                                getIt<OnlineConsultManager>()
                                                    .setBloodGroup(val);
                                              },
                                              // selectedItem: merchand,
                                            ),
                                          ),

                                          // SizedBox(
                                          //     height: h1p * 6,
                                          //     child: MyTextFormField2(type: "char",onTap: (){
                                          //       showDialog(
                                          //         context: context,
                                          //         builder: (BuildContext context) {
                                          //           return DrugUnitList(drugUnits:mgr.drugParams!.drugUnit??[],selectedUnitId: mgr.selectedDrugUnit!=null?mgr.selectedDrugUnit!.id:null);
                                          //         },
                                          //       );
                                          //     },
                                          //       hnt: mgr.selectedDrugUnit!=null?mgr.selectedDrugUnit!.title??"":"",
                                          //       isNumber: false,readOnly: true,
                                          //     )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              verticalSpace(h1p * 1.5),
                            ],
                          ),
                          ExpansionTile(
                            initiallyExpanded: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: titleHead("Clinical Notes"),
                            children: [
                              subHead(title: "Diagnosis", isRequired: true),
                              // getDropDwn(),
                              InkWell(
                                onTap: () {
                                  unFocusFn();

                                  getIt<StateManager>().setListItems(
                                    isRefresh: true,
                                    diagnonises
                                        .map(
                                          (e) => BasicListItem(
                                            item: e.title,
                                            id: e.id,
                                          ),
                                        )
                                        .toList(),
                                  );
                                  getIt<StateManager>().addItems(
                                    isRefresh: true,
                                    presData.diagnosis != null
                                        ? presData.diagnosis!
                                              .map(
                                                (e) => BasicListItem(
                                                  item: e,
                                                  id: 0,
                                                ),
                                              )
                                              .toList()
                                        : [],
                                  );

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    useSafeArea: false,
                                    showDragHandle: true,
                                    isDismissible: false,
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DropDownListScreen(
                                        maxWidth: maxWidth,
                                        maxHeight: maxHeight,
                                        //   lst:
                                        // diagnonises.map((e)=>BasicListItem(item: e.title,id: e.id)).toList(),
                                        //   selectedItems: presData.diagnosis!=null?presData.diagnosis!.map((e)=>BasicListItem(item: e,id: 0)).toList():[],
                                        fn: (selectedItems) {
                                          if (selectedItems.isNotEmpty) {
                                            getIt<OnlineConsultManager>()
                                                .addDiagnosis(
                                                  selectedItems
                                                      .map((e) => e.item!)
                                                      .toList(),
                                                );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                child: myBox(
                                  hint: "",
                                  child:
                                      presData.diagnosis != null &&
                                          presData.diagnosis!.isNotEmpty
                                      ? Text(
                                          presData.diagnosis?.join(", ") ?? "",
                                          style: TextStyles.txtBox2,
                                        )
                                      : Text(
                                          "Diagnosis",
                                          style: TextStyles.txtBox1b,
                                        ),
                                ),
                              ),

                              verticalSpace(h1p * 1.5),

                              subHead(title: "Allergies"),
                              SizedBox(
                                height: h1p * 6,
                                child: MyTextFormField(
                                  type: "char",
                                  onsubmit: (val) {
                                    // getIt<OnlineConsultManager>().addDiagnosis(val);
                                    // doctorNoteC.clear();
                                  },
                                  cntrolr: allergiesC,
                                  hnt: "",
                                  isNumber: false,
                                ),
                              ),
                              verticalSpace(h1p * 1.5),
                              subHead(title: "Past Medical History"),
                              SizedBox(
                                height: h1p * 6,
                                child: MyTextFormField(
                                  type: "char",
                                  onsubmit: (val) {
                                    // getIt<OnlineConsultManager>().addDiagnosis(val);
                                    // doctorNoteC.clear();
                                  },
                                  cntrolr: pastMedHistoryC,
                                  hnt: "",
                                  isNumber: false,
                                ),
                              ),
                              verticalSpace(h1p * 1.5),

                              subHead(title: "Past Medication History"),
                              InkWell(
                                onTap: () {
                                  unFocusFn();
                                  getIt<StateManager>().setListItems(
                                    isRefresh: true,
                                    drugs
                                        .map(
                                          (e) => BasicListItem(
                                            item: e.title,
                                            id: e.id,
                                          ),
                                        )
                                        .toList(),
                                  );
                                  getIt<StateManager>().addItems(
                                    isRefresh: true,
                                    presData.pastMedications != null
                                        ? presData.pastMedications!
                                        : [],
                                  );

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    showDragHandle: true,
                                    isDismissible: false,
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return
                                      //       Navigator.push(context, MaterialPageRoute(builder: (_)=>
                                      DropDownListScreen(
                                        maxWidth: maxWidth,
                                        maxHeight: maxHeight,
                                        //   lst:
                                        // drugs.map((e)=>BasicListItem(item: e.title,id: e.id)).toList(),
                                        //   selectedItems: presData.pastMedications!=null?presData.pastMedications!:[],
                                        fn: (selectedItems) {
                                          if (selectedItems.isNotEmpty) {
                                            getIt<OnlineConsultManager>()
                                                .addPastMedics(selectedItems);
                                          }
                                        },
                                      );
                                      // ));
                                    },
                                  );
                                },
                                child: myBox(
                                  hint: "Past Medications",
                                  child:
                                      presData.pastMedications != null &&
                                          presData.pastMedications!.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: presData.pastMedications!
                                              .map(
                                                (e) => SizedBox(
                                                  child: pad(
                                                    vertical: 5,
                                                    child: Text(
                                                      '- ${e.item}',
                                                      style: TextStyles.txtBox2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : pad(
                                          vertical: 5,
                                          child: Text(
                                            "Past Medications",
                                            style: TextStyles.txtBox1b,
                                          ),
                                        ),
                                ),
                              ),
                              verticalSpace(h1p * 1.5),
                              subHead(title: "Complaints"),
                              SizedBox(
                                height: h1p * 6,
                                child: MyTextFormField(
                                  type: "char",
                                  onsubmit: (val) {},
                                  cntrolr: complaintsC,
                                  hnt: "",
                                  isNumber: false,
                                ),
                              ),
                              verticalSpace(h1p * 1.5),

                              subHead(title: "Examinations (systemic & local)"),
                              SizedBox(
                                height: h1p * 6,
                                child: MyTextFormField(
                                  type: "char",
                                  onsubmit: (val) {},
                                  cntrolr: examinationsC,
                                  hnt: "",
                                  isNumber: false,
                                ),
                              ),

                              verticalSpace(h1p * 1.5),

                              // MultiSelectSearchDropdown(),
                              // verticalSpace(h1p * 1),
                              // DropdownSearch<String>.multiSelection(
                              //   popupProps: PopupPropsMultiSelection.dialog(showSelectedItems: false,
                              //     showSearchBox: true,searchFieldProps: TextFieldProps(
                              //       // autofocus: true,
                              //         decoration: inputDec5(hnt: "Search")),
                              //     // menuProps: MenuProps(backgroundColor: Colors.white,),
                              //     // showSelectedItems: true,
                              //     // disabledItemFn: (String s) => s.startsWith('I'),
                              //   ),
                              //   items:diagnonises,dropdownDecoratorProps: DropDownDecoratorProps(
                              //     dropdownSearchDecoration: inputDec6(hnt: "Select")
                              // ),
                              //   onChanged: (val){
                              //     // getIt<OnlineConsultManager>().setUpDrugType(val!=null?Param(title: val.item??"",id: val.id):null);
                              //
                              //   },
                              //   // selectedItem: merchand,
                              // ),
                              //  Column(crossAxisAlignment: CrossAxisAlignment.start,
                              //       // mainAxisAlignment: MainAxisAlignment.start,
                              //       children: mgr.addedDiagnosis.map((e) {
                              //         var index = mgr.addedDiagnosis.indexOf(e);
                              //    return Padding(padding: EdgeInsets.only(bottom: h1p*0.5),
                              //      child: Row(
                              //        children: [
                              //          Expanded(
                              //            child: Container(decoration: BoxDecoration(  borderRadius: BorderRadius.circular(10.0),
                              //              border: Border.all(
                              //                width: 1,
                              //                color: Colours.lightBlu,
                              //              ),color: Colours.lightBlu),
                              //              child: pad(
                              //               horizontal: w1p*4,vertical: h1p,
                              //               child: Text(e,style: TextStyles.txtBox1)),
                              //            ),
                              //          ),
                              //          InkWell(
                              //              onTap:(){
                              //                getIt<OnlineConsultManager>().removeDiagnosis(index);
                              //
                              //              },child: Icon(Icons.close,color: Colors.grey,))
                              //        ],
                              //      ),
                              //    );
                              //   }).toList()),
                            ],
                          ),

                          ExpansionTile(
                            initiallyExpanded: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: titleHead("Investigations / Lab Orders"),
                            children: [
                              InkWell(
                                onTap: () {
                                  unFocusFn();
                                  getIt<StateManager>().setListItems(
                                    isRefresh: true,
                                    labreports
                                        .map(
                                          (e) => BasicListItem(
                                            item: e.title,
                                            id: e.id,
                                          ),
                                        )
                                        .toList(),
                                  );
                                  getIt<StateManager>().addItems(
                                    isRefresh: true,
                                    presData.labTestList != null
                                        ? presData.labTestList!
                                        : [],
                                  );

                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    showDragHandle: true,
                                    isDismissible: false,
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DropDownListScreen(
                                        maxWidth: maxWidth,
                                        maxHeight: maxHeight,
                                        //   lst:
                                        // labreports.map((e)=>BasicListItem(item: e.title,id: e.id)).toList(),
                                        //   selectedItems: presData.labTestList!=null?presData.labTestList!:[],
                                        fn: (selectedItems) {
                                          if (selectedItems.isNotEmpty) {
                                            getIt<OnlineConsultManager>()
                                                .addLabTests(selectedItems);
                                          } else {
                                            getIt<OnlineConsultManager>()
                                                .addLabTests([]);
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                child: myBox(
                                  hint: "Lab Orders",
                                  child:
                                      presData.labTestList != null &&
                                          presData.labTestList!.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: presData.labTestList!
                                              .map(
                                                (e) => SizedBox(
                                                  child: pad(
                                                    vertical: 5,
                                                    child: Text(
                                                      '- ${e.item}',
                                                      style: TextStyles.txtBox2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : pad(
                                          vertical: 5,
                                          child: Text(
                                            "Lab Orders",
                                            style: TextStyles.txtBox1b,
                                          ),
                                        ),
                                ),
                              ),
                              verticalSpace(h1p * 1.5),
                              subHead(title: "Remarks"),
                              MyTextFormField2(
                                type: "char",
                                onsubmit: (val) {},
                                minLine: 2,
                                maxLine: 2,
                                hnt: "Note",
                                isNumber: false,
                              ),
                              verticalSpace(h1p * 1.5),
                              subHead(title: "Doctor's notes"),
                              SizedBox(
                                height: h1p * 6,
                                child: MyTextFormField2(
                                  type: "char",
                                  onsubmit: (val) {},
                                  cntrolr: doctorNoteC,
                                  hnt:
                                      "This note is not intended for patient display",
                                  isNumber: false,
                                ),
                              ),
                            ],
                          ),

                          ExpansionTile(
                            initiallyExpanded: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: titleHead("Medications"),
                            children: [
                              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "Medications",
                              //       style: TextStyles.prescript1,
                              //     ),
                              //
                              //     mgr.drugList.isNotEmpty?InkWell(
                              //       onTap: (){
                              //         showModalBottomSheet(isScrollControlled: true,useSafeArea: true,showDragHandle: true,
                              //           backgroundColor: Colors.white,
                              //           context: context,
                              //           builder: (BuildContext context) {
                              //             return AddDrugSheet(maxWidth: maxWidth,maxHeight: maxHeight);
                              //           },
                              //         );
                              //
                              //       },
                              //       child: Row(
                              //         children: [
                              //           Text(
                              //             "Add Drug",
                              //             style: TextStyles.prescript5,
                              //           ),
                              //           horizontalSpace(w1p),
                              //           Container(decoration: BoxDecoration(
                              //               color: Colours.primaryblue,
                              //               shape: BoxShape.circle),
                              //
                              //               child: Padding(
                              //                 padding:  EdgeInsets.all(h1p*0.3),
                              //                 child: SvgPicture.asset("assets/images/icon-add.svg"),
                              //               )),
                              //         ],
                              //       ),
                              //     ):SizedBox()

                              //   ],
                              // ),
                              Column(
                                children: presData.drugsList.map((e) {
                                  var i = presData.drugsList.indexOf(e);

                                  return drugItem(item: e, index: i);
                                }).toList(),
                              ),
                              Container(
                                width: maxWidth,
                                decoration: const BoxDecoration(
                                  color: Colours.lightBlu,
                                ),
                                child: pad(
                                  vertical: h1p * 2,
                                  child: InkWell(
                                    onTap: () {
                                      unFocusFn();
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        showDragHandle: true,
                                        backgroundColor: Colors.white,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AddDrugSheet(
                                            maxWidth: maxWidth,
                                            maxHeight: maxHeight,
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: h1p * 5,
                                          width: h1p * 5,
                                          decoration: BoxDecoration(
                                            color: Colours.primaryblue
                                                .withOpacity(0.6),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(h1p * 0.3),
                                            child: SvgPicture.asset(
                                              "assets/images/icon-add.svg",
                                              color: Colours.lightBlu,
                                            ),
                                          ),
                                        ),
                                        verticalSpace(h1p * 0.3),
                                        Text(
                                          "Add Drug",
                                          style: TextStyles.textStyle2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            initiallyExpanded: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: titleHead("Recommendations / instructions"),
                            children: [
                              SizedBox(
                                height: h1p * 6,
                                child: MyTextFormField2(
                                  type: "char",
                                  onsubmit: (val) {},
                                  hnt: "Note",
                                  cntrolr: instructionsC,
                                  isNumber: false,
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(h1p * 3),

                          mgr.priscriptionLoader == false
                              ? GestureDetector(
                                  onTap: () async {
                                    unFocusFn();

                                    // getIt<BookingManager>().addNewPatientAPI(usr);

                                    final isValid = _formKey.currentState!
                                        .validate();

                                    if (isValid &&
                                        double.tryParse(
                                              hghtC.text.isEmpty
                                                  ? "0"
                                                  : hghtC.text,
                                            ) !=
                                            null &&
                                        double.tryParse(
                                              weightC.text.isEmpty
                                                  ? "0"
                                                  : weightC.text,
                                            ) !=
                                            null) {
                                      PrescriptionModel temp = mgr.presModel;
                                      temp.allergy = allergiesC.text;
                                      temp.pastMedHistory =
                                          pastMedHistoryC.text;
                                      temp.pastMedications =
                                          mgr.presModel.pastMedications;
                                      temp.complaints = complaintsC.text;
                                      temp.observations = examinationsC.text;
                                      temp.labTestRemark = remarks.text;
                                      temp.doctorNote = doctorNoteC.text;
                                      temp.doctorInstructions =
                                          instructionsC.text;
                                      temp.height = hghtC.text.isNotEmpty
                                          ? hghtC.text
                                          : null;
                                      temp.weight = weightC.text.isNotEmpty
                                          ? weightC.text
                                          : null;

                                      await getIt<OnlineConsultManager>()
                                          .setPrescriptionModel(temp);
                                      var result =
                                          await getIt<OnlineConsultManager>()
                                              .sendPrescription(
                                                bookingId: widget.bookingId,
                                              );
                                      if (result.status == true) {
                                        bool? res = await showDialog(
                                          // isScrollControlled: true,
                                          useSafeArea: true,
                                          // showDragHandle: true,
                                          // backgroundColor: Colors.white,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return PrescriptionPreviewScreen(
                                              appoinmentId: widget.appoinmentId,
                                              ppModel: result,
                                              maxHeight: maxHeight,
                                              maxWidth: maxWidth,
                                              fn: (val) {},
                                            );
                                          },
                                        );

                                        if (res != null) {
                                          if (widget.navigatingFrmChat ==
                                              true) {
                                            Navigator.pop(context);
                                          }
                                          // else if(widget.pgCntroller!=null){
                                          //   widget.pgCntroller!.animateToPage(0,duration: Duration(milliseconds: 1000),curve: Curves.ease);
                                          //   getIt<StateManager>().updateHomeIndex(val:true);
                                          // }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: result.message ?? "",
                                        );
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "invalid data",
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w1p * 6,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(21),
                                              color: Colours.primaryblue,
                                            ),
                                            child: pad(
                                              vertical: h1p,
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                "Preview",
                                                style: TextStyles.prescript3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: w1p * 6,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              21,
                                            ),
                                            color: Colours.primaryblue,
                                          ),
                                          child: pad(
                                            vertical: h1p,
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                          verticalSpace(h1p * 3),
                        ],
                      ),
                    ),
                  ),
                  myLoader(
                    width: maxWidth,
                    height: maxHeight,
                    visibility: false,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
