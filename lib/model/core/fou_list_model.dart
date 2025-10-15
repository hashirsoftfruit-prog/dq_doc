class ForumListModel {
  bool? status;
  String? message;
  List<PublicForums>? publicForums;
  int? count;
  int? next;
  int? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  ForumListModel(
      {this.status,
      this.message,
      this.publicForums,
      this.count,
      this.next,
      this.previous,
      this.currentPage,
      this.totalPages,
      this.pageSize});

  ForumListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['public_forums'] != null) {
      publicForums = <PublicForums>[];
      json['public_forums'].forEach((v) {
        publicForums!.add(PublicForums.fromJson(v));
      });
    }
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (publicForums != null) {
      data['public_forums'] = publicForums!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class PublicForums {
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
  int? responsesCount;
  // List<Files>? files;

  PublicForums({
    this.id,
    this.title,
    this.description,
    this.treatmentType,
    this.userType,
    this.isAlreadyResponded,
    this.forumUser,
    this.forumStatus,
    this.viewCount,
    this.age,
    this.city,
    this.fullName,
    this.userImage,
    this.forumCreatedDate,
    this.responsesCount,
    // this.files
  });

  PublicForums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    treatmentType = json['treatment_type'];
    userType = json['user_type'];
    forumUser = json['forum_user'];
    forumStatus = json['forum_status'];

    isAlreadyResponded = json['is_already_responded'];

    viewCount = json['view_count'];
    age = json['age'];
    city = json['city'];
    fullName = json['full_name'];
    userImage = json['user_image'];
    forumCreatedDate = json['forum_created_date'];
    responsesCount = json['responses_count'];
    // if (json['files'] != null) {
    //   files = <Files>[];
    //   json['files'].forEach((v) {
    //     files!.add(new Files.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['treatment_type'] = treatmentType;

    data['is_already_responded'] = isAlreadyResponded;
    data['user_type'] = userType;
    data['forum_user'] = forumUser;
    data['forum_status'] = forumStatus;
    data['view_count'] = viewCount;
    data['age'] = age;
    data['city'] = city;
    data['full_name'] = fullName;
    data['user_image'] = userImage;
    data['forum_created_date'] = forumCreatedDate;
    data['responses_count'] = responsesCount;
    // data['files'] = this.files;
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
