class NotificationsModel {
  bool? status;
  String? message;
  List<Notifications>? notifications;
  int? count;
  int? next;
  int? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  NotificationsModel(
      {this.status,
        this.message,
        this.notifications,
        this.count,
        this.next,
        this.previous,
        this.currentPage,
        this.totalPages,
        this.pageSize});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
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
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
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

class Notifications {
  int? id;
  String? title;
  String? body;
  String? image;
  String? module;
  String? dateTime;
  int? moduleId;
  bool? readStatus;

  Notifications(
      {this.id,
        this.title,
        this.body,
        this.image,
        this.module,
        this.moduleId,
        this.dateTime,
        this.readStatus});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    module = json['module'];
    moduleId = json['module_id'];
    dateTime = json['date_time'];
    readStatus = json['read_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['image'] = image;
    data['module'] = module;
    data['module_id'] = moduleId;
    data['date_time'] = dateTime;
    data['read_status'] = readStatus;
    return data;
  }
}
