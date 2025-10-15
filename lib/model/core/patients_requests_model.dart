class PatientsRequestsModel {
  bool? status;
  String? message;
  List<PatientDetails>? patientDetails;

  PatientsRequestsModel({this.status, this.message, this.patientDetails});

  PatientsRequestsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['patient_details'] != null) {
      patientDetails = <PatientDetails>[];
      json['patient_details'].forEach((v) {
        patientDetails!.add(PatientDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (patientDetails != null) {
      data['patient_details'] = patientDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PatientDetails {
  int? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? appoinmentId;
  int? age;

  PatientDetails(
      {this.id,
      this.firstName,
      this.lastName,
      this.gender,
      this.age,
      this.appoinmentId});

  PatientDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    appoinmentId = json['appointment_id'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['age'] = age;
    data['appointment_id'] = appoinmentId;
    return data;
  }
}
