import 'package:dqueuedoc/controller/managers/online_consult_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:dqueuedoc/view/ui/starting_screens/patient_details_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/pdf_view_screen.dart';
import 'package:dqueuedoc/view/ui/starting_screens/priscription_screen.dart';
import 'package:dqueuedoc/view/ui/zoom_screens/call_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:pip_view/pip_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../controller/managers/chat_manager.dart';
import '../../controller/managers/state_manager.dart';
import '../../model/helper/service_locator.dart';
import '../theme/constants.dart';

class ChatPage extends StatefulWidget {
  final String appId;
  final int bookingId;
  final bool? isCallAvailable;
  final bool? isPipModeActive;
  final bool? isDirectToCall;
  final bool? isDirectToPrescrioption;
  const ChatPage({
    super.key,
    required this.appId,
    required this.bookingId,
    this.isPipModeActive,
    this.isDirectToPrescrioption,
    this.isCallAvailable,
    this.isDirectToCall,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.org'),
  );
  // final channel = WebSocketChannel.connect(Uri.parse('wss://1232234242'));

  // List<types.Message> _messages = [];
  late List<types.Message> _messages;
  final _user = types.User(
    id: '${getIt<SharedPreferences>().getInt(StringConstants.userId) ?? ''}',
  );

  @override
  void dispose() {
    getIt<StateManager>().setInChatStatus(false);
    getIt<ChatProvider>().disposeChat();

    if (widget.isCallAvailable == true) {
      getIt<OnlineConsultManager>().getRecentPatientsList();
      getIt<OnlineConsultManager>().getPatientRequestList();
      getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());
    }

    super.dispose();
  }

  @override
  void initState() {
    getIt<StateManager>().setInChatStatus(true);
    _navigateToCall();
    Provider.of<ChatProvider>(
      context,
      listen: false,
    ).listenToMessage(widget.appId);

    super.initState();
    // _loadMessages();
    // streamListener();
  }

  Future<bool> onWillPop() async {
    if (widget.isCallAvailable == true) {
      bool? result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CloseAlert(msg: "Are you sure you want to close?");
        },
      );

