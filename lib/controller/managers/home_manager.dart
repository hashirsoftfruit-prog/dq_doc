//
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:dqueue/model/core/basic_response_model.dart';
// import 'package:dqueue/model/core/bill_model.dart';
// import 'package:dqueue/model/core/questionare_response_model.dart';
// import 'package:dqueue/view/theme/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../model/core/applied_coupon_response_model.dart';
// import '../../model/core/available doctors_response_model.dart';
// import '../../model/core/coupons_model.dart';
// import '../../model/core/other_patients_response_model.dart';
// import '../../model/core/package_list_response_model.dart';
// norifications '../../model/helper/service_locator.dart';
// import '../services/api_endpoints.dart';
// import '../services/dio_service.dart';
//
import 'package:dio/dio.dart';
import 'package:dqueuedoc/controller/managers/auth_manager.dart';
import 'package:dqueuedoc/model/core/basic_response_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/core/app_details_model.dart';
import '../../model/core/fou_details_model.dart';
import '../../model/core/fou_list_model.dart';
import '../../model/core/notifications_list_model.dart';
import '../../model/helper/service_locator.dart';
import '../../view/theme/constants.dart';
import '../services/api_endpoints.dart';
import '../services/dio_service.dart';
import 'online_consult_manager.dart';

class HomeManager extends ChangeNotifier {
  bool notificationLoader = false;
  AppDetailsModel? appDetailsModel;
  NotificationsModel notificationsModel = NotificationsModel();
// var fullScreenUser = useState<ZoomVideoSdkUser?>(null);
// List<String> docForumsList=["sdsd","sdsd",];
  bool forumLoader = false;
  bool forumSearchLoader = false;
  ForumListModel? forumListModel;
  ForumListModel? publicForumSearchResultsModel;
  ForumDetailsModel? forumDetailsModel;

  forumDetailsScreenDispose() {
    forumSearchLoader = false;
    forumDetailsModel = null;
    forumLoader = false;
  }

  searchForum(
      {required String keyword, bool? isRefresh, bool? isSelfForums}) async {
    if (publicForumSearchResultsModel == null ||
        (publicForumSearchResultsModel!.currentPage != null &&
            publicForumSearchResultsModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.publicForumSearch;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (publicForumSearchResultsModel?.currentPage == null ||
          isRefresh == true) {
        // docForumsList = [];
        publicForumSearchResultsModel = ForumListModel(publicForums: []);
        await Future.delayed(const Duration(milliseconds: 50));
        forumSearchLoader = true;
        notifyListeners();
      }

      Map<String, dynamic> data = {
        "search": keyword,

        "page": publicForumSearchResultsModel?.next ?? 1,
        "forum_type":
            isSelfForums == true ? 2 : 2 // 1 - Doctor related, 2 - All
      };

      dynamic responseData =
          await getIt<DioClient>().post(endpoint, data, tokn);

      if (responseData != null) {
        var result = ForumListModel.fromJson(responseData);
        publicForumSearchResultsModel!.next = result.next;
        publicForumSearchResultsModel!.currentPage = result.currentPage;
        publicForumSearchResultsModel!.publicForums!
            .addAll(result.publicForums ?? []);
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      forumSearchLoader = false;
      notifyListeners();
    }
  }

  disposeForumSearch() {
    publicForumSearchResultsModel = null;
  }

  initFns() async {
    getIt<OnlineConsultManager>().getScheduledBookings(DateTime.now());

    await getIt<OnlineConsultManager>().getPatientRequestList();

    await getIt<HomeManager>().getDoctorAppDetails();
    await getIt<OnlineConsultManager>().getRecentPatientsList();

    getIt<AuthManager>().getUserDetails();

    // getIt<StateManager>().getSoundNotificaitonEnabled();
  }

  getNotifications({
    required int index,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    notificationLoader = true;
    notifyListeners();
    if (index == 1) {
      notificationsModel = NotificationsModel(notifications: []);
    }
    String endpoint = Endpoints.notoficaitonsList;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "page": index,
    };

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      var result = NotificationsModel.fromJson(responseData);
      notificationsModel.notifications!.addAll(result.notifications ?? []);
    }
    notificationLoader = false;

    notifyListeners();
  }

  Future<BasicResponseModel> forumResponseReactionSave(
      {required int forumRespId, required int reaction}) async {
    forumLoader = true;

    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
    String endpoint = Endpoints.forumResponseReactionSave;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {
      "forum_response_id": forumRespId,
      "reaction_type": reaction,
      "flag": null
    };
    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    forumLoader = false;
    notifyListeners();
    if (responseData != null) {
      var resp = BasicResponseModel.fromJson(responseData);
      forumLoader = false;
      notifyListeners();
      return resp;
    } else {
      forumLoader = false;
      notifyListeners();
      return BasicResponseModel(status: true, message: "server Error");
    }
  }

  Future<BasicResponseModel> setOnlineStatus({
    required int index,
  }) async {
    // await Future.delayed(Duration(milliseconds: 50));
    // notificationLoader = true;
    // notifyListeners();
    // if(index==1){
    //   notificationsModel = NotificationsModel(notifications: []);
    // }
    String endpoint = Endpoints.onlineAvailability;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    // Map<String,dynamic> data = {
    //   "status" : index,
    // };

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      var result = BasicResponseModel.fromJson(responseData);
      return result;
    }
    var result =
        BasicResponseModel(status: false, message: "Something went wrong");
    return result;
    // notifyListeners();
  }

