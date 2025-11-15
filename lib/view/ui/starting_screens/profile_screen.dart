import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqueuedoc/controller/managers/auth_manager.dart';
import 'package:dqueuedoc/controller/routes/routnames.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:dqueuedoc/view/ui/starting_screens/splash_scren.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../model/core/doctor_profile_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getIt<AuthManager>().getDoctorDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DocDetailsModel? data = Provider.of<AuthManager>(context).docDetailsModel;
    bool loader = Provider.of<AuthManager>(context).logoutLoader;

    String? address1 = data?.address1 != null && data!.address1!.isNotEmpty
        ? '${data.address1 ?? ""}, '
        : null;
    String? address2 = data?.address2 != null && data!.address2!.isNotEmpty
        ? ' ${data.address2 ?? ""}, '
        : null;
    String? city = data?.city != null && data!.city!.isNotEmpty
        ? data.city ?? ""
        : null;
    String address = '${address1 ?? ""}${address2 ?? ""}${city ?? ""}';

    Widget specialityBox({
      // required double h1p,
      required double w1p,
      required String img,
      // required int index,
      required double size,
      required String title,
      // required int count,
      required Function onClick,
    }) {
      // double size = 90;
      return Container(
        height: size,
        width: w1p * 100,
        margin: const EdgeInsets.symmetric(vertical: 4),
        // height: h1p*9,
        decoration: BoxDecoration(
          boxShadow: [boxShadow10],
          borderRadius: BorderRadius.circular(containerRadius / 2),
          color: clrFFFFFF,
        ),
        child: InkWell(
          onTap: () async {
            onClick();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Align(alignment: Alignment.bottomCenter, child:
                // Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(
                //             containerRadius / 2), color: clrEFEFEF),
                //     height: 50, width: w1p*90)),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: clrEFEFEF,
                  ),
                  child: SmallWidgets().cachedImg(img, noPlaceHolder: true),
                ),

                horizontalSpace(8),
                SizedBox(height: 30, child: VerticalDivider(color: clrF3F3F3)),
                horizontalSpace(8),
                SizedBox(
                  // width: w1p*90,
                  child: Text(
                    title,
                    style: t700_14.copyWith(color: clr858585, height: 1.0),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    getSpecialityRow({
      String? icon,
      String? title,
      // String? year,
    }) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: CachedNetworkImage(
                imageUrl: '${StringConstants.baseUrl}$icon',
                errorWidget: (ss, v, t) {
                  return const SizedBox();
                },
              ),
            ),
            horizontalSpace(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // specialization!=null?Text(specialization,style: TextStyles.profile4b,):SizedBox(),
                title != null
                    ? Text(title, style: TextStyles.profile4b)
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      );
    }

    getEducationRow(String? specialization, String? college, String? year) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            specialization != null
                ? Text(
                    specialization,
                    style: t400_14.copyWith(color: clr858585, height: 1.3),
                  )
                : const SizedBox(),
            college != null
                ? Text(
                    college,
                    style: t400_14.copyWith(color: clr858585, height: 1.3),
                  )
                : const SizedBox(),
            year != null
                ? Text(
                    year,
                    style: t400_14.copyWith(color: clr858585, height: 1.3),
                  )
                : const SizedBox(),
          ],
        ),
      );
    }

    subHeading(title) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 8, left: 16),
        child: Text(title, style: TextStyles.profile5),
      );
    }

    getClinicRow(
      String? specialization,
      String? college,
      String? year,
      bool isPrimary,
    ) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isPrimary
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffF6C517),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Primary Clinic", style: TextStyles.profile6),
                    ),
                  )
                : const SizedBox(),
            specialization != null
                ? Text(
                    specialization,
                    style: t400_14.copyWith(color: clr858585, height: 1.3),
                  )
                : const SizedBox(),
            college != null
                ? Text(
                    college,
                    style: t400_14.copyWith(color: clr858585, height: 1.3),
                  )
                : const SizedBox(),
            year != null
                ? Text(
                    year,
                    style: t400_14.copyWith(color: clr858585, height: 1.3),
                  )
                : const SizedBox(),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;
        return Scaffold(
          // extendBody: true,
          backgroundColor: Colors.white,
          body: (data == null)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: h10p),
                  child: Center(child: LogoLoader()),
                )
              : SingleChildScrollView(
                  child: Column(
                    // shrinkWrap: true,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DoctorHeader(
                        maxHeight: maxHeight,
                        maxWidth: maxWidth,
                        data: data,
                      ),
                      subHeading("Address"),
                      data.education != null && data.education!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                right: w1p * 4,
                                left: w1p * 4,
                              ),
                              child: Container(
                                width: maxWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [boxShadow10],
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: w1p * 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address,
                                        style: t400_14.copyWith(
                                          color: clr858585,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      subHeading("Specialities"),
                      data.doctorSpecialities != null &&
                              data.doctorSpecialities!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                right: w1p * 4,
                                left: w1p * 4,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: data.doctorSpecialities!
                                      .map(
                                        (e) => specialityBox(
                                          w1p: w1p,
                                          size: 60,
                                          onClick: () {},
                                          title: e.title ?? '',
                                          img: e.image ?? "",
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      if (data.education != null && data.education!.isNotEmpty)
                        subHeading("Education"),
                      data.education != null && data.education!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                right: w1p * 4,
                                left: w1p * 4,
                              ),
                              child: Container(
                                width: maxWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [boxShadow10],
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: w1p * 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: data.education!
                                            .map(
                                              (e) => getEducationRow(
                                                e.specialization,
                                                e.college,
                                                e.monthYearOfCompletion,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      if (data.clinics != null && data.clinics!.isNotEmpty)
                        subHeading("Clinic Details"),
                      data.clinics != null && data.clinics!.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                left: w1p * 4,
                                right: w1p * 4,
                              ),
                              child: Container(
                                width: maxWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [boxShadow10],
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: w1p * 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: data.clinics!
                                            .map(
                                              (e) => getClinicRow(
                                                e.name,
                                                e.address1,
                                                e.address2,
                                                e.isPrimary == true,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 18,
                          right: w1p * 4,
                          left: w1p * 4,
                        ),
                        child: InkWell(
                          onTap: () async {
                            bool? result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PackageWarningPop(w1p: w1p, h1p: h1p);
                              },
                            );

                            if (result != null) {
                              await getIt<AuthManager>().logoutFn();

                              showTopSnackBar(
                                Overlay.of(context),
                                const CustomSnackBar.info(
                                  backgroundColor: Colours.primaryblue,
                                  message: "Logged out",
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SplashScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                          child: Container(
                            width: maxWidth,
                            decoration: BoxDecoration(
                              // gradient: linearGrad1,
                              border: Border.all(color: Colours.primaryblue),
                              color: Colors.white,
                              // color: Colours.primaryblue,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8,
                              ),
                              child: Center(
                                child: Text(
                                  loader ? "Logging out..." : "Logout",
                                  style: TextStyles.profile7,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(h10p),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

// Route NavigateHome() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const LandingScreen(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1.0, 0.0);
//       const end = Offset.zero;
//       final tween = Tween(begin: begin, end: end);
//       final offsetAnimation = animation.drive(tween);
//
//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//   );
// }
//
// Route NavigateLogin() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(1.0, 0.0);
//       const end = Offset.zero;
//       final tween = Tween(begin: begin, end: end);
//       final offsetAnimation = animation.drive(tween);
//
//       return SlideTransition(
//         position: offsetAnimation,
//         child: child,
//       );
//     },
//   );
// }

class DoctorHeader extends StatelessWidget {
  final double maxHeight;
  final double maxWidth;
  final DocDetailsModel data;

  // double ma
  const DoctorHeader({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    double h1p = maxHeight * 0.01;
    // double h10p = maxHeight * 0.1;
    // double w10p = maxWidth * 0.1;
    double w1p = maxWidth * 0.01;
    var grad = const LinearGradient(
      colors: [Color(0xff6C6EB8), Color(0xffFE9297)],
      begin: Alignment.bottomCenter,
      end: Alignment.topRight,
    );

    getbox(String icon, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10, child: Image.asset(icon)),
            SizedBox(width: w1p),
            SizedBox(child: Text(value, style: TextStyles.profile3)),
          ],
        ),
      );
    }

    String name =
        '${getIt<StateManager>().capitalizeFirstLetter(data.firstName ?? "")} ${getIt<StateManager>().capitalizeFirstLetter((data.lastName ?? ""))}';
    String qualification = data.qualification ?? "";
    String? experience = data.experience;
    String phoneNum = data.doctorPhone ?? "";
    String email = data.email ?? "";

    // List<Experiences> exper = data.experiences ?? [];

    // List<String> edu = eduList.map((e)=>'${e.specialization} - ${e.qualificationLevel}\n').toList();
    // String education = edu.join();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff003B6D),
        gradient: grad,
        // borderRadius: BorderRadius.only(
        //   topRight:Radius.circular(50),
        //   bottomLeft:Radius.circular(50),
        //   bottomRight:Radius.circular(50),
        //   // topLeft:Radius.circular(10),

        // ),
      ),
      // extendBody: true,
      // backgroundColor: Colors.r=tr,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: maxHeight * 0.05),
              padding: EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: w1p * 4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Text("Personal info", style: TextStyles.textStyle12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteNames.settings);
                    },
                    child: SvgPicture.asset(
                      "assets/icons/settings-icon.svg",
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: w1p * 25,
                    width: w1p * 25,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '${StringConstants.baseUrl}${data.image}',
                      placeholder: (context, url) =>
                          Image.asset("assets/images/doctor-placeholder.jpg"),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/doctor-placeholder.jpg"),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(h1p * 2),
            Text(name, style: TextStyles.profile1),
            verticalSpace(h1p * 0.5),

            Text(qualification, style: TextStyles.profile2),
            verticalSpace(h1p * 2),

            // SizedBox(height:30,child: VerticalDivider()),
            experience != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(experience, style: TextStyles.textStyle3b),
                          horizontalSpace(w1p),
                          Text("Experience", style: TextStyles.textStyle3b),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            verticalSpace(h1p),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      data.doctorPhone != null
                          ? getbox("assets/images/icon-phone.png", phoneNum)
                          : const SizedBox(),
                      horizontalSpace(data.email != null ? 8 : 0),
                      data.email != null
                          ? getbox("assets/images/icon-email.png", email)
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            // data.clinicName!=null?detailsRow(icon: 'assets/images/icon-location.png',value: data.clinicName!) :SizedBox(),
            //
            // address.trim().isNotEmpty?detailsRow(icon: 'assets/images/icon-location.png',value: address):SizedBox(),
            verticalSpace(18.0),
          ],
        ),
      ),
    );
  }
}

class PackageWarningPop extends StatelessWidget {
  final double w1p;
  final double h1p;
  // String msg;  // String type;
  // String? offlineTimeSlot;
  // String currentClinicAddress;
  // Function bookOnlineOnClick;
  // Function bookClinicOnClick;
  const PackageWarningPop({
    super.key,
    required this.w1p,
    required this.h1p,
    // required this.msg,
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
    String msg = 'Are you sure you want to logout?';

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Logout', style: TextStyles.textStyle3),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SizedBox(
          width: w1p * 90,
          child: Column(mainAxisSize: MainAxisSize.min, children: [Text(msg)]),

          // height: h1p*80,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colours.primaryblue),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text("Cancel", style: TextStyles.profile2b),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: linearGrad1,
          ),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28.0,
                vertical: 5,
              ),
              child: Text("Logout", style: TextStyles.profile2),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 18.0),
      contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    );
  }
}
