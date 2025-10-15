class PatientDetailsModel {
  bool? status;
  String? message;
  UserDetails? userDetails;
  BookingDetails? bookingDetails;

  PatientDetailsModel(
      {this.status, this.message, this.userDetails, this.bookingDetails});

  PatientDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    bookingDetails = json['booking_details'] != null
        ? BookingDetails.fromJson(json['booking_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    if (bookingDetails != null) {
      data['booking_details'] = bookingDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? language;
  String? patientReferenceId;
  int? id;
  int? userId;
  int? appUserId;
  String? age;
  String? height;
  String? weight;
  String? bloodGroup;
  String? bloodSugar;
  String? bloodPressure;
  String? serumCreatinine;
  List<String>? pastMedicationDetails;
  List<Documents>? documents;

  UserDetails(
      {this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.gender,
      this.maritalStatus,
      this.language,
      this.patientReferenceId,
      this.id,
      this.userId,
      this.appUserId,
      this.age,
      this.height,
      this.weight,
      this.bloodGroup,
      this.bloodSugar,
      this.bloodPressure,
      this.serumCreatinine,
      this.pastMedicationDetails,
      this.documents});

  UserDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    language = json['language'];
    patientReferenceId = json['patient_reference_id'];
    id = json['id'];
    userId = json['user_id'];
    appUserId = json['app_user_id'];
    age = json['age']?.toString();
    height = json['height']?.toString();
    weight = json['weight']?.toString();
    bloodGroup = json['blood_group']?.toString();
    bloodSugar = json['blood_sugar']?.toString();
    bloodPressure = json['blood_pressure']?.toString();
    serumCreatinine = json['serum_creatinine']?.toString();
    // if (json['past_medication_details'] != null) {
    //   pastMedicationDetails = <String>[];
    //   json['past_medication_details'].forEach((v) {
    //     pastMedicationDetails!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['documents'] != null) {
    //   documents = <Null>[];
    //   json['documents'].forEach((v) {
    //     documents!.add(new Null.fromJson(v));
    //   });
    // }
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
    data['app_user_id'] = appUserId;
    data['age'] = age;
    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['blood_sugar'] = bloodSugar;
    data['blood_pressure'] = bloodPressure;
    data['serum_creatinine'] = serumCreatinine;
    //   if (this.pastMedicationDetails != null) {
    //     data['past_medication_details'] =
    //         this.pastMedicationDetails!.map((v) => v.toJson()).toList();
    //   }
    //   if (this.documents != null) {
    //     data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    //   }
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  int? id;
  String? file;
  String? typeOfFile;
  String? createdDate;

  Documents({this.id, this.file, this.typeOfFile, this.createdDate});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    typeOfFile = json['type_of_file'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['type_of_file'] = typeOfFile;
    data['created_date'] = createdDate;
    return data;
  }
}

class QnsAnswersModel {
  bool? status;
  String? message;
  List<Questionnaire>? questionnaire;

  QnsAnswersModel({this.status, this.message, this.questionnaire});

  QnsAnswersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['questionnaire'] != null) {
      questionnaire = <Questionnaire>[];
      json['questionnaire'].forEach((v) {
        questionnaire!.add(Questionnaire.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (questionnaire != null) {
      data['questionnaire'] = questionnaire!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questionnaire {
  int? id;
  int? userAttendedMaster;
  String? questionnaire;
  String? descriptiveAnswer;
  List<Options>? options;

  Questionnaire(
      {this.id,
      this.userAttendedMaster,
      this.questionnaire,
      this.descriptiveAnswer,
      this.options});

  Questionnaire.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userAttendedMaster = json['user_attended_master'];
    questionnaire = json['questionnaire'];
    descriptiveAnswer = json['descriptive_answer'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_attended_master'] = userAttendedMaster;
    data['questionnaire'] = questionnaire;
    data['descriptive_answer'] = descriptiveAnswer;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? id;
  int? userAttendedQuestionnaire;
  String? option;

  Options({this.id, this.userAttendedQuestionnaire, this.option});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userAttendedQuestionnaire = json['user_attended_questionnaire'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_attended_questionnaire'] = userAttendedQuestionnaire;
    data['option'] = option;
    return data;
  }
}

class BookingDetails {
  int? id;
  int? doctorId;
  String? doctorImage;
  String? doctorFirstName;
  String? doctorLastname;
  String? doctorQualification;
  String? date;
  String? time;
  String? appointmentId;
  int? specialityId;
  String? speciality;
  String? bookingType;
  int? patientId;
  String? patientFirstName;
  String? patientLastname;
  String? patientGender;
  String? clinicName;
  String? clinicAddress1;
  String? clinicAddress2;
  String? clinicCity;
  String? clinicState;
  String? clinicCountry;
  String? clinicPincode;
  String? clinicLatitude;
  String? clinicLongitude;
  String? bookingStartTime;
  String? bookingEndTime;
  String? callStatus;
  String? patientAge;
  int? cancellationStatus;

  BookingDetails(
      {this.id,
      this.doctorId,
      this.doctorImage,
      this.doctorFirstName,
      this.doctorLastname,
      this.doctorQualification,
      this.date,
      this.time,
      this.appointmentId,
      this.specialityId,
      this.speciality,
      this.bookingType,
      this.patientId,
      this.patientFirstName,
      this.patientLastname,
      this.patientGender,
      this.clinicName,
      this.clinicAddress1,
      this.clinicAddress2,
      this.clinicCity,
      this.clinicState,
      this.clinicCountry,
      this.clinicPincode,
      this.clinicLatitude,
      this.clinicLongitude,
      this.bookingStartTime,
      this.bookingEndTime,
      this.callStatus,
      this.patientAge,
      this.cancellationStatus});

  BookingDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    doctorImage = json['doctor_image'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastname = json['doctor_lastname'];
    doctorQualification = json['doctor_qualification'];
    date = json['date'];
    time = json['time'];
    appointmentId = json['appointment_id'];
    specialityId = json['speciality_id'];
    speciality = json['speciality'];
    bookingType = json['booking_type'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientLastname = json['patient_lastname'];
    patientGender = json['patient_gender'];
    clinicName = json['clinic_name'];
    clinicAddress1 = json['clinic_address1'];
    clinicAddress2 = json['clinic_address2'];
    clinicCity = json['clinic_city'];
    clinicState = json['clinic_state'];
    clinicCountry = json['clinic_country'];
    clinicPincode = json['clinic_pincode'];
    clinicLatitude = json['clinic_latitude']?.toString();
    clinicLongitude = json['clinic_longitude']?.toString();
    bookingStartTime = json['booking_start_time'];
    bookingEndTime = json['booking_end_time'];
    callStatus = json['call_status'];
    patientAge = json['patient_age'];
    cancellationStatus = json['cancellation_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['doctor_image'] = doctorImage;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_lastname'] = doctorLastname;
    data['doctor_qualification'] = doctorQualification;
    data['date'] = date;
    data['time'] = time;
    data['appointment_id'] = appointmentId;
    data['speciality_id'] = specialityId;
    data['speciality'] = speciality;
    data['booking_type'] = bookingType;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_lastname'] = patientLastname;
    data['patient_gender'] = patientGender;
    data['clinic_name'] = clinicName;
    data['clinic_address1'] = clinicAddress1;
    data['clinic_address2'] = clinicAddress2;
    data['clinic_city'] = clinicCity;
    data['clinic_state'] = clinicState;
    data['clinic_country'] = clinicCountry;
    data['clinic_pincode'] = clinicPincode;
    data['clinic_latitude'] = clinicLatitude;
    data['clinic_longitude'] = clinicLongitude;
    data['booking_start_time'] = bookingStartTime;
    data['booking_end_time'] = bookingEndTime;
    data['call_status'] = callStatus;
    data['patient_age'] = patientAge;
    data['cancellation_status'] = cancellationStatus;
    return data;
  }
}
