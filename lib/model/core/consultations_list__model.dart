class ConsultaitionsModel {
  bool? status;
  String? message;
  List<Consultations>? consultations;
  int? totalBookingCount;
  int? next;
  // Null? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  ConsultaitionsModel(
      {this.status,
      this.message,
      this.consultations,
      this.totalBookingCount,
      // this.next,
      // this.previous,
      this.currentPage,
      this.totalPages,
      this.pageSize});

  ConsultaitionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['consultations'] != null) {
      consultations = <Consultations>[];
      json['consultations'].forEach((v) {
        consultations!.add(Consultations.fromJson(v));
      });
    }
    totalBookingCount = json['total_booking_count'];
    next = json['next'];
    // previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (consultations != null) {
      data['consultations'] = consultations!.map((v) => v.toJson()).toList();
    }
    data['total_booking_count'] = totalBookingCount;
    data['next'] = next;
    // data['previous'] = this.previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class Consultations {
  int? id;
  int? doctorId;
  bool? isFreeFollowupActive;
  String? doctorImage;
  String? bookingStatus;
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
  String? patientAge;
  bool? isAlreadyFollowedUp;
  bool? isAFreeFollowupBooking;

  Consultations(
      {this.id,
      this.doctorId,
      this.isFreeFollowupActive,
      this.doctorImage,
      this.doctorFirstName,
      this.bookingStatus,
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
      this.patientAge,
      this.isAlreadyFollowedUp,
      this.isAFreeFollowupBooking});

  Consultations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    isFreeFollowupActive = json['is_free_followup_active'];
    doctorImage = json['doctor_image'];
    bookingStatus = json['booking_status'];
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
    patientAge = json['patient_age'];
    isAlreadyFollowedUp = json['is_already_followed_up'];
    isAFreeFollowupBooking = json['is_a_free_followup_booking'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['is_free_followup_active'] = isFreeFollowupActive;
    data['doctor_image'] = doctorImage;
    data['booking_status'] = bookingStatus;
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
    data['patient_age'] = patientAge;
    data['is_already_followed_up'] = isAlreadyFollowedUp;
    data['is_a_free_followup_booking'] = isAFreeFollowupBooking;
    return data;
  }
}
