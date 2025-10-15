class RecentPatientsModel {
  bool? status;
  String? message;
  List<RecentPatients>? recentPatients;

  RecentPatientsModel({this.status, this.message, this.recentPatients});

  RecentPatientsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['recent_patients'] != null) {
      recentPatients = <RecentPatients>[];
      json['recent_patients'].forEach((v) {
        recentPatients!.add(RecentPatients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (recentPatients != null) {
      data['recent_patients'] =
          recentPatients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentPatients {
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? language;
  int? id;
  int? userId;
  int? patientId;
  String? age;
  String? startDateTime;
  String? endDateTime;
  int? bookingId;
  String? appointmentId;
  double? height;
  double? weight;
  String? bloodGroup;
  double? bloodSugar;
  String? bloodPressure;
  String? serumCreatinine;
  List<Documents>? documents;

  RecentPatients(
      {this.firstName,
        this.lastName,
        this.dateOfBirth,
        this.gender,
        this.maritalStatus,
        this.language,
        this.id,
        this.userId,
        this.patientId,
        this.age,
        this.startDateTime,
        this.endDateTime,
        this.bookingId,
        this.appointmentId,
        this.height,
        this.weight,
        this.bloodGroup,
        this.bloodSugar,
        this.bloodPressure,
        this.serumCreatinine,
        this.documents});

  RecentPatients.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    language = json['language'];
    id = json['id'];
    userId = json['user_id'];
    patientId = json['patient_id'];
    age = json['age']?.toString();
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    bookingId = json['booking_id'];
    appointmentId = json['appointment_id'];
    height = json['height']!=null?double.tryParse(json['height'].toString()):null;
    weight = json['weight']!=null?double.tryParse(json['weight'].toString()):null;
    bloodGroup = json['blood_group'];
    bloodSugar = json['blood_sugar']!=null?double.tryParse(json['blood_sugar'].toString()):null;
    bloodPressure = json['blood_pressure'];
    serumCreatinine = json['serum_creatinine']?.toString();
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['marital_status'] = maritalStatus;
    data['language'] = language;
    data['id'] = id;
    data['user_id'] = userId;
    data['patient_id'] = patientId;
    data['age'] = age;
    data['start_date_time'] = startDateTime;
    data['end_date_time'] = endDateTime;
    data['booking_id'] = bookingId;
    data['appointment_id'] = appointmentId;

    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['blood_sugar'] = bloodSugar;
    data['blood_pressure'] = bloodPressure;
    data['serum_creatinine'] = serumCreatinine;

    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  int? id;
  String? file;

  Documents({this.id, this.file});

  Documents.fromJson(Map<String, dynamic> json) {
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



