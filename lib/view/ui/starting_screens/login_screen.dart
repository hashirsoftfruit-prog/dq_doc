import 'dart:developer';

import 'package:dqueuedoc/view/theme/text_styles.dart';

import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/managers/auth_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import 'landing_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  // late Animation<Offset> docAnimation;
  // late Animation<Offset> btnAnimation;
  // late final AnimationController _pageAnimation;
  var userNameCntr = TextEditingController();
  var pwdCntr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool? showIcon = StringConstants.tempIconViewStatus;

    // var usrnameFocus = FocusNode();

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        loginFn() async {
          String uname = userNameCntr.text.trim();
          String pass = pwdCntr.text.trim();

          // String uname = "irinashraf";
          // String pass = "123456";

          var result = await getIt<AuthManager>().userLogin(
            usrName: uname,
            pass: pass,
          );
          log(result.toJson().toString());
          if (result.status == true && result.userId != null) {
            getIt<AuthManager>().saveUserId(result.userId!);
            getIt<AuthManager>().saveToken(result.token!);
            getIt<AuthManager>().saveUserName(result.username!);
            await getIt<AuthManager>().saveFcmApi();

            Fluttertoast.showToast(
              gravity: ToastGravity.CENTER,
              msg: result.message ?? "",
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LandingScreen()),
            );
          } else {
            // Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen()));

            // userNameCntr.clear();
            pwdCntr.clear();

            Fluttertoast.showToast(
              gravity: ToastGravity.CENTER,
              msg: result.message ?? "",
              backgroundColor: Colors.white,
              textColor: Colours.callRed,
            );
          }
        }

        return ProgressHUD(
          indicatorColor: Colours.primaryblue,
          backgroundColor: Colours.primaryblue.withOpacity(0.1),
          padding: const EdgeInsets.all(24),
          child: Builder(
            builder: (context) {
              final progress = ProgressHUD.of(context);

              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: Colors.white,
                  body: Entry(
                    xOffset: 200,
                    // opacity: .5,
                    // angle: 3.1415,
                    delay: const Duration(milliseconds: 100),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.decelerate,

                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w1p * 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: h10p * 1.2,
                              height: h10p * 1.2,
                              decoration: BoxDecoration(
                                color:
                                    MediaQuery.of(context).viewInsets.bottom ==
                                        0.0
                                    ? Colors.transparent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(w1p * 3),
                                child: showIcon
                                    ? SvgPicture.asset(
                                        "assets/images/appicon.svg",
                                      )
                                    : Image.asset(
                                        'assets/images/temp-app-icon.png',
                                      ),
                              ),
                            ),

                            verticalSpace(h10p * 0.8),

                            // Transform.translate(
                            //   offset: docAnimation.value,
                            //   child: TextField(textInputAction: TextInputAction.next,
                            //     decoration: InputDecoration(hintText: "Username",hintStyle:TextStyles.loginUp),
                            //     controller: userNameCntr,
                            //
                            //
                            //
                            //   ),
                            // ),
                            //
                            // verticalSpace( h1p*2),
                            //
                            //
                            //
                            // Transform.translate(
                            //   offset: docAnimation.value,
                            //   child: Consumer<StateManager>(
                            //       builder: (context,mngr,child) {
                            //         return TextField(onSubmitted: (val)async{
                            //
                            //           progress?.show();
                            //
                            //           await loginFn();
                            //
                            //           progress?.dismiss();
                            //
                            //
                            //
                            //
                            //
                            //         },obscureText: !mngr.showPass,
                            //
                            //           decoration: InputDecoration(hintText: "Password",hintStyle:TextStyles.loginUp,
                            //               suffixIcon: GestureDetector(
                            //                   onTap: (){
                            //                     getIt<StateManager>().showPwd(!mngr.showPass);
                            //                   },
                            //                   child: SizedBox(child:mngr.showPass?Icon(Icons.visibility_outlined,color: Color(0xff999999),):Icon(Icons.visibility_off_outlined,color: Color(0xff999999),)))),
                            //
                            //           controller: pwdCntr,
                            //
                            //         );
                            //       }
                            //   ),
                            // ),
                            //
                            //
                            //
                            // // Expanded(child: SizedBox()),
                            //
                            // verticalSpace( h10p*0.8,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    spreadRadius: 1.5,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                style: TextStyles.login2,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter your username";
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                                cursorColor: Colours.primaryblue.withOpacity(
                                  0.5,
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Username",
                                  hintStyle: TextStyles.loginUp,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                ),
                                controller: userNameCntr,
                              ),
                            ),

                            verticalSpace(h1p * 2),

                            Consumer<StateManager>(
                              builder: (context, mngr, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        spreadRadius: 1.5,
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: TextFormField(
                                            style: TextStyles.login2,
                                            onChanged: (val) async {
                                              progress?.show();

                                              // await loginFn();

                                              progress?.dismiss();
                                            },
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Enter your password";
                                              }
                                              return null;
                                            },
                                            obscureText: mngr.showPass,
                                            cursorColor: Colours.primaryblue
                                                .withOpacity(0.5),
                                            decoration: const InputDecoration(
                                              hintText: "Password",
                                              hintStyle: TextStyles.loginUp,
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 18,
                                                    vertical: 8,
                                                  ),
                                            ),
                                            controller: pwdCntr,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          getIt<StateManager>().showPwd(
                                            !mngr.showPass,
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            child: mngr.showPass
                                                ? const Icon(
                                                    Icons.visibility_outlined,
                                                    color: Color(0xff999999),
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .visibility_off_outlined,
                                                    color: Color(0xff999999),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            verticalSpace(h1p * 6),

                            InkWell(
                              onTap: () async {
                                progress?.show();

                                // bool result = await InternetConnection().hasInternetAccess;

                                if (formKey.currentState!.validate()) {
                                  await loginFn();
                                }
                                progress?.dismiss();
                              },
                              child: Container(
                                // height: h1p*3,
                                //
                                // width: w10p*2,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    // focalRadius: 10,
                                    colors: [
                                      Colours.grad2,
                                      Colours.primaryblue,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                // height: h1p*3,
                                //
                                // width: w10p*2,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Login",
                                      style: TextStyles.textStyle8b,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            verticalSpace(12),
                            TextButton(
                              onPressed: () async {
                                final Uri url = Uri.parse(
                                  'https://dqapp.doctoronqueue.com/registration',
                                );
                                if (!await launchUrl(url)) {
                                  throw Exception('Could not launch $url');
                                }
                              },
                              child: Text(
                                "Are you a practising doctor? Register here.",
                                style: t400_14.copyWith(
                                  color: Colours.primaryblue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        // title: SvgPicture.asset("assets/images/appicon.svg"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SvgPicture.asset(
                "assets/images/no-internet.svg",
                height: 50,
              ),
            ),
            const Text(
              "Please check your internet connection and try again.",
              style: TextStyles.textStyle3f,
              textAlign: TextAlign.center,
            ),
            verticalSpace(8),
            TextButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        ),
        // actions: <Widget>[
        //   TextButton(
        //     child: Text("OK"),
        //     onPressed: () {
        //       Navigator.of(context).pop(); // Dismiss the dialog
        //     },
        //   ),
        // ],
      );
    },
  );
}
