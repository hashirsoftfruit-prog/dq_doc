import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Colours {
  static const primaryblue = Color(0xFF585AA4);
  // static const primaryblue = const Color(0xff003B6D);
  // static const primaryblue = const Color(0xff2E3192);
  static const appointBoxClr = Color(0xffFBFBFB);
  static const btnHash = Color(0xffE9E9E9);
  static const btnHash2 = Color(0xffE8E8E8);

  // static const bluegrad = const Color(0xff5054E5);
  static const boxblue = Color(0xffD9D9D9);
  static const grad1 = Color(0xff4D51C7);
  static const lightBlu = Color(0xffF2F2F2);
  static const couponBgClr = Color(0xffF6F6F6);
  static const logoWhite = Color(0xffFFF0C7);
  static const callGreen = Color(0xff00C165);
  static const callRed = Color(0xffED1C24);
  static const grad2 = Color(0xff4044BC);
  static const toastRed = Color(0xffED1C24);
  static const toastBlue = Color(0xff252887);
}

Color get clr6C6EB8 => const Color(0xff6C6EB8);
Color get clrFE9297 => const Color(0xffFE9297);
Color get clr202020 => const Color(0xff202020);
Color get clr2D2D2D => const Color(0xff2D2D2D);
Color get clrEDEDED => const Color(0xffEDEDED);
Color get clrFFFFFF => const Color(0xffFFFFFF);
Color get clrF5F5F5 => const Color(0xffF5F5F5);
Color get clr717171 => const Color(0xff717171);
Color get clrEFEFEF => const Color(0xffEFEFEF);
Color get clr858585 => const Color(0xff858585);
Color get clr868686 => const Color(0xff868686);
Color get clrCE6F7D => const Color(0xffCE6F7D);
Color get clr5758AC => const Color(0xff5758AC);
Color get clr417FB1 => const Color(0xff417FB1);
Color get clrFA8E53 => const Color(0xffFA8E53);
Color get clrD1ECFF => const Color(0xffD1ECFF);
Color get clr5A6BE2 => const Color(0xff5A6BE2);
Color get clrFFEDEE => const Color(0xffFFEDEE);
Color get clrF8F8F8 => const Color(0xffF8F8F8);
Color get clrF3F3F3 => const Color(0xffF3F3F3);
Color get clr2E3192 => const Color(0xff2E3192);
Color get clr4346B5 => const Color(0xff4346B5);
Color get clrA8A8A8 => const Color(0xffA8A8A8);
Color get clrFF6A00 => const Color(0xffFF6A00);
Color get clr00C165 => const Color(0xff00C165);
Color get clr7261A8 => const Color(0xff7261A8);
Color get clr757575 => const Color(0xff757575);
Color get clr444444 => const Color(0xff444444);
Color get clr545454 => const Color(0xff545454);
Color get clr8467A6 => const Color(0xff8467A6);
Color get clr5D5AAB => const Color(0xff5D5AAB);
Color get clrF98E95 => const Color(0xffF98E95);
Color get clrBD6273 => const Color(0xffBD6273);
Color get clr606060 => const Color(0xff606060);
Color get clrC4C4C4 => const Color(0xffC4C4C4);
Color get clrEEEFFF => const Color(0xffEEEFFF);
Color get clrF68629 => const Color(0xffF68629);
Color get clrD9D9D9 => const Color(0xffD9D9D9);

var boxShadow1 = BoxShadow(
    color: Colours.boxblue.withOpacity(0.3),
    offset: const Offset(2, 2),
    blurRadius: 3,
    spreadRadius: 3);
var boxShadow2 =
    const BoxShadow(color: Colors.white54, blurRadius: 1, spreadRadius: 1);
var boxShadow3 = BoxShadow(
    color: Colours.grad1.withOpacity(0.2),
    offset: const Offset(2, 2),
    blurRadius: 2,
    spreadRadius: 2);
