import 'dart:developer';

import 'package:dqueuedoc/model/core/basic_response_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../controller/managers/online_consult_manager.dart';
import '../../../model/core/drug_params_model.dart';
import '../../../model/core/prescription_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/text_styles.dart';
import '../../theme/widgets.dart';

class AddDrugSheet extends StatefulWidget {
  final double maxWidth;
  final double maxHeight;

  const AddDrugSheet({
    super.key,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  State<AddDrugSheet> createState() => _AddDrugSheetState();
}

class _AddDrugSheetState extends State<AddDrugSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    getIt<OnlineConsultManager>().disposeAddDrug();
    super.dispose();
  }

  unFocusFn() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  var drugC = TextEditingController();
  var durationC = TextEditingController();
  var noteC = TextEditingController();
  var dosageC = TextEditingController();
  var intervalC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h1p = widget.maxHeight * 0.01;
    // double h10p = widget.maxHeight * 0.1;
    // double w10p = widget.maxWidth * 0.1;
    double w1p = widget.maxWidth * 0.01;

    Column subHead(String title) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyles.textStyle10),
          verticalSpace(h1p * 0.4),
        ],
      );
    }

    doseBox({
      required String hnt,
      required String? value,
      required String doseTime,
      required List<Param> doses,
    }) {
      return InkWell(
        onTap: () async {
          unFocusFn();
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DosesList(dTime: doseTime);
            },
          );

          if (result != null) {
            getIt<OnlineConsultManager>().setUpDoses(
              Param(id: null, title: result.toString()),
              doseTime,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colours.primaryblue, width: 1),
            gradient: const LinearGradient(
              colors: [Color(0xffF3F3F3), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          width: h1p * 7,
          height: h1p * 7,
          child: Center(
            child: value != null
                ? Text(value, style: TextStyles.prescript5)
                : Text(hnt, style: TextStyles.addDrugTxt4),
          ),
        ),
      );
    }

    List<String> intervalTypeList = ["Hour", "Day", "Week", "Month"];

    List<String> durations = ["Days", "Weeks", "Months"];
    List<String> intervalType = ["Fixed interval", "Variable interval"];
    List<Param> dossTemp = [
      Param(title: "0.5", id: 1),
      Param(title: "1", id: 2),
      Param(title: "1.5", id: 3),
      Param(title: "2", id: 4),
    ];

    return Consumer<OnlineConsultManager>(
      builder: (context, mgr, child) {
        List<BasicListItem> drugUnits = mgr.drugParams?.drugUnit != null
            ? mgr.drugParams!.drugUnit!
                  .map((e) => BasicListItem(id: e.id, item: e.title))
                  .toList()
            : [];
        List<BasicListItem> drugtypes = mgr.drugParams?.drugType != null
            ? mgr.drugParams!.drugType!
                  .map((e) => BasicListItem(id: e.id, item: e.title))
                  .toList()
            : [];
        List<Drug> drugs = mgr.drugParams?.drugs != null
            ? mgr.drugParams!.drugs!
                  // .map((e)=>BasicListItem(id: e.id,item: e.title))
                  .toList()
            : [];

        return GestureDetector(
          onTap: () {
            unFocusFn();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            // return Container(height: widget.maxHeight - h1p*5,
            // color: Colors.white,
            // type:MaterialType.card ,
            // actionsPadding: EdgeInsets.only(bottom: 18,right: 10),shape:RoundedRectangleBorder(
            // borderRadius: BorderRadius.all(Radius.circular(11)),
            // contentPadding: EdgeInsets.symmetric(vertical: h1p*2,horizontal: w1p*4),
            // insetPadding:EdgeInsets.zero ,
            // title: Text("Diagnosis List",style: TextStyles.prescript4,),
            body: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w1p * 5,
                      vertical: h1p * 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Drug Name", style: TextStyles.addDrugTxt),
                            Text('*', style: TextStyles.textStyle10b),
                          ],
                        ),
                        verticalSpace(h1p * 0.1),
                        // TextField(
                        //   textCapitalization: TextCapitalization.sentences,
                        //   onChanged: (val) {
                        //     getIt<OnlineConsultManager>().setSearchQueryValue(
                        //       val,
                        //     );
                        //   },
                        //   decoration: inputDec4(hnt: "Search"),
                        // ),

                        // verticalSpace(8),
                        // SizedBox(
                        //   child: SingleChildScrollView(
                        //     child: Column(
                        //       children: [
                        //         ...drugs
                        //             .where((element) {
                        //               // Filter based on search query and exclusion of addedItems
                        //               final matchesSearch =
                        //                   mgr.searchQuery.isEmpty ||
                        //                   (element.title != null &&
                        //                       element.title!
                        //                           .toLowerCase()
                        //                           .contains(
                        //                             mgr.searchQuery
                        //                                 .toLowerCase(),
                        //                           ));

                        //               return matchesSearch;
                        //             })
                        //             .map(
                        //               (e) => GestureDetector(
                        //                 onTap: () {
                        //                   getIt<OnlineConsultManager>()
                        //                       .setDrugName(
                        //                         BasicListItem(
                        //                           id: e.id,
                        //                           item: e.title,
                        //                         ),
                        //                       );
                        //                 },
                        //                 child: listItem(e.title ?? ""),
                        //               ),
                        //             ),
                        //         Visibility(
                        //           visible: mgr.searchQuery.trim().isNotEmpty,
                        //           child: InkWell(
                        //             onTap: () {
                        //               getIt<OnlineConsultManager>().setDrugName(
                        //                 BasicListItem(
                        //                   item: mgr.searchQuery,
                        //                   id: 12,
                        //                 ),
                        //               );
                        //             },
                        //             child: listItem(
                        //               'Create "${mgr.searchQuery}"',
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          child: DropdownSearch<BasicListItem>(
                            selectedItem: mgr.selectedDrug,
                            itemAsString: (BasicListItem u) => u.item ?? "",
                            compareFn: (item1, item2) {
                              return item1.id == item2.id;
                            },
                            
                            popupProps: PopupProps.menu(
                              menuProps: MenuProps(
                                backgroundColor: Colors.white,
                                animation: controller,
                              ),
                              showSelectedItems: false,

                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                // autofocus: true,
                                decoration: inputDec5(hnt: "Search"),
                              ),
                              // showSelectedItems: true,
                              // disabledItemFn: (String s) => s.startsWith('I'),
                            ),

                            // items: (String? filter, LoadProps? props) async {
                            //   final list = drugs
                            //       .map(
                            //         (e) =>
                            //             BasicListItem(id: e.id, item: e.title),
                            //       )
                            //       .toList();

                            //   if (filter == null || filter.isEmpty) return list;

                            //   // Optional filtering
                            //   return list
                            //       .where(
                            //         (item) => item.item!.toLowerCase().contains(
                            //           filter.toLowerCase(),
                            //         ),
                            //       )
                            //       .toList();
                            // },

                            // dropdownDecoratorProps: DropDownDecoratorProps(
                            //   dropdownSearchDecoration: inputDec5(
                            //     hnt: "Select Drug",
                            //   ),

                            // ),
                            items: drugs
                                .map(
                                  (e) => BasicListItem(id: e.id, item: e.title),
                                )
                                .toList(),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: inputDec5(hnt: ""),
                            ),

                            onChanged: (val) {
                              log(val!.item!);
                              getIt<OnlineConsultManager>().setDrugName(val);
                            },
                            // selectedItem: merchand,
                          ),
                        ),
                        verticalSpace(h1p),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final newDrug = await _showAddDrugDialog(
                                  context,
                                  drugUnits: drugUnits,
                                  drugTypes: drugtypes,
                                );
                                if (newDrug != null) {
                                  print("New Drug Added: ${newDrug.title}");
                                  getIt<OnlineConsultManager>()
                                      .addNewDrugToDrugParams(newDrug);
                                }
                              },

                              child: Text(
                                "Add New",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        verticalSpace(h1p),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Type",
                                        style: TextStyles.addDrugTxt,
                                      ),
                                      Text('*', style: TextStyles.textStyle10b),
                                    ],
                                  ),
                                  verticalSpace(h1p * 0.1),
                                  SizedBox(
                                    child: DropdownSearch<BasicListItem>(
                                      itemAsString: (BasicListItem u) =>
                                          u.item ?? "",
                                      selectedItem: BasicListItem(
                                        id: mgr.selectedDrugType?.id,
                                        item: mgr.selectedDrugType?.title,
                                      ),
                                      popupProps: PopupProps.menu(
                                        menuProps: MenuProps(
                                          backgroundColor: Colors.white,
                                          animation: controller,
                                        ),
                                        showSelectedItems: false,

                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          // autofocus: true,
                                          decoration: inputDec5(hnt: "Search"),
                                        ),
                                        // showSelectedItems: true,
                                        // disabledItemFn: (String s) => s.startsWith('I'),
                                      ),

                                      // items:
                                      //     (
                                      //       String? filter,
                                      //       LoadProps? props,
                                      //     ) async {
                                      //       final list = drugtypes
                                      //           .map(
                                      //             (e) => BasicListItem(
                                      //               id: e.id,
                                      //               item: e.item,
                                      //             ),
                                      //           )
                                      //           .toList();

                                      //       if (filter == null ||
                                      //           filter.isEmpty) {
                                      //         return list;
                                      //       }

                                      //       // Optional filtering
                                      //       return list
                                      //           .where(
                                      //             (item) => item.item!
                                      //                 .toLowerCase()
                                      //                 .contains(
                                      //                   filter.toLowerCase(),
                                      //                 ),
                                      //           )
                                      //           .toList();
                                      //     },
                                      items: drugtypes,
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                            dropdownSearchDecoration: inputDec5(
                                              hnt: "",
                                            ),
                                          ),

                                      // dropdownDecoratorProps:
                                      //     DropDownDecoratorProps(
                                      //       dropdownSearchDecoration: inputDec5(
                                      //         hnt: "",
                                      //       ),
                                      //     ),
                                      onChanged: (val) {
                                        getIt<OnlineConsultManager>()
                                            .setUpDrugType(
                                              val != null
                                                  ? Param(
                                                      title: val.item ?? "",
                                                      id: val.id,
                                                    )
                                                  : null,
                                            );
                                      },
                                      // selectedItem: merchand,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            horizontalSpace(w1p),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Unit",
                                        style: TextStyles.addDrugTxt,
                                      ),
                                      Text('*', style: TextStyles.textStyle10b),
                                    ],
                                  ),
                                  verticalSpace(h1p * 0.1),
                                  SizedBox(
                                    child: DropdownSearch<BasicListItem>(
                                      itemAsString: (BasicListItem u) =>
                                          u.item ?? "",
                                      selectedItem: BasicListItem(
                                        id: mgr.selectedDrugUnit?.id,
                                        item: mgr.selectedDrugUnit?.title,
                                      ),
                                      popupProps: PopupProps.menu(
                                        menuProps: MenuProps(
                                          backgroundColor: Colors.white,
                                          animation: controller,
                                        ),
                                        showSelectedItems: false,
                                        showSearchBox: true,
                                        searchFieldProps: TextFieldProps(
                                          // autofocus: true,
                                          decoration: inputDec5(hnt: "Search"),
                                        ),
                                        // showSelectedItems: true,
                                        // disabledItemFn: (String s) => s.startsWith('I'),
                                      ),

                                      // items:
                                      //     (
                                      //       String? filter,
                                      //       LoadProps? props,
                                      //     ) async {
                                      //       final list = drugUnits
                                      //           .map(
                                      //             (e) => BasicListItem(
                                      //               id: e.id,
                                      //               item: e.item,
                                      //             ),
                                      //           )
                                      //           .toList();

                                      //       if (filter == null ||
                                      //           filter.isEmpty) {
                                      //         return list;
                                      //       }

                                      //       // Optional filtering
                                      //       return list
                                      //           .where(
                                      //             (item) => item.item!
                                      //                 .toLowerCase()
                                      //                 .contains(
                                      //                   filter.toLowerCase(),
                                      //                 ),
                                      //           )
                                      //           .toList();
                                      //     },
                                      items: drugUnits,

                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                            dropdownSearchDecoration: inputDec5(
                                              hnt: "",
                                            ),
                                          ),
                                      // dropdownDecoratorProps:
                                      //     DropDownDecoratorProps(
                                      //       dropdownSearchDecoration: inputDec5(
                                      //         hnt: "",
                                      //       ),
                                      //     ),
                                      onChanged: (val) {
                                        getIt<OnlineConsultManager>()
                                            .setUpDrugUnit(
                                              val != null
                                                  ? Param(
                                                      title: val.item ?? "",
                                                      id: val.id,
                                                    )
                                                  : null,
                                            );
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
                        verticalSpace(h1p),
                        Text("Intervals", style: TextStyles.addDrugTxt),
                        verticalSpace(h1p * 2),
                        Row(
                          children: intervalType.map((e) {
                            var i = intervalType.indexOf(e);
                            return GestureDetector(
                              onTap: () {
                                getIt<OnlineConsultManager>().setIntervalFactor(
                                  i,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: RadioBtnItem(
                                  h1p: h1p,
                                  w1p: w1p,
                                  selected: i == mgr.selectedInterval,
                                  txt: e,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        verticalSpace(h1p * 2),
                        mgr.selectedInterval == 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  doseBox(
                                    hnt: "M",
                                    value: mgr.doseM?.title,
                                    doses: mgr.drugParams!.doses ?? dossTemp,
                                    doseTime: "M",
                                  ),
                                  doseBox(
                                    hnt: "A",
                                    value: mgr.doseA?.title,
                                    doses: mgr.drugParams!.doses ?? dossTemp,
                                    doseTime: "A",
                                  ),
                                  doseBox(
                                    hnt: "E",
                                    value: mgr.doseE?.title,
                                    doses: mgr.drugParams!.doses ?? dossTemp,
                                    doseTime: "E",
                                  ),
                                  doseBox(
                                    hnt: "N",
                                    value: mgr.doseN?.title,
                                    doses: mgr.drugParams!.doses ?? dossTemp,
                                    doseTime: "N",
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        subHead("Dosage"),
                                        SizedBox(
                                          // height: h1p * 6,
                                          child: MyTextFormField2(
                                            type: "char",
                                            cntrolr: dosageC,
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
                                        subHead("Interval"),
                                        SizedBox(
                                          // height: h1p * 6,
                                          child: MyTextFormField2(
                                            type: "char",
                                            cntrolr: intervalC,
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
                                        subHead("Interval Type"),

                                        SizedBox(
                                          // height: h1p * 6,
                                          child: DropdownSearch<String>(
                                            selectedItem:
                                                mgr.selectedIntervalType,
                                            popupProps: PopupProps.menu(
                                              menuProps: MenuProps(
                                                backgroundColor: Colors.white,
                                                animation: controller,
                                              ),
                                              showSelectedItems: false,
                                              showSearchBox: false,
                                              fit: FlexFit.loose,
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    durations.length * 48.0 +
                                                    16.0, // Dynamically calculate height
                                              ),
                                              // showSelectedItems: true,
                                              // disabledItemFn: (String s) => s.startsWith('I'),
                                            ),

                                            // items: (f, cs) =>
                                            //     intervalTypeList, // ✅ Correct in v6.0.2
                                            items: intervalTypeList,
                                            dropdownDecoratorProps:
                                                DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      inputDec5(hnt: ""),
                                                ),

                                            // dropdownDecoratorProps:
                                            //     DropDownDecoratorProps(
                                            //       dropdownSearchDecoration:
                                            //           inputDec5(hnt: ""),
                                            //     ),
                                            onChanged: (val) {
                                              getIt<OnlineConsultManager>()
                                                  .setIntervalType(val!);
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
                        verticalSpace(h1p),
                        Row(
                          children: [
                            Text("Duration", style: TextStyles.addDrugTxt),
                            Text('*', style: TextStyles.textStyle10b),
                          ],
                        ),
                        verticalSpace(h1p * 0.1),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                // height: h1p * 6,
                                child: MyTextFormField2(
                                  type: "char",
                                  cntrolr: durationC,
                                  hnt: "",
                                  isNumber: true,
                                ),
                              ),
                            ),
                            horizontalSpace(w1p * 2),

                            Expanded(
                              child: SizedBox(
                                // height: h1p * 6,
                                child: DropdownSearch<String>(
                                  selectedItem: mgr.selectedDuration,
                                  popupProps: PopupProps.menu(
                                    menuProps: MenuProps(
                                      backgroundColor: Colors.white,
                                      animation: controller,
                                    ),
                                    showSelectedItems: false,
                                    showSearchBox: false,
                                    fit: FlexFit.loose,
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          durations.length * 48.0 +
                                          16.0, // Dynamically calculate height
                                    ),
                                    // showSelectedItems: true,
                                    // disabledItemFn: (String s) => s.startsWith('I'),
                                  ),

                                  // items: (f, cs) => durations,
                                  items: durations,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                        dropdownSearchDecoration: inputDec5(
                                          hnt: "",
                                        ),
                                      ),
                                  // dropdownDecoratorProps:
                                  //     DropDownDecoratorProps(
                                  //       dropdownSearchDecoration: inputDec5(
                                  //         hnt: "",
                                  //       ),
                                  //     ),
                                  onChanged: (val) {
                                    getIt<OnlineConsultManager>()
                                        .setDurationFactor(val);
                                  },
                                  // selectedItem: merchand,
                                ),
                              ),
                            ),

                            // Row(
                            //     children: durations.map((e) {
                            //       // var i = cnts.indexOf(e);
                            //       return GestureDetector(
                            //           onTap: () {
                            //             getIt<OnlineConsultManager>().setDurationFactor(e);
                            //           },
                            //           child: RadioBtnItem(
                            //               h1p: h1p,
                            //               w1p: w1p,
                            //               selected: e == mgr.selectedDuration,
                            //               txt: e));
                            //     }).toList()),
                          ],
                        ),
                        verticalSpace(h1p),
                        Text(
                          "Special note / conditions",
                          style: TextStyles.addDrugTxt,
                        ),
                        verticalSpace(h1p * 0.1),
                        MyTextFormField2(
                          type: "char",
                          minLine: 2,
                          maxLine: 2,
                          cntrolr: noteC,
                          hnt: "",
                          isNumber: false,
                          readOnly: false,
                        ),
                        verticalSpace(h1p),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colours.btnHash,
                                  ),
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
                              child: InkWell(
                                onTap: () {
                                  // getIt<OnlineConsultManager>().addDiagnosis(selectedItems.join(", "));
                                  if (mgr.selectedDrug != null &&
                                      mgr.selectedDrugType != null &&
                                      mgr.selectedDrugUnit != null &&
                                      int.tryParse(durationC.text) != null) {
                                    try {
                                      getIt<OnlineConsultManager>().addDrug(
                                        DrugItem(
                                          fixedInterval:
                                              mgr.selectedInterval == 0
                                              ? FixedInterval(
                                                  afternoonDosage: mgr.doseA,
                                                  eveningDosage: mgr.doseE,
                                                  morningDosage: mgr.doseM,
                                                  nightDosage: mgr.doseN,
                                                  intervalType:
                                                      mgr.selectedDuration,
                                                )
                                              : null,
                                          variableInterval:
                                              mgr.selectedInterval == 1
                                              ? VariableInterval(
                                                  dosage:
                                                      double.tryParse(
                                                        dosageC.text,
                                                      ) ??
                                                      0.0,
                                                  interval:
                                                      int.tryParse(
                                                        intervalC.text,
                                                      ) ??
                                                      0,
                                                  intervalType:
                                                      mgr.selectedIntervalType,
                                                  durationType:
                                                      mgr.selectedDuration,
                                                )
                                              : null,
                                          drug: mgr.selectedDrug,
                                          drugType: mgr.selectedDrugType,
                                          drugUnit: mgr.selectedDrugUnit,
                                          instructions: noteC.text,
                                          duration:
                                              int.tryParse(durationC.text) ?? 0,
                                        ),
                                      );
                                    } catch (e, s) {
                                      if (kDebugMode) {
                                        print(s);
                                      }
                                    }
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: mgr.selectedDrug == null
                                          ? "Please add Drug Name"
                                          : mgr.selectedDrugType == null
                                          ? "Please add Drug Type"
                                          : mgr.selectedDrugUnit == null
                                          ? "Please add Drug Unit"
                                          : "Invalid duration",
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colours.primaryblue,
                                  ),
                                  child: pad(
                                    vertical: h1p,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Add",
                                      style: TextStyles.prescript3,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  listItem(String? title) {
    return ListTile(
      title: Text(title ?? "", style: TextStyles.lstItemTxt),
      style: ListTileStyle.list,
      tileColor: Colors.white,
      visualDensity: VisualDensity.comfortable,
      trailing: const Icon(Icons.add, color: Colors.black26),
    );
  }

  Future<Drug?> _showAddDrugDialog(
    BuildContext context, {
    required List<BasicListItem> drugTypes,
    required List<BasicListItem> drugUnits,
  }) async {
    final titleController = TextEditingController();
    BasicListItem? selectedType = drugTypes.first;
    BasicListItem? selectedUnit = drugUnits.first;

    return showDialog<Drug>(
      context: context,
      // barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Add New Drug",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Drug Name
                    _buildTextField(
                      controller: titleController,
                      label: "Drug Name",
                      hint: "Enter drug title",
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Drug Type Dropdown
                    _buildDropdown(
                      label: "Drug Type",
                      value: selectedType,
                      items: drugTypes,
                      onChanged: (value) =>
                          setState(() => selectedType = value),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Drug Unit Dropdown
                    _buildDropdown(
                      label: "Drug Unit",
                      value: selectedUnit,
                      items: drugUnits,
                      onChanged: (value) =>
                          setState(() => selectedUnit = value),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () {
                            if (titleController.text.trim().isEmpty ||
                                selectedType == null ||
                                selectedUnit == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all fields."),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            final drug = Drug(
                              id: DateTime.now().millisecondsSinceEpoch,
                              title: titleController.text.trim(),
                              drugTypeId: selectedType!.id,
                              drugTypeTitle: selectedType!.item,
                              drugUnitId: selectedUnit!.id,
                              drugUnitTitle: selectedUnit!.item,
                              isNew: true,
                            );

                            Navigator.pop(ctx, drug);
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// ✅ Text Field Builder (Unified Design)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.3),
        ),
      ),
    );
  }

  /// ✅ Dropdown Builder (Matching Input Style)
  Widget _buildDropdown({
    required String label,
    required BasicListItem? value,
    required List<BasicListItem> items,
    required Function(BasicListItem?) onChanged,
  }) {
    return DropdownButtonFormField<BasicListItem>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1.3),
        ),
      ),
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item.item ?? "Unknown"),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
