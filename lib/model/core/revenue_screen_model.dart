import 'package:dqueuedoc/model/core/analytics_model.dart';

class RevenueModel {
  bool? status;
  String? startDate;
  String? endDate;
  String? message;
  PatientDetails? patientDetails;

  RevenueModel(
      {this.status,
      this.startDate,
      this.endDate,
      this.patientDetails,
      this.message});

  RevenueModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    patientDetails = json['patient_details'] != null
        ? PatientDetails.fromJson(json['patient_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    if (patientDetails != null) {
      data['patient_details'] = patientDetails!.toJson();
    }
    return data;
  }
}

class PatientDetails {
  int? totalPatientsCount;
  List<DailyPatientCount>? dailyPatientCount;
  String? totalWeeklyRevenue;

  PatientDetails(
      {this.totalPatientsCount,
      this.dailyPatientCount,
      this.totalWeeklyRevenue});

  PatientDetails.fromJson(Map<String, dynamic> json) {
    totalPatientsCount = json['total_patients_count'];
    if (json['daily_patient_count'] != null) {
      dailyPatientCount = <DailyPatientCount>[];
      json['daily_patient_count'].forEach((v) {
        dailyPatientCount!.add(DailyPatientCount.fromJson(v));
      });
    }
    totalWeeklyRevenue = json['total_weekly_revenue']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_patients_count'] = totalPatientsCount;
    if (dailyPatientCount != null) {
      data['daily_patient_count'] =
          dailyPatientCount!.map((v) => v.toJson()).toList();
    }
    data['total_weekly_revenue'] = totalWeeklyRevenue;
    return data;
  }
}