var boxShadow4 = const BoxShadow(
    color: Colors.black12,
    offset: Offset(4, 4),
    blurRadius: 5,
    spreadRadius: 4);
var boxShadow5 = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    offset: const Offset(2, 2),
    blurRadius: 2,
    spreadRadius: 2);
var boxShadow5b = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    offset: const Offset(1, 1),
    blurRadius: 2,
    spreadRadius: 2);
var boxShadow6 = const BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 4),
    blurRadius: 5,
    spreadRadius: 4);
var boxShadow7 = const BoxShadow(
    color: Colors.black12,
    offset: Offset(1, 1),
    blurRadius: 2,
    spreadRadius: 2);
var boxShadow8 = BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    offset: const Offset(1, 1),
    blurRadius: 2,
    spreadRadius: 2);
var boxShadow8b = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    offset: const Offset(-1, -1),
    blurRadius: 2,
    spreadRadius: 2);
var boxShadow9 = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    offset: const Offset(1, 1),
    blurRadius: 1.5,
    spreadRadius: 1.5);
var boxShadow9b = BoxShadow(
    color: Colors.grey.withOpacity(0.1),
    offset: const Offset(-1, -1),
    blurRadius: 1.5,
    spreadRadius: 1.5);
var boxShadow9red = BoxShadow(
    color: Colors.red.withOpacity(0.1),
    offset: const Offset(1, 1),
    blurRadius: 1.5,
    spreadRadius: 1.5);
var boxShadow10 = BoxShadow(
    offset: const Offset(0, 0),
    spreadRadius: 2,
    blurRadius: 2,
    color: clrEFEFEF);

var linearGrad2 = const LinearGradient(colors: [
  Color(0xffD9D9D9),
  Color(0xffF2F2F2),
], begin: Alignment.topCenter, end: Alignment.bottomCenter);

var linearGrad3 = const LinearGradient(colors: [
  Color(0xffE9E9E9),
  Color(0xffF9F9F9),
  Color(0xffE9E9E9),
], begin: Alignment.topCenter, end: Alignment.bottomCenter);

var linearGrad1 = const LinearGradient(colors: [
  Color(0xFF3D3F83), // Darker shade

  Colours.primaryblue,
  Color(0xFF3D3F83), // Darker shade
], begin: Alignment.bottomCenter, end: Alignment.topCenter);

Padding pad({double? horizontal, double? vertical, required Widget child}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 0, vertical: vertical ?? 0),
    child: child,
  );
}

double containerRadius = 24;

Widget myLoader(
    {required double width,
    required double height,
    required bool visibility,
    Color? color}) {
  return Visibility(
      visible: visibility,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: width,
          height: height,
          child: const Center(child: AppLoader()),
        ),
      ));
}

var radialGrad1 = const RadialGradient(
  colors: [
    Color(0xff4D51C7),
    Color(0xff2E3192),
  ],
);

var outLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      width: 1,
      color: Colours.lightBlu,
    ));
InputDecoration inputDec4({
  required String hnt,
  bool? isEmpty,
}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(left: 10),
    border: outLineBorder, enabledBorder: outLineBorder,
    focusedBorder: outLineBorder,
    filled: true, labelText: hnt, labelStyle: TextStyles.txtBox1,
    // fillColor: Colours.lightBlu,
    fillColor: Colors.transparent,

    errorStyle: const TextStyle(fontSize: 0),
  );
}

InputDecoration inputDec5({
  required String hnt,
}) {
  return InputDecoration(
    border: outLineBorder, enabledBorder: outLineBorder,
    focusedBorder: outLineBorder,
    filled: true, hintText: hnt, hintStyle: TextStyles.txtBox1b,
    // fillColor: Colours.lightBlu,
    fillColor: Colors.white,

    errorStyle: const TextStyle(fontSize: 0),
  );
}