  getDoctorAppDetails() async {
    // await Future.delayed(Duration(milliseconds: 50));
    // notificationLoader = true;
    // notifyListeners();
    // if(index==1){
    //   notificationsModel = NotificationsModel(notifications: []);
    // }
    String endpoint = Endpoints.doctorAppDetails;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    // Map<String,dynamic> data = {
    //   "status" : index
    // };

    dynamic responseData = await getIt<DioClient>().get(endpoint, tokn);
    if (responseData != null) {
      appDetailsModel = AppDetailsModel.fromJson(responseData);
    }

    notifyListeners();
  }

  getForumDetails(int forumId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    forumLoader = true;
    notifyListeners();

    String endpoint = Endpoints.doctoRelatedForumDetailView;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"public_forum_id": forumId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      forumDetailsModel = ForumDetailsModel.fromJson(responseData);
    }
    forumLoader = false;
    notifyListeners();
  }

  updateForumRespondedInList(int forumId) {
    for (PublicForums i in forumListModel?.publicForums ?? []) {
      if (i.id == forumId) {
        i.isAlreadyResponded = true;
        i.responsesCount = i.responsesCount != null ? i.responsesCount! + 1 : 1;
      }
    }
    notifyListeners();
  }

  submitForumResponse({
    required String responseText,
    required int? forumId,
    required List<String> imgs,
  }) async {
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    String endpoint = Endpoints.saveDoctorForumFeedback;
    List<MultipartFile> imageFilesData = [];
    for (var i in imgs) {
      imageFilesData
          .add(await MultipartFile.fromFile(i, filename: i.split('/').last));
    }

    final formData = FormData.fromMap({
      "public_forum_id": forumId,
      "response": responseText,
      "file": imageFilesData,
    });

    // Map<String,dynamic> data = {
    //
    // "title":title,
    // "description":description,
    // "treatment_id":treatmentId,
    // "location":"Banglore",
    // "file": null ,
    //
    // };
    dynamic responseData =
        await getIt<DioClient>().post(endpoint, formData, tokn);

    if (responseData != null) {
      var res = BasicResponseModel.fromJson(responseData);
      return res;
    } else {
      return BasicResponseModel(status: false, message: "No Data ");
    }
  }

  saveDoctorForumFeedback(int forumId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    forumLoader = true;
    notifyListeners();

    String endpoint = Endpoints.doctoRelatedForumDetailView;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    Map<String, dynamic> data = {"public_forum_id": forumId};

    dynamic responseData = await getIt<DioClient>().post(endpoint, data, tokn);
    if (responseData != null) {
      forumDetailsModel = ForumDetailsModel.fromJson(responseData);
    }
    forumLoader = false;
    notifyListeners();
  }

  getForumList({
    bool? isRefresh,
  }) async {
    if (forumListModel == null ||
        (forumListModel!.currentPage != null && forumListModel!.next != null) ||
        isRefresh == true) {
      String endpoint = Endpoints.docRelatedForums;
      String tokn =
          getIt<SharedPreferences>().getString(StringConstants.token) ?? "";
      if (forumListModel?.currentPage == null || isRefresh == true) {
        // docForumsList = [];
        forumListModel = ForumListModel(publicForums: []);
      }
      await Future.delayed(const Duration(milliseconds: 50));
      forumLoader = true;
      notifyListeners();

      Map<String, dynamic> data = {
        "page": forumListModel?.next ?? 1,
        "forum_type": 1 // "Upcoming" || "Previous" || "Cancelled"
      };

      dynamic responseData =
          await getIt<DioClient>().post(endpoint, data, tokn);

      if (responseData != null) {
        var result = ForumListModel.fromJson(responseData);
        forumListModel!.next = result.next;
        forumListModel!.publicForums!.addAll(result.publicForums ?? []);
        notifyListeners();
      } else {
        // return SymptomsAndIssuesModel(status: false);
      }
      forumLoader = false;
      notifyListeners();
    }
  }

  notificationStatusChange() async {
    // await Future.delayed(Duration(milliseconds: 50));
    // notificationLoader = true;
    // notifyListeners();
    // if(index==1){
    //   notificationsModel = NotificationsModel(notifications: []);
    // }
    String endpoint = Endpoints.updateNotificationStatus;
    String tokn =
        getIt<SharedPreferences>().getString(StringConstants.token) ?? "";

    // Map<String,dynamic> data = {
    //   "status" : index
    // };

    await getIt<DioClient>().get(endpoint, tokn);
    // if (responseData != null) {
    //   appDetailsModel = AppDetailsModel.fromJson(responseData);
    //
    // }

    // notifyListeners();
  }
}
