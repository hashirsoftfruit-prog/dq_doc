import 'package:dqueuedoc/view/theme/text_styles.dart';

import 'package:dqueuedoc/model/core/basic_response_model.dart';
import 'package:dqueuedoc/view/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

// class TextFieldPop extends StatelessWidget {
//
// String? value;
//   Function(String val) fn;
//   TextFieldPop({ required this.fn,required this.value});
//
//
//
//   @override
//   Widget build(BuildContext context) {
// var txtCntrlr = TextEditingController(text: value??"");
//
//     return          Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             Expanded(child: SizedBox(height: 50,child:
//               TextFormField(controller: txtCntrlr,
//                 autofocus: true,
//                 decoration: inputDec2( hnt: "sds",),),)),
//
//             InkWell(onTap: (){
//               fn(txtCntrlr.text);
//
//             Navigator.pop(context);
//
//             },
//               child: Container(child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 18,vertical: 1),
//                 child: Text("Done",style: TextStyles.textStyle5,),
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//
//   }
// }

class ScrollPopUp extends StatefulWidget {
  final List<BasicListItem> lst;
  final int itemIndex;
  final String? measur;
  final Function(BasicListItem val) fn;
  const ScrollPopUp({
    super.key,
    required this.itemIndex,
    this.measur,
    required this.lst,
    required this.fn,
  });

  @override
  State<ScrollPopUp> createState() => _ScrollPopUpState();
}

class _ScrollPopUpState extends State<ScrollPopUp> {
  BasicListItem? selected;

  @override
  Widget build(BuildContext context) {
    String ext = widget.measur ?? "";
    // var lst =["Male","Female","Other"];
    final secondsWheel = WheelPickerController(
      itemCount: widget.lst.length,
      initialIndex: widget.itemIndex,
    );
    const textStyle = TextStyle(fontSize: 18.0, height: 1.5);

    // Timer.periodic(const Duration(seconds: 1), (_) => secondsWheel.shiftDown());

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: WheelPicker(
            builder: (context, index) => Text(
              '${widget.lst[index].item} $ext',
              style: TextStyles.scrollWheelUnSelected,
            ),
            controller: secondsWheel,
            selectedIndexColor: Colours.primaryblue,
            looping: false,
            onIndexChanged: (index, _) {
              setState(() {
                selected = widget.lst[index];
              });
            },
            style: WheelPickerStyle(
              // height: 300,
              itemExtent:
                  TextStyles.scrollWheelUnSelected.fontSize! *
                  textStyle.height!, // Text height
              squeeze: 1.25,
              diameterRatio: .8,
              surroundingOpacity: .50,
              magnification: 1.2,
            ),
          ),
        ),
        Positioned(
          right: 8,
          child: InkWell(
            onTap: () {
              if (selected != null) {
                widget.fn(selected!);
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
              child: Text("Done", style: TextStyles.textStyle5),
            ),
          ),
        ),
      ],
    );
  }
}

class ScrollPopUpWith2Value extends StatefulWidget {
  final List<String> lst;
  final List<String> lst2;
  final int itemIndex;
  final int itemIndex2;
  final String? measur;
  final Function(String val) fn;
  const ScrollPopUpWith2Value({
    super.key,
    required this.itemIndex,
    required this.itemIndex2,
    this.measur,
    required this.lst,
    required this.lst2,
    required this.fn,
  });

  @override
  State<ScrollPopUpWith2Value> createState() => _ScrollPopUp2State();
}

class _ScrollPopUp2State extends State<ScrollPopUpWith2Value> {
  String? selectedFirstValue;
  String? selectedSecnd2;

  @override
  Widget build(BuildContext context) {
    String ext = widget.measur ?? "";
    // var lst =["Male","Female","Other"];
    final wheelControllr = WheelPickerController(
      itemCount: widget.lst.length,
      initialIndex: widget.itemIndex,
    );
    final wheelControllr2 = WheelPickerController(
      itemCount: widget.lst2.length,
      initialIndex: widget.itemIndex2,
    );
    const textStyle = TextStyle(fontSize: 18.0, height: 1.5);

    // Timer.periodic(const Duration(seconds: 1), (_) => secondsWheel.shiftDown());

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                // width: double.infinity,
                child: WheelPicker(
                  builder: (context, index) => Text(
                    '${widget.lst[index]} $ext',
                    style: TextStyles.scrollWheelUnSelected,
                  ),
                  controller: wheelControllr,
                  selectedIndexColor: Colours.primaryblue,
                  looping: false,
                  onIndexChanged: (index, _) {
                    setState(() {
                      selectedFirstValue = widget.lst[index];
                    });
                  },
                  style: WheelPickerStyle(
                    // height: 300,
                    itemExtent:
                        TextStyles.scrollWheelUnSelected.fontSize! *
                        textStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                // width: double.infinity,
                child: WheelPicker(
                  builder: (context, index) => Text(
                    '${widget.lst2[index]} $ext',
                    style: TextStyles.scrollWheelUnSelected,
                  ),
                  controller: wheelControllr2,
                  selectedIndexColor: Colours.primaryblue,
                  looping: false,
                  onIndexChanged: (index, _) {
                    setState(() {
                      selectedSecnd2 = widget.lst2[index];
                    });
                  },
                  style: WheelPickerStyle(
                    // height: 300,
                    itemExtent:
                        TextStyles.scrollWheelUnSelected.fontSize! *
                        textStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 8,
          child: InkWell(
            onTap: () {
              if (selectedFirstValue != null || selectedSecnd2 != null) {
                widget.fn(
                  '${selectedFirstValue ?? widget.lst[widget.itemIndex]}/${selectedSecnd2 ?? widget.lst2[widget.itemIndex2]}',
                );
              }
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 1),
              child: Text("Done", style: TextStyles.textStyle5),
            ),
          ),
        ),
      ],
    );
  }
}
