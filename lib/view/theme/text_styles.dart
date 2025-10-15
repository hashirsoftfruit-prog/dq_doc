import 'package:flutter/material.dart';

TextStyle get t400_14 => getstyle(weight: FontWeight.w400, size: 14.0);
TextStyle get t400_16 => getstyle(weight: FontWeight.w400, size: 16.0);
TextStyle get t400_18 => getstyle(weight: FontWeight.w400, size: 18.0);
TextStyle get t400_12 => getstyle(weight: FontWeight.w400, size: 12.0);
TextStyle get t400_10 => getstyle(weight: FontWeight.w400, size: 10.0);
TextStyle get t400_8 => getstyle(weight: FontWeight.w400, size: 8.0);
TextStyle get t400_20 => getstyle(weight: FontWeight.w400, size: 20.0);
TextStyle get t400_22 => getstyle(weight: FontWeight.w400, size: 22.0);

TextStyle get t700_14 => getstyle(weight: FontWeight.w700, size: 14.0);
TextStyle get t700_16 => getstyle(weight: FontWeight.w700, size: 16.0);
TextStyle get t700_18 => getstyle(weight: FontWeight.w700, size: 18.0);
TextStyle get t700_12 => getstyle(weight: FontWeight.w700, size: 12.0);
TextStyle get t700_10 => getstyle(weight: FontWeight.w700, size: 10.0);
TextStyle get t700_22 => getstyle(weight: FontWeight.w700, size: 22.0);
TextStyle get t700_30 => getstyle(weight: FontWeight.w700, size: 30.0);
TextStyle get t700_20 => getstyle(weight: FontWeight.w700, size: 20.0);
TextStyle get t700_24 => getstyle(weight: FontWeight.w700, size: 24.0);
TextStyle get t700_42 => getstyle(weight: FontWeight.w700, size: 42.0);

