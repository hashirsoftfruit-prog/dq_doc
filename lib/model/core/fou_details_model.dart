class ForumDetailsModel {
  bool? status;
  String? message;
  ForumDetails? forumDetails;

  ForumDetailsModel({this.status, this.message, this.forumDetails});

  ForumDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    forumDetails = json['forum_details'] != null
        ? ForumDetails.fromJson(json['forum_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (forumDetails != null) {
      data['forum_details'] = forumDetails!.toJson();
    }
    return data;
  }
}






class ForumDetails {
  int? id;
  String? title;
  bool? isAlreadyResponded;

  String? description;
  String? treatmentType;
  String? userType;
  String? forumUser;
  String? forumStatus;
  int? viewCount;
  String? age;
  String? city;
  String? fullName;
  String? userImage;
  String? forumCreatedDate;
  List<Files>? files;
  List<ForumResponseModel>? response;

  ForumDetails(
      {this.id,
        this.title,
        this.description,
        this.treatmentType,
        this.isAlreadyResponded,

        this.userType,
        this.forumUser,
        this.forumStatus,
        this.viewCount,
        this.age,
        this.city,
        this.fullName,
        this.userImage,
        this.forumCreatedDate,
        this.files,
        this.response});

  ForumDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    treatmentType = json['treatment_type'];
    userType = json['user_type'];
    forumUser = json['forum_user'];
    forumStatus = json['forum_status'];
    viewCount = json['view_count'];
    isAlreadyResponded = json['is_already_responded'];

    age = json['age'];
    city = json['city'];
    fullName = json['full_name'];
    userImage = json['user_image'];
    forumCreatedDate = json['forum_created_date'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
    if (json['response'] != null) {
      response = <ForumResponseModel>[];
      json['response'].forEach((v) {
        response!.add(ForumResponseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['is_already_responded'] = isAlreadyResponded;

    data['treatment_type'] = treatmentType;
    data['user_type'] = userType;
    data['forum_user'] = forumUser;
    data['forum_status'] = forumStatus;
    data['view_count'] = viewCount;
    data['age'] = age;
    data['city'] = city;
    data['full_name'] = fullName;
    data['user_image'] = userImage;
    data['forum_created_date'] = forumCreatedDate;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int? id;
  String? file;

  Files({this.id, this.file});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    return data;
  }
}

class ForumResponseModel {
  int? id;
  String? response;
  String? respondedUserType;
  String? file;
  int? likeCount;
  int? dislikeCount;
  bool? isAlreadyFlagged;
  int? isLiked;
  bool? isSelfResponse;
  int? doctor;
  String? doctorName;
  String? doctorImage;
  String? appUser;
  String? appUserName;
  String? appUserImage;
  String? responseCreatedDate;

  ForumResponseModel(
      {this.id,
        this.response,
        this.respondedUserType,
        this.file,
        this.likeCount,
        this.isLiked,
        this.dislikeCount,
        this.isSelfResponse,
        this.isAlreadyFlagged,
        this.doctor,
        this.doctorName,
        this.doctorImage,
        this.appUser,
        this.appUserName,
        this.appUserImage,
        this.responseCreatedDate});

  ForumResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    response = json['response'];
    respondedUserType = json['responded_user_type'];
    file = json['file'];
    likeCount = json['like_count'];
    isLiked = json['is_liked'];
    isSelfResponse = json['self_response'];
    dislikeCount = json['dislike_count'];
    isAlreadyFlagged = json['is_already_flagged'];
    doctor = json['doctor'];
    doctorName = json['doctor_name'];
    doctorImage = json['doctor_image'];
    appUser = json['app_user'];
    appUserName = json['app_user_name'];
    appUserImage = json['app_user_image'];
    responseCreatedDate = json['response_created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['response'] = response;
    data['responded_user_type'] = respondedUserType;
    data['file'] = file;
    data['like_count'] = likeCount;
    data['self_response'] = isSelfResponse;
    data['is_liked'] = isLiked;
    data['dislike_count'] = dislikeCount;
    data['is_already_flagged'] = isAlreadyFlagged;
    data['doctor'] = doctor;
    data['doctor_name'] = doctorName;
    data['doctor_image'] = doctorImage;
    data['app_user'] = appUser;
    data['app_user_name'] = appUserName;
    data['app_user_image'] = appUserImage;
    data['response_created_date'] = responseCreatedDate;
    return data;
  }
}
