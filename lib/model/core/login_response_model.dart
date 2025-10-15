class LoginResponseData {
  bool? status;
  String? message;
  String? token;
  String? username;
  int? userId;
  // Map<String,dynamic>? data;

  LoginResponseData({
    this.status,
    this.message,
    this.userId,
    this.username,
    // this.data
  });

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['doctor_id'];
    message = json['message'].toString();
    username = json['doctor_name'].toString();
    token = json['token_key'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['doctor_id'] = userId;
    data['message'] = message;
    data['doctor_name'] = username;
    data['token_key'] = token;

    return data;
  }
}
