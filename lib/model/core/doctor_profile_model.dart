class DoctorProfileModel {
  bool? status;
  String? message;
  DocDetailsModel? doctors;

  DoctorProfileModel({this.status, this.message, this.doctors});

  DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    doctors = json['doctors'] != null
        ? DocDetailsModel.fromJson(json['doctors'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (doctors != null) {
      data['doctors'] = doctors!.toJson();
    }
    return data;
  }
}

class DocDetailsModel {
  int? id;
  String? image;
  String? firstName;
  String? lastName;
  String? gender;
  String? experience;
  String? qualification;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? email;
  String? clinicName;
  String? clinicLatitude;
  String? clinicLongitude;
  String? onlineStartTime;
  String? onlineEndTime;
  String? offlineStartTime;
  String? offlineEndTime;
  bool? isMultipleClinics;
  List<Clinics>? clinics;
  bool? isMultipleSpecialities;
  List<DoctorSpecialities>? doctorSpecialities;
  String? dateOfBirth;
  String? age;
  String? doctorAge;
  String? doctorCountryCode;
  String? doctorPhone;
  bool? isSoundEnabled;
  List<Education>? education;

  DocDetailsModel(
      {this.id,
      this.image,
      this.firstName,
      this.lastName,
      this.gender,
      this.experience,
      this.qualification,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.country,
      this.email,
      this.clinicName,
      this.clinicLatitude,
      this.clinicLongitude,
      this.onlineStartTime,
      this.onlineEndTime,
      this.offlineStartTime,
      this.offlineEndTime,
      this.isMultipleClinics,
      this.clinics,
      this.isMultipleSpecialities,
      this.doctorSpecialities,
      this.dateOfBirth,
      this.age,
      this.doctorAge,
      this.doctorCountryCode,
      this.doctorPhone,
      this.isSoundEnabled,
      this.education});

  DocDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    experience = json['experience'];
    qualification = json['qualification'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    email = json['email'];
    clinicName = json['clinic_name'];
    clinicLatitude = json['clinic_latitude']?.toString();
    clinicLongitude = json['clinic_longitude']?.toString();
    onlineStartTime = json['online_start_time'];
    onlineEndTime = json['online_end_time'];
    offlineStartTime = json['offline_start_time'];
    offlineEndTime = json['offline_end_time'];
    isMultipleClinics = json['is_multiple_clinics'];

    if (json['clinics'] != null) {
      clinics = <Clinics>[];
      json['clinics'].forEach((v) {
        clinics!.add(Clinics.fromJson(v));
      });
    }
    isMultipleSpecialities = json['is_multiple_specialities'];
    if (json['doctor_specialities'] != null) {
      doctorSpecialities = <DoctorSpecialities>[];
      json['doctor_specialities'].forEach((v) {
        doctorSpecialities!.add(DoctorSpecialities.fromJson(v));
      });
    }
    dateOfBirth = json['date_of_birth'];
    age = json['age']?.toString();
    doctorAge = json['doctor_age'];
    doctorCountryCode = json['doctor_country_code'];
    doctorPhone = json['doctor_phone'];
    if (json['education'] != null) {
      education = <Education>[];
      json['education'].forEach((v) {
        education!.add(Education.fromJson(v));
      });
    }
    isSoundEnabled = json['is_sound_enabled'] is bool
        ? json['is_sound_enabled']
        : (json['is_sound_enabled']?.toString().toLowerCase() == 'true');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['gender'] = gender;
    data['experience'] = experience;
    data['qualification'] = qualification;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['email'] = email;
    data['clinic_name'] = clinicName;
    data['clinic_latitude'] = clinicLatitude;
    data['clinic_longitude'] = clinicLongitude;
    data['online_start_time'] = onlineStartTime;
    data['online_end_time'] = onlineEndTime;
    data['offline_start_time'] = offlineStartTime;
    data['offline_end_time'] = offlineEndTime;
    data['is_multiple_clinics'] = isMultipleClinics;
    if (clinics != null) {
      data['clinics'] = clinics!.map((v) => v.toJson()).toList();
    }
    data['is_multiple_specialities'] = isMultipleSpecialities;
    if (doctorSpecialities != null) {
      data['doctor_specialities'] =
          doctorSpecialities!.map((v) => v.toJson()).toList();
    }
    data['date_of_birth'] = dateOfBirth;
    data['age'] = age;
    data['doctor_age'] = doctorAge;
    data['doctor_country_code'] = doctorCountryCode;
    data['doctor_phone'] = doctorPhone;
    if (education != null) {
      data['education'] = education!.map((v) => v.toJson()).toList();
    }
    data['is_sound_enabled'] = isSoundEnabled;
    return data;
  }
}

class Clinics {
  int? id;
  String? name;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? latitude;
  String? longitude;
  bool? isPrimary;

  Clinics(
      {this.id,
      this.name,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.isPrimary,
      this.country,
      this.latitude,
      this.longitude});

  Clinics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address1 = json['address1'];
    address2 = json['address2'];
    isPrimary = json['is_primary'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address1'] = address1;
    data['address2'] = address2;
    data['city'] = city;
    data['is_primary'] = isPrimary;
    data['state'] = state;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class DoctorSpecialities {
  int? id;
  String? title;
  String? subtitle;
  String? image;

  DoctorSpecialities({this.id, this.title, this.subtitle, this.image});

  DoctorSpecialities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['image'] = image;
    return data;
  }
}

class Education {
  int? id;
  String? specialization;
  String? college;
  String? monthYearOfCompletion;
  String? description;
  String? qualificationLevel;

  Education(
      {this.id,
      this.specialization,
      this.college,
      this.monthYearOfCompletion,
      this.description,
      this.qualificationLevel});

  Education.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialization = json['specialization'];
    college = json['college'];
    monthYearOfCompletion = json['month_year_of_completion'];
    description = json['description'];
    qualificationLevel = json['qualification_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['specialization'] = specialization;
    data['college'] = college;
    data['month_year_of_completion'] = monthYearOfCompletion;
    data['description'] = description;
    data['qualification_level'] = qualificationLevel;
    return data;
  }
}