      if (result != null) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }

  _navigateToCall() async {
    await Future.delayed(Duration(milliseconds: 100));

    if (widget.isDirectToCall == true) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CallScreen(
            bookingId: widget.bookingId,

            displayName:
                getIt<SharedPreferences>().getString(
                  StringConstants.userName,
                ) ??
                "Unknown",
            role: "0",
            isJoin: true,
            sessionIdleTimeoutMins: "1",
            sessionName: widget.appId,
            sessionPwd: 'Qwerty123',
          ),
        ),
      );
      Provider.of<ChatProvider>(
        context,
        listen: false,
      ).listenToMessage(widget.appId);
    } else if (widget.isDirectToPrescrioption == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrescriptionScreen(
            navigatingFrmChat: true,
            appoinmentId: widget.appId,
            bookingId: widget.bookingId,
          ),
        ),
      );
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      var res = await getIt<ChatProvider>().saveChatFile(
        filePath: result.files.single.path!,
      );

      String fileName = result.files.single.path?.split('/').last ?? "File";
      if (res.status == true) {
        getIt<ChatProvider>().fireBSendMessage(
          id: Uuid().v4(),
          roomId: widget.appId,
          type: 'File',
          msg: null,
          imageUrl: res.file,
          userID: _user.id,
          fileName: fileName,
          fileSize: result.files.single.size,
        );
      } else {
        Fluttertoast.showToast(msg: res.message ?? "");
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      await result.readAsBytes();
      var res = await getIt<ChatProvider>().saveChatFile(filePath: result.path);

      if (res.status == true) {
        getIt<ChatProvider>().fireBSendMessage(
          id: Uuid().v4(),
          roomId: widget.appId,
          type: 'Image',
          msg: null,
          imageUrl: res.file,
          userID: _user.id,
        );
      } else {
        Fluttertoast.showToast(msg: res.message ?? "");
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerPage(message.uri)),
      );
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    // channel.sink.add('{"userId":1,"message":"${message.text}"}');
    getIt<ChatProvider>().fireBSendMessage(
      id: Uuid().v4(),
      roomId: widget.appId,
      type: 'Text',
      msg: message.text,
      imageUrl: null,
      userID: _user.id,
    );

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void getNewMessage(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    // _addMessage(textMessage);
    getIt<OnlineConsultManager>().addMessageToChat(textMessage);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;
      // double w1p = maxWidth * 0.01;

      _messages = Provider.of<OnlineConsultManager>(context).cMessages;

      return Consumer<OnlineConsultManager>(
        builder: (context, bmgr, child) {
          return WillPopScope(
            onWillPop: onWillPop,

            child: Consumer<ChatProvider>(
              builder: (context, mgr, child) {
                return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 2,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                      ),
                    ),
                    title: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.isPipModeActive == true) {
                              PIPView.of(context)?.stopFloating();
                            } else if (widget.isCallAvailable == true) {
                              bool result = await onWillPop();
                              if (result) Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: SizedBox(
                            height: 20,
                            child: SvgPicture.asset(
                              "assets/images/back-arrow.svg",
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("Chat", style: TextStyles.prescript3),
                        const Spacer(),
                        if (widget.isPipModeActive == true ||
                            widget.isCallAvailable == true)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookingDetailsScreen(widget.bookingId),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(width: 12),
                        if (widget.isPipModeActive == true ||
                            widget.isCallAvailable == true)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PrescriptionScreen(
                                    navigatingFrmChat: true,
                                    appoinmentId: widget.appId,
                                    bookingId: widget.bookingId,
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.list_alt,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(width: 12),
                        if (widget.isCallAvailable != false &&
                            getIt<OnlineConsultManager>().usersmallUser == null)
                          getIt<OnlineConsultManager>().callingLoader
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    var res =
                                        await getIt<OnlineConsultManager>()
                                            .initiateCall(
                                              bookingId: widget.bookingId,
                                            );
                                    if (res.status == true) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CallScreen(
                                            bookingId: widget.bookingId,
                                            displayName:
                                                getIt<SharedPreferences>()
                                                    .getString(
                                                      StringConstants.userName,
                                                    ) ??
                                                "Unknown",
                                            role: "0",
                                            isJoin: true,
                                            sessionIdleTimeoutMins: "1",
                                            sessionName: widget.appId,
                                            sessionPwd: 'Qwerty123',
                                          ),
                                        ),
                                      );
                                      Provider.of<ChatProvider>(
                                        context,
                                        listen: false,
                                      ).listenToMessage(widget.appId);
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        CustomSnackBar.info(
                                          backgroundColor: Colours.toastBlue,
                                          maxLines: 3,
                                          message: res.message ?? "",
                                        ),
                                        padding: const EdgeInsets.all(30),
                                        snackBarPosition: SnackBarPosition.top,
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.video_camera_front_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Chat(
                          inputOptions: InputOptions(
                            sendButtonVisibilityMode:
                                SendButtonVisibilityMode.always,
                          ),
                          messages: mgr.messagesInChat.reversed
                              .map((e) => types.Message.fromJson(e.toJson()))
                              .toList(),
                          onAttachmentPressed: _handleAttachmentPressed,
                          onMessageTap: _handleMessageTap,
                          onPreviewDataFetched: _handlePreviewDataFetched,
                          onSendPressed: _handleSendPressed,
                          showUserAvatars: false,
                          showUserNames: false,
                          user: _user,
                          isAttachmentUploading: mgr.chatUploadingLoader,
                          theme: const DefaultChatTheme(
                            sendingIcon: Icon(Icons.send),
                            attachmentButtonIcon: Icon(Icons.attach_email),
                            sendButtonIcon: Icon(Icons.send),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // ),
          );
        },
      );
    },
  );
}
