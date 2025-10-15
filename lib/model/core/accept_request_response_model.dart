class AcceptPatientReqModel {
  bool? status;
  String? message;
  String? appointmentId;
  int? bookingId;
  PatientData? patientDetails;

  AcceptPatientReqModel(
      {this.status,
      this.message,
      this.appointmentId,
      this.bookingId,
      this.patientDetails});

  AcceptPatientReqModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    appointmentId = json['appointment_id'];
    bookingId = json['booking_id'];
    patientDetails = json['patient_details'] != null
        ? PatientData.fromJson(json['patient_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['appointment_id'] = appointmentId;
    data['booking_id'] = bookingId;
    if (patientDetails != null) {
      data['patient_details'] = patientDetails!.toJson();
    }
    return data;
  }
}

class PatientData {
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? language;
  String? patientReferenceId;
  int? id;
  int? userId;
  int? patientId;
  String? age;
  String? height;
  String? weight;
  String? bloodGroup;

  List<PastMedicationDetails>? pastMedicationDetails;
  List<Documents>? documents;

  PatientData(
      {this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.gender,
      this.maritalStatus,
      this.language,
      this.patientReferenceId,
      this.id,
      this.userId,
      this.patientId,
      this.age,
      this.height,
      this.weight,
      this.bloodGroup,
      this.pastMedicationDetails,
      this.documents});

  PatientData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    language = json['language'];
    patientReferenceId = json['patient_reference_id'];
    id = json['id'];
    userId = json['user_id'];
    patientId = json['patient_id'];
    age = json['age'];
    height = json['height']?.toString();
    weight = json['weight']?.toString();
    bloodGroup = json['blood_group'];
    if (json['past_medication_details'] != null) {
      pastMedicationDetails = <PastMedicationDetails>[];
      json['past_medication_details'].forEach((v) {
        pastMedicationDetails!.add(PastMedicationDetails.fromJson(v));
      });
    }
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
    data['patient_reference_id'] = patientReferenceId;
    data['id'] = id;
    data['user_id'] = userId;
    data['patient_id'] = patientId;
    data['age'] = age;
    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;

    if (pastMedicationDetails != null) {
      data['past_medication_details'] =
          pastMedicationDetails!.map((v) => v.toJson()).toList();
    }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PastMedicationDetails {
  int? id;
  String? title;

  PastMedicationDetails({this.id, this.title});

  PastMedicationDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
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
