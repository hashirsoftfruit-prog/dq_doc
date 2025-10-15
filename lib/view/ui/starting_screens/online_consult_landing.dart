//
// import 'package:dqueuedoc/view/ui/chat_screen.dart';
// import 'package:dqueuedoc/view/ui/starting_screens/priscription_screen.dart';
// import 'package:floating_draggable_widget/floating_draggable_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../controller/managers/online_consult_manager.dart';
// import '../../../controller/managers/state_manager.dart';
// import '../../../model/core/accept_request_response_model.dart';
// import '../../../model/helper/service_locator.dart';
// import '../../theme/constants.dart';
// import '../zoom_screens/call_screen.dart';
//
//
//
//
//
//
//
// class OnlineConsultLanding extends StatefulWidget {
//   String appoinmentId;
//   int bookingId;
//   bool? directToCall;
//   bool? isFromCall;
//    OnlineConsultLanding({
//     required this.bookingId,
//     required this.appoinmentId,
//     this.directToCall,
//     this.isFromCall,
//
//   });
//
//   @override
//   State<OnlineConsultLanding> createState() => _nNlineConsultLandingState();
// }
//
// class _nNlineConsultLandingState extends State<OnlineConsultLanding> {
//
// @override
//   void initState() {
//     // TODO: implement initState
//     _navigateToCall();
//     super.initState();
//
// }
// @override
//   void dispose() {
//   // getIt<OnlineConsultManager>().disposePriscrip();
//   // getIt<StateManager>().disposePriscrip();
//   getIt<StateManager>().disposeConsultLanding();
//   getIt<OnlineConsultManager>().disposePriscrip();
//   getIt<OnlineConsultManager>().disposeChat();
//
//
//   super.dispose();
//
// }
//
//
// _navigateToCall()async{
//   await Future.delayed(Duration(milliseconds: 100));
//
//   if(widget.directToCall==true){
//     Navigator.push(context,MaterialPageRoute(builder: (_)=>CallScreen(
//         bookingId: widget.bookingId,
//
//         displayName: getIt<SharedPreferences>().getString(StringConstants.userName)??"Unknown",
//         role: "0",isJoin: true,sessionIdleTimeoutMins: "1",sessionName: widget.appoinmentId,sessionPwd: 'Qwerty123')));
//
//   }
// }
//
//
// PageController pgCntroller = PageController();
//   @override
//   Widget build(BuildContext context) {
//     bool isShowChat = Provider.of<StateManager>(context).isShowChat;
//     var bxDec = BoxDecoration(shape: BoxShape.circle,color: Colours.primaryblue);
//
//     // int selectedIndex = 0;
//     DateTime? currentBackPressTime;
//
//     // Future<bool> onWillPop() {
//     //   DateTime now = DateTime.now();
//     //   if (currentBackPressTime == null ||
//     //     now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
//     //     currentBackPressTime = now;
//     //     try {
//     //       if(navIndex==2){
//     //         Fluttertoast.showToast(msg: "Press back again to exit");
//     //
//     //       }else{
//     //         // getIt<StateManager>().updateHomeIndex(2);
//     //
//     //       }
//     //     } catch (e) {
//     //       // debugPrint(e.toString());
//     //     }
//     //
//     //     return Future.value(false) ;
//     //   }else{
//     //     return Future.value(true);
//     //   }
//     //
//     // }
//     return   LayoutBuilder(builder: (context, constraints)
//     {
//       double maxHeight = constraints.maxHeight;
//       double maxWidth = constraints.maxWidth;
//       double h1p = maxHeight * 0.01;
//       double h10p = maxHeight * 0.1;
//       double w10p = maxWidth * 0.1;
//       double w1p = maxWidth * 0.01;
//
//
//       Widget stack = Stack(
//         children: [
//           Container(
//             height: 100,
//             width: 70,
//             decoration: BoxDecoration(
//               color: const Color(0xff232323),
//               border: Border.all(
//                 color: const Color(0xff666666),
//                 width: 1,
//               ),
//               borderRadius: const BorderRadius.all(Radius.circular(8)),
//             ),
//             alignment: Alignment.center,
//             // child: FlutterZoomView.View(key: Key(sharing.toString()), creationParams: creationParams),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//                 alignment: Alignment.center,
//                 child: Column(mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Image(
//                       image: AssetImage("assets/icons/default-avatar.png"),
//                     ),
//                     Text("Active",style: TextStyles.textStyle11b,)
//
//                   ],
//                 )),
//           ),
//         ],
//       );
//
//
//
//
//       double floatButtonwidth = w1p*19;
//
//
//       // List<Widget> screens = [
//       //   PrescriptionScreen(maxHeight: maxHeight, maxWidth: maxWidth,bookingId: ,),
//       //   ChatPage("appId"),
//       //   // HomeScreen(),
//       //   // ScannedReciepts(),
//       //   // ExpenseGroups(),
//       //   // Profile()
//       // ];
//
//
//
//       return SafeArea(
//         child: FloatingDraggableWidget(floatingWidget:widget.isFromCall==true? InkWell(onTap: (){
//           Navigator.pop(context);
//         },
//           child:stack,
//         ): SizedBox(),floatingWidgetHeight: 100,floatingWidgetWidth: 70,dy:0,dx: maxWidth-70,
//           autoAlign: true,
//           mainScreenWidget: Scaffold(
//             body: Stack(
//               children: [
//                 PageView(controller: pgCntroller,
//                   children: [
//                     ChatPage(appId: widget.appoinmentId,bookingId: widget.bookingId,isCallAvailable: widget.isFromCall!=true,),
//
//                     PrescriptionScreen(appoinmentId: widget.appoinmentId,pgCntroller:pgCntroller,bookingId: widget.bookingId,navigatingFrmChat: false,),
//                   ],
//                 ),
//              Positioned(right:-2,bottom:100,child:SizedBox(height: h10p*1.5,
//                  child: Stack(alignment: Alignment.center,
//                    children: [
//                      Image.asset("assets/images/side-dragger.png"),
//                      InkWell(onTap: (){
//                        pgCntroller.animateToPage(isShowChat?1:0,duration: Duration(milliseconds: 1000),curve: Curves.ease);
//
//                                    getIt<StateManager>().updateHomeIndex();
//                      },
//                        child: SizedBox(height:h1p*3,child: Image.asset(isShowChat?"assets/zoom-icons/priscription-icon.png"
//                            :"assets/images/chat-icon.png")),
//                      ),
//                    ],
//                  )) ,)
//
//               ],
//             ),
//             // floatingActionButton:  Padding(
//             //   padding:  EdgeInsets.zero,
//             //   // child: Visibility(
//             //   //   visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
//             //     child:navIndex==0? Image.asset("assets/images/side-dragger.png"):Padding(
//             //       padding:  EdgeInsets.only(bottom: floatButtonwidth),
//             //       child: Row(mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.end,
//             //         children: [
//             //           InkWell(onTap: (){
//             //             getIt<StateManager>().updateHomeIndex(navIndex==0?1:0);
//             //           },
//             //             child: Container(
//             //               width: floatButtonwidth,
//             //               height:floatButtonwidth,
//             //                   padding: EdgeInsets.all(h1p*2.5),
//             //                   decoration: bxDec,
//             //                   child:Image.asset(navIndex==0?"assets/images/side-dragger.png":"assets/zoom-icons/priscription-icon.png")
//             //               ),
//             //
//             //           ),
//             //         ],
//             //       ),
//             //     )
//             //   // ),
//             // ),
//             // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//             // fluter 1.x
//             // resizeToAvoidBottomInset: false,
//             // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//
//
//
//           ),
//         ),
//       );
//     });
//   }
// }
//
//
//
