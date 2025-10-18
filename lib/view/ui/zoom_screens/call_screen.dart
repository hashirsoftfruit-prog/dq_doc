import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/ui/chat_screen.dart';
// import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/view/ui/zoom_screens/utils/jwt.dart';
import 'package:dqueuedoc/view/ui/zoom_screens/video_view.dart';
import 'package:entry/entry.dart';
import 'package:events_emitter/events_emitter.dart';
// import 'package:dqueuedoc/view/ui/starting_screens/splash_scren.dart';
import 'package:flu_wake_lock/flu_wake_lock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_event_listener.dart';
// import 'package:flutter_zoom_videosdk/native/zoom_videosdk_live_transcription_message_info.dart';
import 'package:flutter_zoom_videosdk/native/zoom_videosdk_user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
// import '../starting_screens/online_consult_landing.dart';
import 'package:pip_view/pip_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/managers/online_consult_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../anatomy_screen.dart';

class CallScreen extends StatefulHookWidget {
  final bool isJoin;

  final String sessionName;
  final int bookingId;
  final String sessionPwd;
  final String displayName;
  final String sessionIdleTimeoutMins;
  final String role;

  const CallScreen({
    super.key,
    required this.sessionName,
    required this.sessionPwd,
    required this.displayName,
    required this.bookingId,
    required this.sessionIdleTimeoutMins,
    required this.role,
    required this.isJoin,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  static TextEditingController changeNameController = TextEditingController();
  double opacityLevel = 1.0;
  final FluWakeLock _fluWakeLock = FluWakeLock();
  var zoom = ZoomVideoSdk();
  final bool isRecording = false;

  final bool disconnected =
      false; //value for getting the call status disconnected while pip active

  void _changeOpacity() {
    setState(() => opacityLevel = opacityLevel == 0 ? 1.0 : 0.0);
  }

  @override
  void dispose() async {
    zoom.leaveSession(true);
    getIt<StateManager>().setInCallStatus(false);
    getIt<StateManager>().setRecordingStatus(false);
    _fluWakeLock.disable();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  final eventListener = ZoomVideoSdkEventListener();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    _fluWakeLock.enable();

    getIt<StateManager>().setInCallStatus(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCallEnded = Provider.of<StateManager>(context).showCallEnded;

    // var bxDec =
    //     BoxDecoration(shape: BoxShape.circle, color: Colours.primaryblue);
    var bxDec3 = BoxDecoration(
      color: Colors.black38,
      borderRadius: BorderRadius.circular(50),
    );
    var bxDec2 = const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xffFF796D),
    );
    ////////////////////////////////////////////////////

    // InitConfig initConfig = InitConfig(
    //   domain: "zoom.us",
    //   enableLog: false,
    // );
    // zoom.initSdk(initConfig);
    ////////////////////////////////////////////////////
    var eventListener = ZoomVideoSdkEventListener();
    var isInSession = useState(false);
    var sessionName = useState('');
    var sessionPassword = useState('');
    var users = useState(<ZoomVideoSdkUser>[]);
    var fullScreenUser = useState<ZoomVideoSdkUser?>(null);
    var sharingUser = useState<ZoomVideoSdkUser?>(null);

    var isMuted = useState(true);
    var isVideoOn = useState(false);
    var isSpeakerOn = useState(false);
    var isRenameModalVisible = useState(false);

    var isMounted = useIsMounted();
    var audioStatusFlag = useState(false);
    var videoStatusFlag = useState(false);
    // var userNameFlag = useState(false);
    // var userShareStatusFlag = useState(false);
    var isReceiveSpokenLanguageContentEnabled = useState(false);

    var isPiPView = useState(false);

    //hide status bar
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    Color backgroundColor = const Color(0xFF232323);
    // Color buttonBackgroundColor = const Color.fromRGBO(0, 0, 0, 0.6);
    Color chatTextColor = const Color(0xFFAAAAAA);
    Widget changeNamePopup;
    // final args =
    // ModalRoute.of(context)!.settings.arguments as CallArguments;
    useEffect(() {
      Future<void>.microtask(() async {
        var token = generateJwt(widget.sessionName, widget.role);
        try {
          Map<String, bool> sdkAudioOptions = {
            "connect": true,
            "mute": false,
            "autoAdjustSpeakerVolume": false,
          };
          Map<String, bool> sdkVideoOptions = {
            "localVideoOn": true,
          }; // false first
          JoinSessionConfig joinSession = JoinSessionConfig(
            sessionName: widget.sessionName,
            sessionPassword: widget.sessionPwd,
            token: token,
            userName: widget.displayName,
            audioOptions: sdkAudioOptions,
            videoOptions: sdkVideoOptions,
            sessionIdleTimeoutMins: int.parse(widget.sessionIdleTimeoutMins),
          );
          await zoom.joinSession(joinSession);

          // Start video manually after session join
          ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
          if (mySelf != null) {
            final status = await zoom.videoHelper.startVideo();
            log(status);
            isVideoOn.value = await mySelf.videoStatus?.isOn() ?? false;
          }
        } catch (e, s) {
          log("Failed to join session: $e \n\n$s");
          Fluttertoast.showToast(msg: "Failed to join session");
        }
      });
      return null;
    }, []);

    useEffect(() {
      log("message is asdafsdfa");

      eventListener.addEventListener();
      EventEmitter emitter = eventListener.eventEmitter;

      final sessionJoinListener = emitter.on(EventType.onSessionJoin, (
        sessionUser,
      ) async {
        log("message is on session join");
        isInSession.value = true;
        zoom.session.getSessionName().then(
          (value) => sessionName.value = value!,
        );
        sessionPassword.value = await zoom.session.getSessionPassword();
        log("message is session user $sessionUser");
        ZoomVideoSdkUser mySelf = ZoomVideoSdkUser.fromJson(
          // jsonDecode(sessionUser['sessionUser']),

          // // sessionUser['sessionUser'],
          jsonDecode(sessionUser.toString()),
        );
        List<ZoomVideoSdkUser>? remoteUsers = await zoom.session
            .getRemoteUsers();
        var muted = await mySelf.audioStatus?.isMuted();
        var videoOn = await mySelf.videoStatus?.isOn();
        var speakerOn = await zoom.audioHelper.getSpeakerStatus();
        remoteUsers?.insert(0, mySelf);
        fullScreenUser.value = remoteUsers?.last;

        isMuted.value = muted!;
        isSpeakerOn.value = speakerOn;
        isVideoOn.value = videoOn!;
        users.value = remoteUsers!;

        isReceiveSpokenLanguageContentEnabled.value = await zoom
            .liveTranscriptionHelper
            .isReceiveSpokenLanguageContentEnabled();
      });

      final sessionLeaveListener = emitter.on(EventType.onSessionLeave, (
        data,
      ) async {
        log("message is on session leave");
        isInSession.value = false;
        users.value = <ZoomVideoSdkUser>[];
        fullScreenUser.value = null;
        Navigator.pop(context);

        // Navigator.popAndPushNamed(
        //   context,
        //   "Join",
        //   arguments: JoinArguments(
        //       widget.isJoin,
        //       sessionName.value,
        //       sessionPassword.value,
        //       widget.displayName,
        //       widget.sessionIdleTimeoutMins,
        //       widget.role
        //   ),
        // );
      });

      final sessionNeedPasswordListener = emitter.on(
        EventType.onSessionNeedPassword,
        (data) async {
          log("message is on session need pass");
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Session Need Password'),
              content: const Text('Password is required'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async => {
                    // Navigator.popAndPushNamed(
                    //   context,
                    //   'Join',
                    //   arguments: JoinArguments(
                    //       widget.isJoin,
                    //       widget.sessionName,
                    //       "",
                    //       widget.displayName,
                    //       widget.sessionIdleTimeoutMins,
                    //       widget.role
                    //   )),
                    await zoom.leaveSession(false),
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      );

      final userVideoStatusChangedListener = emitter.on(
        EventType.onUserVideoStatusChanged,
        (data) async {
          data = data as Map;
          ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
          var userListJson = jsonDecode(data['changedUsers']) as List;
          List<ZoomVideoSdkUser> userList = userListJson
              .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
              .toList();
          for (var user in userList) {
            {
              if (user.userId == mySelf?.userId) {
                mySelf?.videoStatus?.isOn().then((on) => isVideoOn.value = on);
              }
            }
          }
          videoStatusFlag.value = !videoStatusFlag.value;
        },
      );

      final userAudioStatusChangedListener = emitter.on(
        EventType.onUserAudioStatusChanged,
        (data) async {
          data = data as Map;
          ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
          var userListJson = jsonDecode(data['changedUsers']) as List;
          List<ZoomVideoSdkUser> userList = userListJson
              .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
              .toList();
          for (var user in userList) {
            {
              if (user.userId == mySelf?.userId) {
                mySelf?.audioStatus?.isMuted().then(
                  (muted) => isMuted.value = muted,
                );
              }
            }
          }
          audioStatusFlag.value = !audioStatusFlag.value;
        },
      );

      final userJoinListener = emitter.on(EventType.onUserJoin, (data) async {
        if (!isMounted()) return;
        data = data as Map;
        ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
        var userListJson = jsonDecode(data['remoteUsers']) as List;
        List<ZoomVideoSdkUser> remoteUserList = userListJson
            .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
            .toList();
        remoteUserList.insert(0, mySelf!);
        users.value = remoteUserList;

        getIt<OnlineConsultManager>().confirmCallCompletion(widget.bookingId);
      });

      void onLeaveSession(bool isEndSession) async {
        await zoom.leaveSession(isEndSession);
        Navigator.pop(context);
      }

      final userLeaveListener = emitter.on(EventType.onUserLeave, (data) async {
        if (!isMounted()) return;
        ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
        data = data as Map;
        var remoteUserListJson = jsonDecode(data['remoteUsers']) as List;
        List<ZoomVideoSdkUser> remoteUserList = remoteUserListJson
            .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
            .toList();
        var leftUserListJson = jsonDecode(data['leftUsers']) as List;
        List<ZoomVideoSdkUser> leftUserLis = leftUserListJson
            .map((userJson) => ZoomVideoSdkUser.fromJson(userJson))
            .toList();
        if (fullScreenUser.value != null) {
          for (var user in leftUserLis) {
            {
              if (fullScreenUser.value?.userId == user.userId) {
                fullScreenUser.value = mySelf;
              }
            }
          }
        } else {
          fullScreenUser.value = mySelf;
        }

        // bool val = getIt<StateManager>().getSheetOpenStatus();
        if (remoteUserList.isEmpty) {
          // remoteUserList.add(mySelf!);
          users.value = [];
          // getIt<OnlineConsultManager>().setSmallUser(user:null);
          await getIt<StateManager>().setCallEndedStatus();

          PIPView.of(context)?.stopFloating(); // Close PiP mode
          onLeaveSession(true);
        } else {
          remoteUserList.add(mySelf!);
          users.value = [];
        }
      });

      final requireSystemPermission = emitter.on(
        EventType.onRequireSystemPermission,
        (data) async {
          data = data as Map;
          ZoomVideoSdkUser? changedUser = ZoomVideoSdkUser.fromJson(
            jsonDecode(data['changedUser']),
          );
          var permissionType = data['permissionType'];
          switch (permissionType) {
            case SystemPermissionType.Camera:
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Can't Access Camera"),
                  content: const Text(
                    "please turn on the toggle in system settings to grant permission",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              break;
            case SystemPermissionType.Microphone:
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Can't Access Microphone"),
                  content: const Text(
                    "please turn on the toggle in system settings to grant permission",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              break;
          }
        },
      );

      final networkStatusChangeListener = emitter.on(
        EventType.onUserVideoNetworkStatusChanged,
        (data) async {
          data = data as Map;
          ZoomVideoSdkUser? networkUser = ZoomVideoSdkUser.fromJson(
            jsonDecode(data['user']),
          );

          if (data['status'] == NetworkStatus.Bad) {
            debugPrint(
              "onUserVideoNetworkStatusChanged: status: ${data['status']}, user: ${networkUser.userName}",
            );
          }
        },
      );

      final eventErrorListener = emitter.on(EventType.onError, (data) async {
        data = data as Map;
        String errorType = data['errorType'];
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error"),
            content: Text(errorType),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (errorType == Errors.SessionJoinFailed ||
            errorType == Errors.SessionDisconnecting) {
          Fluttertoast.showToast(msg: "Call join failed");
        }
      });

      final testMicStatusListener = emitter.on(
        EventType.onTestMicStatusChanged,
        (data) async {
          data = data as Map;
          String status = data['status'];
          debugPrint('testMicStatusListener: status= $status');
        },
      );

      final micSpeakerVolumeChangedListener = emitter.on(
        EventType.onMicSpeakerVolumeChanged,
        (data) async {
          data = data as Map;
          int type = data['micVolume'];
          debugPrint(
            'onMicSpeakerVolumeChanged: micVolume= $type, speakerVolume',
          );
        },
      );

      return () => {
        sessionJoinListener.cancel(),
        sessionLeaveListener.cancel(),
        sessionNeedPasswordListener.cancel(),
        userVideoStatusChangedListener.cancel(),
        userAudioStatusChangedListener.cancel(),
        userJoinListener.cancel(),
        userLeaveListener.cancel(),

        eventErrorListener.cancel(),

        requireSystemPermission.cancel(),
        networkStatusChangeListener.cancel(),

        testMicStatusListener.cancel(),
        micSpeakerVolumeChangedListener.cancel(),
      };
    }, [zoom, users.value, isMounted]);

    void selectVirtualBackgroundItem() async {
      final ImagePicker picker = ImagePicker();
      // Pick an image.
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      getIt<SharedPreferences>().setString("bgName", image!.name);
      await zoom.virtualBackgroundHelper.addVirtualBackgroundItem(image.path);
    }

    void onPressAudio() async {
      try {
        ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();

        if (mySelf != null) {
          final audioStatus = mySelf.audioStatus;
          if (audioStatus != null) {
            var muted = await audioStatus.isMuted();
            if (muted) {
              await zoom.audioHelper.unMuteAudio(mySelf.userId);
            } else {
              await zoom.audioHelper.muteAudio(mySelf.userId);
            }
          }
        }
      } catch (e) {
        log("message $e");
      }
    }

    void onPressVideo() async {
      try {
        ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();

        if (mySelf != null) {
          final videoStatus = mySelf.videoStatus;
          if (videoStatus != null) {
            var videoOn = await videoStatus.isOn();
            if (videoOn) {
              await zoom.videoHelper.stopVideo();
            } else {
              final status = await zoom.videoHelper.startVideo();
              log(status);
            }
          }
        }
      } on Exception catch (e) {
        log("video on off error $e");

      }
    }

    void onPressAnatomy() async {
      showDialog(
        context: context,
        builder: (context) => AnatomyScreen(bookingId: widget.bookingId),
      );
    }

    void onPressBgChange() async {
      bool supportVB = await zoom.virtualBackgroundHelper
          .isSupportVirtualBackground();
      print("supportVBsupportVB");
      print(supportVB);

      selectVirtualBackgroundItem();
    }

    changeNamePopup = Center(
      child: Stack(
        children: [
          Visibility(
            visible: isRenameModalVisible.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width - 130,
                  height: 130,
                  child: Center(
                    child: (Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Text(
                            'Change Name',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 230,
                            child: TextField(
                              onEditingComplete: () {},
                              autofocus: true,
                              cursorColor: Colors.black,
                              controller: changeNameController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'New name',
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: chatTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: InkWell(
                                  child: Text(
                                    'Apply',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (fullScreenUser.value != null) {
                                      ZoomVideoSdkUser? mySelf = await zoom
                                          .session
                                          .getMySelf();
                                      await zoom.userHelper.changeName(
                                        (mySelf?.userId)!,
                                        changeNameController.text,
                                      );
                                      changeNameController.clear();
                                    }
                                    isRenameModalVisible.value = false;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: InkWell(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  onTap: () async {
                                    isRenameModalVisible.value = false;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    void onSelectedUserVolume(ZoomVideoSdkUser user) async {
      var isShareAudio = user.isSharing;
      bool canSetVolume = await user.canSetUserVolume(
        user.userId,
        isShareAudio,
      );
      num userVolume;

      List<ListTile> options = [
        ListTile(
          title: Text(
            'Adjust Volume',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Current volume',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          onTap: () async => {
            debugPrint('user volume'),
            userVolume = await user.getUserVolume(user.userId, isShareAudio),
            debugPrint('user ${user.userName}\'s volume is ${userVolume}'),
          },
        ),
      ];
      if (canSetVolume) {
        options.add(
          ListTile(
            title: Text(
              'Volume up',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () async => {
              userVolume = await user.getUserVolume(user.userId, isShareAudio),
              if (userVolume < 10)
                {
                  await user.setUserVolume(
                    user.userId,
                    userVolume + 1,
                    isShareAudio,
                  ),
                }
              else
                {debugPrint("Cannot volume up.")},
            },
          ),
        );
        options.add(
          ListTile(
            title: Text(
              'Volume down',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () async => {
              userVolume = await user.getUserVolume(user.userId, isShareAudio),
              if (userVolume > 0)
                {
                  await user.setUserVolume(
                    user.userId,
                    userVolume - 1,
                    isShareAudio,
                  ),
                }
              else
                {debugPrint("Cannot volume down.")},
            },
          ),
        );
      }
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            elevation: 0.0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              height: options.length * 58,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListView(
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: options,
                    ).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void onLeaveSession(bool isEndSession) async {
      print('print(e)sdsdsd');
      if (isInSession.value) {
        await zoom.leaveSession(isEndSession);
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
      }
      // Navigator.pop(context);
    }

    void showLeaveOptions() async {
      ZoomVideoSdkUser? mySelf = await zoom.session.getMySelf();
      bool isHost = await mySelf!.getIsHost();

      Widget endSession;
      Widget leaveSession;
      Widget cancel = TextButton(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.pop(context); //close Dialog
        },
      );

      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          endSession = TextButton(
            child: const Text('End Session'),
            onPressed: () => onLeaveSession(true),
          );
          leaveSession = TextButton(
            child: const Text('Leave Session'),
            onPressed: () => onLeaveSession(false),
          );
          break;
        default:
          endSession = CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('End Session'),
            onPressed: () => onLeaveSession(true),
          );
          leaveSession = CupertinoActionSheetAction(
            child: const Text('Leave Session'),
            onPressed: () => onLeaveSession(false),
          );
          break;
      }

      List<Widget> options = [leaveSession, cancel];

      if (Platform.isAndroid) {
        if (isHost) {
          options.removeAt(1);
          options.insert(0, endSession);
        }
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text("Do you want to leave this session?"),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              actions: options,
            );
          },
        );
      } else {
        options.removeAt(1);
        if (isHost) {
          options.insert(1, endSession);
        }
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            message: const Text(
              'Are you sure that you want to leave the session?',
            ),
            actions: options,
            cancelButton: cancel,
          ),
        );
      }
    }

    Widget fullScreenView;
    Widget smallView;
    log('message is isInsession ${isInSession.value}');
    log("message is fullScreenUser.value ${fullScreenUser.value}");
    log("message is users.value ${users.value}");

    if (isInSession.value &&
        // fullScreenUser.value != null &&
        users.value.isNotEmpty
    // &&users.value.length>1
    ) {
      fullScreenUser.value = users.value.last;
      fullScreenView = AnimatedOpacity(
        opacity: opacityLevel,
        duration: const Duration(seconds: 3),
        child: VideoView(
          user: fullScreenUser.value,
          hasMultiCamera: false,
          isPiPView: isPiPView.value,
          sharing: sharingUser.value == null
              ? false
              : (sharingUser.value?.userId == fullScreenUser.value?.userId),
          preview: false,
          focused: false,
          multiCameraIndex: "0",
          videoAspect: VideoAspect.Original,
          fullScreen: true,
          resolution: VideoResolution.Resolution360,
        ),
      );
    } else {
      fullScreenView = Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "You are the only one here in this call",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
      smallView = Container(height: 110, color: Colors.transparent);
    }

    if (isInSession.value &&
        // fullScreenUser.value != null
        // &&
        users.value.isNotEmpty &&
        users.value.length > 1) {
      smallView = Container(
        height: 110,
        margin: const EdgeInsets.only(left: 20, right: 20),
        // alignment: Alignment.center,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: users.value.length,
          itemBuilder: (BuildContext context, int index) {
            if (users.value[index].userId == fullScreenUser.value?.userId) {
              return const SizedBox();
            }
            return InkWell(
              onTap: () async {
                // onSelectedUser(users.value[index]);
              },
              onDoubleTap: () async {
                onSelectedUserVolume(users.value[index]);
              },
              child: Center(
                child: VideoView(
                  user: users.value[index],
                  hasMultiCamera: false,
                  isPiPView: false,
                  sharing: false,
                  preview: false,
                  focused: false,
                  multiCameraIndex: "0",
                  videoAspect: VideoAspect.Original,
                  fullScreen: false,
                  resolution: VideoResolution.Resolution180,
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
      );
    } else {
      fullScreenView = Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Connecting...",
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
      smallView = Container(height: 110, color: Colors.transparent);
    }

    _changeOpacity;
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;

        double w1p = maxWidth * 0.01;

        return Consumer<StateManager>(
          builder: (context, sMgr, _) {
            return PIPView(
              floatingWidth: w1p * 30,
              floatingHeight: w1p * 45,
              builder: (context, isFloating) {
                return WillPopScope(
                  onWillPop: () async {
                    if (isFloating) {
                      PIPView.of(context)?.stopFloating(); // Close PiP mode
                      return false; // Prevent back navigation
                    }
                    showLeaveOptions();
                    return false; // Prevent back navigation

                    // return true; // Allow back navigation if not in PiP mode
                  },
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: backgroundColor,
                    body: isCallEnded == true
                        ? const CallDisconnectedScreen()
                        : Stack(
                            children: [
                              fullScreenView,
                              isFloating == true
                                  ? const SizedBox()
                                  : Container(
                                      padding: const EdgeInsets.only(top: 35),
                                      child: Stack(
                                        children: [
                                          users.value.isNotEmpty
                                              ? GestureDetector(
                                                  onTap: () {
                                                    PIPView.of(
                                                      context,
                                                    )!.presentBelow(
                                                      ChatPage(
                                                        appId:
                                                            widget.sessionName,
                                                        bookingId:
                                                            widget.bookingId,
                                                        isPipModeActive: true,
                                                        isCallAvailable: false,
                                                      ),
                                                    );
                                                  },

                                                  child: Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Icon(
                                                        CupertinoIcons
                                                            .arrow_down_right_arrow_up_left,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          Container(
                                            alignment: Alignment.topRight,
                                            margin: const EdgeInsets.only(
                                              top: 20,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                smallView,

                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  child: iconBtn2(
                                                    size: w1p * 15,
                                                    onPressed: onPressAnatomy,
                                                    icon:
                                                        "assets/images/anatomy-icon.png",
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  child: iconBtn2(
                                                    size: w1p * 15,
                                                    onPressed: onPressBgChange,
                                                    // iconSize: 20,
                                                    icon:
                                                        "assets/zoom-icons/add-background-image.png",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Column(
                                              children: [
                                                const Spacer(),

                                                InkWell(
                                                  onTap: () async {},
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Colors
                                                                  .transparent,
                                                              Colors.black38,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: h1p * 4,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Visibility(
                                                            visible: users
                                                                .value
                                                                .isNotEmpty,
                                                            child: Container(
                                                              decoration:
                                                                  bxDec3,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    w1p,
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  iconBtn(
                                                                    size:
                                                                        w1p *
                                                                        15,
                                                                    onPressed:
                                                                        onPressVideo,
                                                                    // iconSize: circleButtonSize,
                                                                    icon:
                                                                        isVideoOn
                                                                            .value
                                                                        ? "assets/zoom-icons/video-on.png"
                                                                        : "assets/zoom-icons/video-off.png",
                                                                  ),
                                                                  iconBtn(
                                                                    size:
                                                                        w1p *
                                                                        15,
                                                                    onPressed:
                                                                        onPressAudio,
                                                                    // iconSize: circleButtonSize,
                                                                    icon:
                                                                        isMuted
                                                                            .value
                                                                        ? "assets/zoom-icons/mic-mute.png"
                                                                        : "assets/zoom-icons/mic-unmute.png",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          TextButton(
                                                            onPressed:
                                                                (showLeaveOptions),
                                                            child: Container(
                                                              height: w1p * 20,
                                                              width: w1p * 20,
                                                              // padding: EdgeInsets.all(10),
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    w1p * 6,
                                                                  ),
                                                              decoration:
                                                                  bxDec2,
                                                              child: Image.asset(
                                                                "assets/zoom-icons/rejectbtn.png",
                                                                height: h1p * 3,
                                                              ),
                                                            ),
                                                          ),

                                                          Visibility(
                                                            visible: users
                                                                .value
                                                                .isNotEmpty,
                                                            child: Container(
                                                              decoration:
                                                                  bxDec3,
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    w1p,
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  iconBtn(
                                                                    size:
                                                                        w1p *
                                                                        15,
                                                                    onPressed: () {
                                                                      PIPView.of(
                                                                        context,
                                                                      )!.presentBelow(
                                                                        ChatPage(
                                                                          appId:
                                                                              widget.sessionName,
                                                                          bookingId:
                                                                              widget.bookingId,
                                                                          isPipModeActive:
                                                                              true,
                                                                          isCallAvailable:
                                                                              false,
                                                                        ),
                                                                      );
                                                                    },

                                                                    icon:
                                                                        "assets/images/chat-icon.png",
                                                                  ),
                                                                  iconBtn(
                                                                    size:
                                                                        w1p *
                                                                        15,
                                                                    onPressed: () {
                                                                      PIPView.of(
                                                                        context,
                                                                      )!.presentBelow(
                                                                        ChatPage(
                                                                          appId:
                                                                              widget.sessionName,
                                                                          bookingId:
                                                                              widget.bookingId,
                                                                          isPipModeActive:
                                                                              true,
                                                                          isCallAvailable:
                                                                              false,
                                                                          isDirectToPrescrioption:
                                                                              true,
                                                                        ),
                                                                      );
                                                                    },

                                                                    icon:
                                                                        "assets/images/medical-prescription.png",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                            ],
                          ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

iconBtn({
  required String icon,
  required Function onPressed,
  required double size,
}) {
  var bxDec = const BoxDecoration(shape: BoxShape.circle, color: Colors.black);

  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
      height: size,
      width: size,
      decoration: bxDec,
      child: Image.asset(icon),
    ),
  );
}

iconBtn2({
  required String icon,
  required Function onPressed,
  required double size,
}) {
  var bxDec = const BoxDecoration(shape: BoxShape.circle, color: Colors.black);

  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
      height: size,
      width: size,
      decoration: bxDec,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Image.asset(icon, color: Colors.white),
      ),
    ),
  );
}

class CallDisconnectedScreen extends StatelessWidget {
  const CallDisconnectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xFF232323),
        // gradient: LinearGradient(colors: [Colors.transparent,Color(0xfff03a14).withOpacity(0.7),Colors.transparent],begin: Alignment.bottomCenter,end: Alignment.topCenter)
      ),
      child: Entry(
        yOffset: 100,
        // scale: 20,
        delay: const Duration(milliseconds: 1),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.ease,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              child: Image.asset(
                "assets/images/call-ended-icon.png",
                color: Colors.white,
              ),
            ),
            verticalSpace(8),
            const Text("Call Disconnected", style: TextStyles.textStyle56b),
          ],
        ),
      ),
    );
  }
}