TextStyle get t500_13 => getstyle(
      weight: FontWeight.w500,
      size: 12.5,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_14 => getstyle(
      weight: FontWeight.w500,
      size: 14.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_16 => getstyle(
      weight: FontWeight.w500,
      size: 16.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_18 => getstyle(
      weight: FontWeight.w500,
      size: 18.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_12 => getstyle(
      weight: FontWeight.w500,
      size: 12.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_10 => getstyle(
      weight: FontWeight.w500,
      size: 10.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_20 => getstyle(
      weight: FontWeight.w500,
      size: 20.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_22 => getstyle(
      weight: FontWeight.w500,
      size: 22.0,
      fontFamily: "Product Sans Medium",
    );
TextStyle get t500_24 => getstyle(
      weight: FontWeight.w500,
      size: 24.0,
      fontFamily: "Product Sans Medium",
    );

getstyle(
    {Color? color,
    required FontWeight weight,
    String? fontFamily,
    required double size,
    double? height}) {
  return TextStyle(
      color: color ?? const Color(0xffffffff),
      fontWeight: weight,
      fontFamily: fontFamily ?? "Product Sans", //"Product Sans",
      fontStyle: FontStyle.normal,
      fontSize: size,
      height: height);
}

class TextStyles {
  static String fontFam = "Nunito";

  static const textStyleeee = TextStyle(
      color: Color(0xff00A76B),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
      height: 1);
  static final textStyleqweq = TextStyle(
    color: const Color(0xffffffff),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 18.0,
  );
  static final textStyledoc1 = TextStyle(
      color: const Color(0xff444444),
      fontWeight: FontWeight.w700,
      fontFamily: fontFam,
      fontStyle: FontStyle.normal,
      fontSize: 14.0,
      height: 1);
  static const textStyledoc2 = TextStyle(
      color: Color(0xff444444),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
      height: 1);
  static const textStyle22 = TextStyle(
      color: Color(0xff2E3192),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 12.0,
      height: 1);
  static const scrollWheelUnSelected = TextStyle(
      color: Color(0xff444444),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 16.0);
  static const scrollWheelSelected = TextStyle(
      color: Color(0xff444444),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 16.0);
  static const textStyle50 = TextStyle(
      color: Color(0xffeb1b24),
      fontWeight: FontWeight.w400,
      fontFamily: "Marvel",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);
  static const textStyle50b = TextStyle(
      color: Color(0xffffffff),
      fontWeight: FontWeight.w400,
      fontFamily: "Marvel",
      fontStyle: FontStyle.normal,
      fontSize: 8.0);
  static const textStyle50c = TextStyle(
      color: Colors.black26,
      fontWeight: FontWeight.w400,
      fontFamily: "Marvel",
      fontStyle: FontStyle.normal,
      fontSize: 10.0);
  static const textStyle = TextStyle(
      color: Color(0xffffffff),
      fontWeight: FontWeight.w700,
      fontFamily: "NunitoSans",
      fontStyle: FontStyle.normal,
      fontSize: 40.0,
      height: 1);
  static const textStyleb = TextStyle(
      color: Color(0x9B474747),
      fontWeight: FontWeight.w700,
      fontFamily: "NunitoSans",
      fontStyle: FontStyle.normal,
      fontSize: 40.0,
      height: 1);
  static const loginUp = TextStyle(
      color: Color(0x9B474747),
      fontWeight: FontWeight.w400,
      fontFamily: "Nunito",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);
  static const login2 = TextStyle(
      color: Color(0xff444444),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 14.0);
  static final billTxt1 = TextStyle(
    color: const Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 15.0,
  );
  static const billTxt2 = TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
  );
  static const billTxt3 = TextStyle(
    color: Color(0xff000000),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
  );
  static const billTxt4 = TextStyle(
    color: Color(0xff00c165),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 14.0,
  );
  static final billTxt5 = TextStyle(
    color: const Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 15.0,
  );
  static final billTxt6 = TextStyle(
    color: const Color(0xff000000),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );

  static final textStyle3c = TextStyle(
    color: const Color(0xff444444),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );
  static const textStyle56b = TextStyle(
    color: Color(0xffffffff),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 18.0,
  );
  static const textStyle3f = TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );
  static const textStyle3g = TextStyle(
    color: Color(0xffffffff),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );

  static const textStyle23d2 = TextStyle(
    color: Color(0xff444444),
    fontWeight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    fontStyle: FontStyle.normal,
    fontSize: 12.0,
  );
  static final textStyle42 = TextStyle(
    color: const Color(0xffffffff),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 16.0,
  );
  static const textStyle34 = TextStyle(
      color: Color(0xff818181),
      fontWeight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      fontStyle: FontStyle.normal,
      fontSize: 18.0,
      height: 1.5);
  static const textStyleAnatomy3 = TextStyle(
      color: Color(0xff444444),
      fontWeight: FontWeight.w700,
      fontFamily: "NunitoSans",
      fontStyle: FontStyle.normal,
      fontSize: 20.0);
  static const textStyleAnatomy2 = TextStyle(
    color: Color(0xffEB0000),
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    fontStyle: FontStyle.normal,
    fontSize: 12,
  );
  static final textStyleAnatomy1 = TextStyle(
    color: const Color(0xffffffff),
    fontWeight: FontWeight.w700,
    fontFamily: fontFam,
    fontStyle: FontStyle.normal,
    fontSize: 2.5,
  );
  static final textStyle2 = getstyle(
      weight: FontWeight.w400, size: 12.0, color: const Color(0xff474747));
  static final textStyle3 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff2E3192));
  static final textStyle7c = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xffffffff));
  static final textStyle7d = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff444444));
  static final textStyle7b = getstyle(
      weight: FontWeight.w700, size: 16.0, color: const Color(0xffFFE455));
  static final textStyle3b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff2E3192));
  static final textStyle4 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xffffffff));
  static final textStyle5 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff444444));
  static final prescript1 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff2E3192));
  static final prescript2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff444444));
  static final prescript3 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xffffffff));
  static final prescript3c = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff444444));
  static final prescript3b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff444444));
  static final prescript5 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff2E3192));
  static final txtBox1 = getstyle(
      weight: FontWeight.w400, size: 14.0, color: const Color(0xff474747));
  static final txtBox1b = getstyle(
      weight: FontWeight.w400, size: 14.0, color: const Color(0x8C474747));
  static final txtBox2 = getstyle(
    weight: FontWeight.w400,
    size: 14.0,
    color: const Color(0xff444444),
  );
  static final prescript4 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 18.0,
      color: const Color(0xff2E3192));
  static final addDrugTxt = getstyle(
      weight: FontWeight.w400, size: 14.0, color: const Color(0xff474747));
  static final addDrugTxt4 = getstyle(
      weight: FontWeight.w400, size: 16.0, color: const Color(0x6B474747));
  static final addDrugTxt2 = getstyle(
      weight: FontWeight.w400, size: 16.0, color: const Color(0xff444444));
  static final addDrugTxt3 = getstyle(
      weight: FontWeight.w400, size: 14.0, color: const Color(0xff444444));
  static final prescript6 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff000000));
  static final prescript7 = getstyle(
      weight: FontWeight.w400, size: 16.0, color: const Color(0xff474747));
  static final prescript7b = getstyle(
      weight: FontWeight.w400, size: 14.0, color: const Color(0xffffffff));
  static final drugDet1 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff2E3192));
  static final drugDet2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff474747));
  static final drugDet3 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0x93474747));
  static final textStyle6 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0x93444444));
  static final textStyle7 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xffffffff));
  static final textStyle8 = getstyle(
      weight: FontWeight.w700,
      size: 14.0,
      color: const Color(0xff444444),
      height: 1);
  static final textStyle8b = getstyle(
      weight: FontWeight.w700, size: 16.0, color: const Color(0xffffffff));
  static final textStyle9 = getstyle(
      weight: FontWeight.w400, size: 12.0, color: const Color(0xff444444));
  static final textStyle9b = getstyle(
      weight: FontWeight.w400, size: 12.0, color: const Color(0xff2E3192));
  static final textStyle10 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff444444));
  static final textStyle10b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: Colors.red);
  static final textStyle10b2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0,
      color: const Color(0xff2E3192));
  static final textStyle11 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff00C165));
  static final textStyle11b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 10.0,
      color: const Color(0xff00C165));
  static final calnderDayNum = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 8.0,
      color: const Color(0xff444444));
  static final calnderDayNum2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 8.0,
      color: const Color(0xffffffff));
  static final lstItemTxt = getstyle(
      weight: FontWeight.w400, size: 14.0, color: const Color(0xff474747));
  static final lstItemTxt2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff444444));
  static final donebtn = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff474747));
  static final graphLabelStyle = getstyle(
      weight: FontWeight.w400, size: 9.0, color: const Color(0xff444444));
  static final graphtitle = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 16.0,
      color: const Color(0xff444444));
  static final graphtxt = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 22.0,
      color: const Color(0xff000000));
  static final graphtxt2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 9.0,
      color: const Color(0xff444444));
  static final dateTxt = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xffffffff));
  static final analyticsTxt = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff444444));
  static final analyticsTxt2 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff000000));
  static final textStyle12 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xffffffff));
  static final textStyle12c = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 15.0,
      color: const Color(0xffffffff));
  static final textStyle12b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xffed1c24));
  static final textStyle13 = getstyle(
      weight: FontWeight.w700, size: 30.0, color: const Color(0xffFFE455));
  static final textStyle14 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0,
      color: const Color(0xffFFffff));
  static final textStyle17 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 8.0,
      color: const Color(0xffFFffff));
  static final textStyle15 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff444444));
  static final textStyle15c = getstyle(
      weight: FontWeight.w400, size: 13.0, color: const Color(0xff5B5B5B));
  static final textStyle15b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 14.0,
      color: const Color(0xff2E3192));
  static final textStyle16 = getstyle(
      weight: FontWeight.w400, size: 13.0, color: const Color(0xff444444));

  static final presPreviewtxt1 = getstyle(
      weight: FontWeight.w400, size: 12.0 - 6, color: const Color(0xff444444));
  static final presPreviewtxt2 = getstyle(
      weight: FontWeight.w400, size: 13.0 - 6, color: const Color(0xffDEDEDE));
  static final presPreviewtxt3 = getstyle(
      weight: FontWeight.w400, size: 12.0 - 6, color: const Color(0xffDEDEDE));
  static final presPreviewtxt4 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0 - 6,
      color: const Color(0xff444444));
  static final presPreviewtxt4b = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0 - 6,
      color: const Color(0xff5B5B5B));
  static final presPreviewtxt5 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0 - 6,
      color: const Color(0xff444444),
      height: 1);
  static final presPreviewtxt6 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0 - 6,
      color: const Color(0xffffffff));
  static final presPreviewtxt7 = getstyle(
      weight: FontWeight.w400,
      size: 12.0 - 6,
      color: const Color(0xff474747),
      height: 1);
  static final presPreviewtxt8 = getstyle(
      weight: FontWeight.w400,
      size: 12.0 - 6,
      color: const Color(0xcb474747),
      height: 1);
  static final presPreviewtxt9 = getstyle(
      weight: FontWeight.w500,
      fontFamily: "Product Sans Medium",
      size: 12.0 - 6,
      color: const Color(0xff000000));
  static final presPreviewtxt10 = getstyle(
      weight: FontWeight.w500, size: 13.0 - 6, color: const Color(0xffffffff));
  static final presPreviewtxt11 = getstyle(
      weight: FontWeight.w400,
      size: 12.0 - 6,
      color: const Color(0xffffffff),
      height: 1);
  static final presPreviewtxt12 = getstyle(
      weight: FontWeight.w400,
      size: 12.0 - 6,
      color: const Color(0xff444444),
      height: 1.2);

  static final btNavTxt = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 9.0,
    color: const Color(0xff2E3192),
  );
  static final btNavTxt2 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 9.0,
    color: const Color(0xff5B5B5B),
  );
  static final profile1 = getstyle(
    weight: FontWeight.w700,
    size: 16.0,
    color: const Color(0xffffffff),
  );
  static final profile2 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xffffffff),
  );
  static final profile2b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff2E3192),
  );
  static final profile3 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 13.0,
    color: const Color(0xffffffff),
  );
  static final profile4 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff444444),
  );
  static final profile4b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff585858),
  );
  static final profile5 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff003B6D),
  );
  static final profile6 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xffffffff),
  );
  static final profile7 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 16.0,
    color: const Color(0xff2E3192),
  );

  static final notif1 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff444444),
  );
  static final notif2 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xff787878),
  );

  static final consult1 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 13.0,
    color: const Color(0xff444444),
  );
  static final consult1b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff444444),
  );
  static final consult2 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xff2E3192),
  );
  static final consult3 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 18.0,
    color: const Color(0xffffffff),
  );
  static final consult4 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 10.0,
    color: const Color(0xff444444),
  );

  static final pDetails1 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 16.0,
    color: const Color(0xff545454),
  );
  static final pDetails1b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 16.0,
    color: const Color(0xdf2E3192),
  );
  static final pDetails2 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff28318C),
  );
  static final pDetails2b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xff575757),
  );
  static final pDetails3 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff545454),
  );
  static final pDetails3b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff444444),
  );
  static final pDetails4 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xdf545454),
  );

  static final forumtxt1 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 16.0,
    color: const Color(0xdf2E3192),
  );
  static final forumtxt2 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xdf444444),
  );
  static final forumtxt3 = getstyle(
    weight: FontWeight.w400,
    size: 12.0,
    color: const Color(0xdf868686),
  );
  static final forumtxt4 = getstyle(
    weight: FontWeight.w400,
    size: 12.0,
    color: const Color(0xdf444444),
  );
  static final forumtxt5 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 14.0,
    color: const Color(0xff444444),
  );
  static final forumtxt6 = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xdf444444),
  );
  static final forumtxt6c = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xdf868686),
  );
  static final forumtxt6b = getstyle(
    weight: FontWeight.w500,
    fontFamily: "Product Sans Medium",
    size: 12.0,
    color: const Color(0xdf444444),
  );
  static final forumtxt7 = getstyle(
    weight: FontWeight.w400,
    size: 12.0,
    color: const Color(0xdf2E2E2E),
  );
  static final forumtxt8 = getstyle(
    weight: FontWeight.w400,
    size: 14.0,
    color: const Color(0xff2d2d2d),
  );
  static final forumtxt9 = getstyle(
    weight: FontWeight.w400,
    size: 13.0,
    color: const Color(0xff444444),
  );

  static final textStyle84b = getstyle(
      weight: FontWeight.w400, size: 12.0, color: const Color(0xff868686));
  static final textStyle85 = getstyle(
      weight: FontWeight.w700, size: 12.0, color: const Color(0xff4447B7));
  static const textStyle11d = TextStyle(
    color: Color(0xffEB0000),
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    fontStyle: FontStyle.normal,
    fontSize: 14,
  );
}
