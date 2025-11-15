// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/basic_response_model.dart';
import '../../model/core/chat_msg_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';

class ChatProvider extends ChangeNotifier {
  // final WebSocketChannel _channel;
  // List<ChatMsgModel> messagesQ = [];
  List<ChatMsgModel> messagesInChat = [];
  List<Messages> messagesList = [];
  bool chatLoader = false;
  bool chatUploadingLoader = false;
  int pageNo = 0;
  bool isChatEnd = false;
  List<ChatMsgModel> get messages => messagesInChat;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ChatProvider(
  //     // String serverUrl
  //     )
  //     : _channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org')) {
  //   _channel.stream.listen((message) {
  //     // messagesQ.add(message);
  //     notifyListeners();
  //   }, onError: (error) {
  //     print('WebSocket Error: $error');
  //   }, onDone: () {
  //     print('WebSocket connection closed');
  //   });
  // }

  //clearing all chat
  disposeChat() {
    messagesInChat = [];
    messagesList = [];
    chatLoader = false;
  }

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      // _channel.sink.add(message);
    }
  }

  //   void listenToMessage2(String messageId) {
  //
  //     Query query = _firestore
  //         .collection(messageId)
  //         .orderBy('created_at', descending: false); // Sort by creation time
  //
  //     // If we have a last timestamp, fetch documents newer than that
  //     // if (_lastTimestamp != null) {
  //     //   query = query.where('created_at', isGreaterThan: _lastTimestamp);
  //     // }
  //     print("_messageContent");
  //
  //     query.snapshots().listen((documentSnapshot) {
  //       messagesQ = [];
  //       for (var document in documentSnapshot.docs) {
  //         Map<String, dynamic> messageData = document.data() as Map<String,dynamic>;
  //         // print("Message: ${messageData['text_message']}");
  //         print("_messageContent");
  //         print(messageData);
  //         // if(messageData!=null){
  //           Messages i = Messages.fromJson(messageData);
  //
  //
  //           messagesQ.add(ChatMsgModel(id: i.id.toString(),text: i.textMessage,
  //               createdAt: DateTime.parse(i.createdAt!).millisecondsSinceEpoch,
  //               type: i.contentType!.toLowerCase(),uri: "${StringConstants.imgBaseUrl}${i.imageMessage}",
  //               author: Author(id: i.userId.toString(),lastName: "",firstName: ""),name: "",status: "seen",size: 100));
  //         }
  // // messagesQ.sort((a, b) => a.createdAt!.compareTo(b.createdAt as num));
  //         // _messageContent = documentSnapshot.data().toString();
  //         // Map<String, dynamic>? data = documentSnapshot.data();
  //
  //
  //
  //
  //
  //
  //         print("_messageContent");
  //         print(_messageContent);
  //
  //
  //         notifyListeners();
  //       // } else {
  //       //   _messageContent = 'Message not found';
  //       //   notifyListeners();
  //       // }
  //     });
  //   }

  //using snapshot to get real time messages from firebase firestore
  //in future change into web socket
  void listenToMessage(String messageId) async {
    // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
    //     .collection('chat')
    //     .doc(messageId)
    //     .get();
    //
    // var data = documentSnapshot.data();
    // messagesInChat = [];
    //  messagesList = [];
    // Map<String,dynamic> dat = data as Map<String,dynamic>;
    // // List<Map<String,dynamic>> c  = dat["messages"];
    // if (dat['messages'] != null) {
    //   messagesList = <Messages>[];
    //   dat['messages'].forEach((v) {
    //     messagesList.add(new Messages.fromJson(v));
    //   });
    // }

    FirebaseFirestore.instance
        .collection("DQ-chat-messages")
        .doc(messageId)
        .snapshots()
        .listen((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            // var updatedData = documentSnapshot.data();
            var data = documentSnapshot.data();

            messagesInChat = [];
            messagesList = [];
            Map<String, dynamic> dat = data as Map<String, dynamic>;
            // List<Map<String,dynamic>> c  = dat["messages"];
            if (dat['messages'] != null) {
              messagesList = <Messages>[];
              dat['messages'].forEach((v) {
                messagesList.add(Messages.fromJson(v));
              });
              // print("msgs.last.toJson()");
              // print(msgs.last.toJson());
            }
            insertMessagesIntoChat(messagesList);
            bool callStatus = getIt<StateManager>().getInCallStatus();
            if (callStatus) {
              Fluttertoast.showToast(msg: "You have new message");
            }
            notifyListeners();
          } else {
            print("Document does not exist anymore!");
          }
        });
    // _firestore
    //     .collection(messageId).
    //     orderBy('created_at', descending: false).where('created_at', isGreaterThan: getIt<SharedPreferences>().getString("lastTimestamp")??'2024-09-08 11:48:23.210876')
    //     .snapshots().listen((documentSnapshot) {

    //   msgs.addAll(documentSnapshot.docs.map((document) {
    //     return Messages.fromJson(document.data() as Map<String, dynamic>);
    //
    //
    //   }).toList());

    // messagesQ.sort((a, b) => a.createdAt!.compareTo(b.createdAt as num));
    // _messageContent = documentSnapshot.data().toString();
    // Map<String, dynamic>? data = documentSnapshot.data();

    for (var e in messagesInChat) {
      if (kDebugMode) {
        print(e.toJson());
      }
    }
    //
    //
    //         print("_messageContent");
    //         print(msgs.last.createdAt);
    print("dfdfdfdfdfd");
    // getIt<SharedPreferences>().setString("lastTimestamp", msgs.last.createdAt??"");
    // lastTimestamp = msgs.last.createdAt;
    // print(lastTimestamp);

    // } else {
    //   _messageContent = 'Message not found';
    //   notifyListeners();
    // }
    // });
  }

  insertMessagesIntoChat(List<Messages> msgs) {
    for (Messages i in msgs) {
      messagesInChat.add(
        ChatMsgModel(
          id: i.id.toString(),
          text: i.textMessage,
          createdAt: DateTime.parse(i.createdAt!).millisecondsSinceEpoch,
          type: i.contentType!.toLowerCase(),
          uri: "${StringConstants.baseUrl}${i.imageMessage}",
          author: Author(id: i.userId.toString(), lastName: "", firstName: ""),
          name: i.fileName,
          status: "seen",
          size: i.fileSize ?? 0,
        ),
      );
    }
  }

  // void fireBSendMessage2({ required String? msg, required String? id,required String roomId,required String? imageUrl,required String type,required String userID,}) {
  //   _firestore.collection(roomId).doc(id).set({
  //     "id": id,
  //     "content_type": type,
  //     "text_message": msg,
  //     "image_message": imageUrl,
  //     "user_id": userID,
  //     "created_at": DateTime.now().toString()
  //   });
  // }

  //send message
  void fireBSendMessage({
    required String? msg,
    required String? id,
    required String roomId,
    required String? imageUrl,
    required String type,
    required String userID,
    String? fileName,
    int? fileSize,
  }) {
    messagesList.add(
      Messages.fromJson({
        "id": id,
        "content_type": type,
        "file_name": fileName ?? "",
        "file_size": fileSize ?? 0,
        "text_message": msg,
        "image_message": imageUrl,
        "user_id": userID,
        "created_at": DateTime.now().toString(),
      }),
    );

    _firestore.collection("DQ-chat-messages").doc(roomId).set({
      "messages": messagesList.map((e) => e.toJson()).toList(),
    });
  }
  // @override
  // void dispose() {
  //   // _channel.sink.close(status.goingAway);
  //   super.dispose();
  // }

  loadMessages({
    required int
    roomId, //roomId is the chat id, it is connected with appointment id, so each time new chat room will open even the same doctor and patient
    // required int pageNo
  }) async {
    chatLoader = true;
    await Future.delayed(Duration(milliseconds: 100));
    notifyListeners();

    String endpoint = Endpoints.chatHistory;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    Map<String, dynamic> data = {"room_id": roomId, "page": pageNo + 1};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);

    if (responseData != null && responseData['status']) {
      pageNo = pageNo + 1;
      var res = ApiChatModel.fromJson(responseData);
      // return res;
      isChatEnd = res.next == null;
      // for(Messages i in res.messages ?? []){
      //   messagesQ.add(ChatMsgModel(id: i.id.toString(),text: i.textMessage,
      //     createdAt: DateTime.parse(i.createdAt!).millisecondsSinceEpoch,
      //     type: i.contentType!.toLowerCase(),uri: "${StringConstants.imgBaseUrl}${i.imageMessage}",
      //     author: Author(id: i.userId.toString(),lastName: "",firstName: ""),name: "",status: "seen",size: 100));
      // }

      insertMessagesIntoChat(res.messages ?? []);
    } else {}
    // return BasicResponseModel(status: false,message:"");
    // await Future.delayed(Duration(seconds: 0),() {
    //   messagesQ = [
    //     ChatMsgModel.fromJson( {
    //       "author": {
    //         "firstName": "Janice",
    //         "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
    //         "imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
    //         "lastName": "King"
    //       },
    //       "createdAt": 1655624462000,
    //       "id": "22212d42-1252-4641-9786-d6f83b2ce4a8",
    //       "status": "seen",
    //       "text": "Matt, what do you think?",
    //       "type": "text"
    //     }),
    //     ChatMsgModel.fromJson({
    //       "author": {
    //         "firstName": "Janice",
    //         "id": "e52552f4-835d-4dbe-ba77-b076e659774d",
    //         "imageUrl": "https://i.pravatar.cc/300?u=e52552f4-835d-4dbe-ba77-b076e659774d",
    //         "lastName": "King"
    //       },
    //       "createdAt": 1655624461000,
    //       "id": "afc2269a-374b-4382-8864-b3b60d1e8cd7",
    //       "status": "seen",
    //       "text": "Yeah! Together with Demna, Mark Hamill and others 🥰",
    //       "type": "text"
    //     })
    //
    //
    //   ];
    // },);

    // String endpoint = Endpoints.doctorProfile;
    //
    // Map<String, dynamic> data = {
    //   "app_user_id":userId,
    //
    // };
    //
    // String tokn = getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    //
    // dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    //
    //
    // if (responseData != null) {
    //   notifyListeners();
    //   _messages = ChatMsgModel.fromJson(responseData);
    //   // return result;
    // }
    //

    chatLoader = false;
    notifyListeners();
  }

  //saving document and images
  Future<BasicResponseModel> saveChatFile({required String filePath}) async {
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
    // await Future.delayed
    chatUploadingLoader = true;
    notifyListeners();

    String endpoint = Endpoints.saveChatFile;
    MultipartFile? fls = MultipartFile.fromFileSync(
      filePath,
      filename: filePath.split('/').last,
    );

    final formData = FormData.fromMap({"file": fls});

    print({"file": fls});

    var response = await getIt<DioClient>().post(endpoint, formData, tokn);
    chatUploadingLoader = false;
    notifyListeners();
    if (response != null) {
      var result = BasicResponseModel.fromJson(response);
      return result;
    } else {
      return BasicResponseModel(message: "Server error", status: false);
    }
  }
}
