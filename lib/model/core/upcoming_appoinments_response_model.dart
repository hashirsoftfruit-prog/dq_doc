class UpcomingBookingsModel {
  bool? status;
  String? message;
  List<UpcomingAppointments>? upcomingAppointments;

  UpcomingBookingsModel({this.status, this.message, this.upcomingAppointments});

  UpcomingBookingsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['appointments'] != null) {
      upcomingAppointments = <UpcomingAppointments>[];
      json['appointments'].forEach((v) {
        upcomingAppointments!.add(UpcomingAppointments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (upcomingAppointments != null) {
      data['appointments'] = upcomingAppointments!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class UpcomingAppointments {
  int? id;
  int? doctorId;
  String? doctorFirstName;
  String? doctorLastname;
  String? date;
  String? time;
  String? speciality;
  String? subSpeciality;
  String? bookingType;
  int? patientId;
  String? patientFirstName;
  String? appointmentId;
  String? patientLastname;
  String? patientGender;
  String? patientAge;
  String? bookingStartTime;
  String? bookingEndTime;
  String? bookingStatus;

  UpcomingAppointments({
    this.id,
    this.doctorId,
    this.doctorFirstName,
    this.doctorLastname,
    this.date,
    this.time,
    this.speciality,
    this.appointmentId,
    this.bookingType,
    this.patientId,
    this.bookingStatus,
    this.patientFirstName,
    this.patientLastname,
    this.patientGender,
    this.bookingStartTime,
    this.bookingEndTime,
    this.subSpeciality,
    this.patientAge,
  });

  UpcomingAppointments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctor_id'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastname = json['doctor_lastname'];
    appointmentId = json['appointment_id'];
    date = json['date'];
    time = json['time'];
    speciality = json['speciality'];
    subSpeciality = json['subspeciality'];
    bookingType = json['booking_type'];
    patientId = json['patient_id'];
    patientFirstName = json['patient_first_name'];
    patientLastname = json['patient_lastname'];
    patientGender = json['patient_gender'];
    bookingStatus = json['booking_status'];
    patientAge = json['patient_age']?.toString();
    bookingStartTime = json['booking_start_time'];
    bookingEndTime = json['booking_end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor_id'] = doctorId;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_lastname'] = doctorLastname;
    data['date'] = date;
    data['appointment_id'] = appointmentId;
    data['time'] = time;
    data['speciality'] = speciality;
    data['subspeciality'] = subSpeciality;
    data['booking_type'] = bookingType;
    data['booking_start_time'] = bookingStartTime;
    data['booking_end_time'] = bookingEndTime;
    data['patient_id'] = patientId;
    data['patient_first_name'] = patientFirstName;
    data['patient_lastname'] = patientLastname;
    data['patient_gender'] = patientGender;
    data['booking_status'] = bookingStatus;
    data['patient_age'] = patientAge;
    return data;
  }
}