InputDecoration inputDec6({
  required String hnt,
}) {
  return InputDecoration(
    border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colours.lightBlu)),
    enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colours.lightBlu)),
    focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colours.lightBlu)),
    filled: true, hintText: hnt, hintStyle: TextStyles.txtBox1,
    // fillColor: Colours.lightBlu,
    fillColor: Colors.white,

    errorStyle: const TextStyle(fontSize: 0),
  );
}

List<Color> gradientColors = [clr5D5AAB, clr8467A6];

class StringConstants {
  static const String type = "type";
  static const String token = "token";
  static const String userName = "userName";
  static const String proImage = "profileImage";
  static const String soundNotificationEnabled = "soundNotificationEnabled";

  // static const String baseUrl = "https://app.doctoronqueue.com/api/";

  // static const String baseUrl = "https://dq.demosoftfruit.com/api/";//live
  // static const String baseUrl = "https://practice.doctoronqueue.com/api/";//live new

  // static const String baseUrl = "http://book.demosoftfruit.com/api/";
  // static const String baseUrl = "http://doc.demosoftfruit.com/api/";

  // static const String imgBaseUrl = "https://dq.demosoftfruit.com";//live
  // static const String baseUrl = "https://dqlive.demosoftfruit.com";//live new
  static const String baseUrl = "https://dqapp.doctoronqueue.com"; //live new

  // static const String imgBaseUrl = "http://book.demosoftfruit.com";
  // static const String imgBaseUrl = "http://doc.demosoftfruit.com";

  static const String userId = "userId";
  static const String prescriptionDeclaimer =
      "This prescription is based on the information provided by you in an online consultation and not on any physical verification";
  // static const String language = "language";
  // static const String currentLatAndLong = "currentLatAndLong";
  // static const String selectedLocation = "selectedLocation";
  static const bool tempIconViewStatus = true;
}

BoxDecoration bxDec({
  double? radius,
  Color? color,
}) {
  return BoxDecoration(
    borderRadius: radius != null ? BorderRadius.circular(radius) : null,
    color: color,
  );
}

verticalSpace(double size) {
  return SizedBox(height: size);
}

horizontalSpace(double size) {
  return SizedBox(width: size);
}

EasyDayProps dayDropsStyle({required double height}) {
  return EasyDayProps(
    height: height,

    width: 70, // adjust width so 4-5 days fit nicely
    dayStructure: DayStructure.monthDayNumDayStr, // Shows: SEP | 17 | WED
    // Active day styling (blue rounded card)
    activeDayStyle: DayStyle(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [...gradientColors],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ), // gradient
        borderRadius: BorderRadius.circular(12),
      ),
      dayNumStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
      dayStrStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      monthStrStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Inactive day styling (light grey background, dark text)
    inactiveDayStyle: DayStyle(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      dayNumStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      dayStrStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
      monthStrStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    ),

    // Today styling (optional — can be same as active or highlighted differently)
    todayStyle: DayStyle(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      dayNumStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      dayStrStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      monthStrStyle: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );
}

class Borders {
  var outLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      width: 1,
      color: Colours.lightBlu,
    ),
  );
  var outLineBorder2 = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(
      width: 1,
      color: Colours.grad1,
    ),
  );
  var couponCodebrdr = const OutlineInputBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      bottomLeft: Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      width: 1,
      color: Colours.lightBlu,
    ),
  );
}


final List<String> bloodGroups = const [
  "A+",
  "A-",
  "B+",
  "B-",
  "AB+",
  "AB-",
  "O+",
  "O-"
];













//  getstyle({Color? color, required FontWeight weight,  String? fontFamily,required double size,double? height  }){
//   return   TextStyle(
//       color:  color ?? Color(0xffffffff),
//       fontWeight: weight,
//       fontFamily:fontFamily ?? "Nunito",
//       fontStyle:  FontStyle.normal,
//       fontSize: size,
//       height: height
//   );
// }


