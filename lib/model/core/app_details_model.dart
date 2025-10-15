class AppDetailsModel {
  bool? status;
  String? message;
  bool? doctorInstantAvailability;
  int? unreadNotificationCount;

  AppDetailsModel(
      {this.status,
        this.message,
        this.doctorInstantAvailability,
        this.unreadNotificationCount});

  AppDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    doctorInstantAvailability = json['doctor_instant_availability'];
    unreadNotificationCount = json['unread_notification_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['doctor_instant_availability'] = doctorInstantAvailability;
    data['unread_notification_count'] = unreadNotificationCount;
    return data;
  }
}
