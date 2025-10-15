class AnalyticsModel {
  bool? status;
  PatientDt? patientDetails;
  List<CountryCounts>? countryCounts;
  AgeRanges? ageRanges;
  String? totalDoctorRevenue;
  String? totalSettledAmount;
  String? amountToSettle;

  AnalyticsModel(
      {this.status,
      this.patientDetails,
      this.countryCounts,
      this.totalDoctorRevenue,
      this.amountToSettle,
      this.totalSettledAmount,
      this.ageRanges});

  AnalyticsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalSettledAmount = json['total_settlement_amount']?.toString();
    totalDoctorRevenue = json['total_doctor_revenue']?.toString();
    amountToSettle = json['amount_to_settle']?.toString();
    patientDetails = json['patient_details'] != null
        ? PatientDt.fromJson(json['patient_details'])
        : null;
    if (json['country_counts'] != null) {
      countryCounts = <CountryCounts>[];
      json['country_counts'].forEach((v) {
        countryCounts!.add(CountryCounts.fromJson(v));
      });
    }
    ageRanges = json['age_ranges'] != null
        ? AgeRanges.fromJson(json['age_ranges'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_settlement_amount'] = totalSettledAmount;
    data['amount_to_settle'] = amountToSettle;
    data['total_doctor_revenue'] = totalDoctorRevenue;
    if (patientDetails != null) {
      data['patient_details'] = patientDetails!.toJson();
    }
    if (countryCounts != null) {
      data['country_counts'] =
          countryCounts!.map((v) => v.toJson()).toList();
    }
    if (ageRanges != null) {
      data['age_ranges'] = ageRanges!.toJson();
    }
    return data;
  }
}

class PatientDt {
  int? totalPatientsCount;
  bool? progressStatusFromLastWeek;
  String? percentageChangeFromLastWeek;
  List<DailyPatientCount>? dailyPatientCount;
  double? totalWeeklyRevenue;

  PatientDt(
      {this.totalPatientsCount,
      this.progressStatusFromLastWeek,
      this.percentageChangeFromLastWeek,
      this.dailyPatientCount,
      this.totalWeeklyRevenue});

  PatientDt.fromJson(Map<String, dynamic> json) {
    totalPatientsCount = json['total_patients_count'];
    progressStatusFromLastWeek = json['progress_status_from_last_week'];
    percentageChangeFromLastWeek =
        json['percentage_change_from_last_week']?.toString();
    if (json['daily_patient_count'] != null) {
      dailyPatientCount = <DailyPatientCount>[];
      json['daily_patient_count'].forEach((v) {
        dailyPatientCount!.add( DailyPatientCount.fromJson(v));
      });
    }
    totalWeeklyRevenue = json['total_weekly_revenue'] != null
        ? double.parse(json['total_weekly_revenue'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_patients_count'] = totalPatientsCount;
    data['progress_status_from_last_week'] = progressStatusFromLastWeek;
    data['percentage_change_from_last_week'] =
        percentageChangeFromLastWeek;
    if (dailyPatientCount != null) {
      data['daily_patient_count'] =
          dailyPatientCount!.map((v) => v.toJson()).toList();
    }
    data['total_weekly_revenue'] = totalWeeklyRevenue;
    return data;
  }
}

class DailyPatientCount {
  String? weekday;
  String? date;
  int? dailyBookingsCount;
  double? dailyRevenue;

  DailyPatientCount(
      {this.weekday, this.date, this.dailyBookingsCount, this.dailyRevenue});

  DailyPatientCount.fromJson(Map<String, dynamic> json) {
    weekday = json['weekday'];
    date = json['Date'];
    dailyBookingsCount = json['daily_bookings_count'];
    dailyRevenue = json['daily_revenue'] != null
        ? double.tryParse(json['daily_revenue'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekday'] = weekday;
    data['Date'] = date;
    data['daily_bookings_count'] = dailyBookingsCount;
    data['daily_revenue'] = dailyRevenue;
    return data;
  }
}

class CountryCounts {
  String? name;
  int? value;

  CountryCounts({this.name, this.value});

  CountryCounts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class AgeRanges {
  int? below15;
  int? i15To30;
  int? above30;

  AgeRanges({this.below15, this.i15To30, this.above30});

  AgeRanges.fromJson(Map<String, dynamic> json) {
    below15 = json['below_15'];
    i15To30 = json['15_to_30'];
    above30 = json['above_30'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['below_15'] = below15;
    data['15_to_30'] = i15To30;
    data['above_30'] = above30;
    return data;
  }
}

class DateIntervals {
  DateIntervals({required this.startDate, required this.endDate});

  DateTime? startDate;

  DateTime? endDate;
}
