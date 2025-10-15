import 'package:dqueuedoc/model/core/basic_response_model.dart';

import 'drug_params_model.dart';

class PrescriptionModel {
  int? bookingId;
  String? height;
  String? weight;
  String? bloodGroup;
  String? allergy;
  String? pastMedHistory;
  List<BasicListItem>? pastMedications;
  String? complaints;
  String? observations;
  List<String>? diagnosis;
  List<int>? existingLabTestList;
  List<String>? newLabTestList;
  List<BasicListItem>? labTestList;
  String? labTestRemark;
  List<DrugItem> drugsList = [];
  String? doctorNote;
  String? doctorInstructions;

  PrescriptionModel(
      {this.bookingId,
      this.height,
      this.weight,
      this.allergy,
      this.pastMedHistory,
      this.pastMedications,
      this.bloodGroup,
      this.complaints,
      this.observations,
      this.diagnosis,
      this.existingLabTestList,
      this.newLabTestList,
      this.labTestRemark,
      required this.drugsList,
      this.doctorNote,
      this.doctorInstructions});

  PrescriptionModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    height = json['height'];
    allergy = json['allergy'];
    pastMedHistory = json['pastMedHistory'];
    pastMedications = json['pastMedications'];
    weight = json['weight'];
    bloodGroup = json['blood_group'];
    complaints = json['complaints'];
    observations = json['observations'];
    diagnosis = json['diagnosis'].cast<String>();
    existingLabTestList = json['existing_lab_test_list'].cast<int>();
    newLabTestList = json['new_lab_test_list'].cast<String>();
    labTestRemark = json['lab_test_remark'];
    if (json['drugs_list'] != null) {
      drugsList = <DrugItem>[];
      json['drugs_list'].forEach((v) {
        drugsList.add(DrugItem.fromJson(v));
      });
    } else {
      drugsList = <DrugItem>[];
    }
    doctorNote = json['doctor_note'];
    doctorInstructions = json['doctor_instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['height'] = height;
    data['allergy'] = allergy;
    data['pastMedHistory'] = pastMedHistory;
    data['pastMedications'] = pastMedications;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['complaints'] = complaints;
    data['observations'] = observations;
    data['diagnosis'] = diagnosis;
    data['existing_lab_test_list'] = existingLabTestList;
    data['new_lab_test_list'] = newLabTestList;
    data['lab_test_remark'] = labTestRemark;
    data['drugs_list'] = drugsList.map((v) => v.toJson()).toList();
    data['doctor_note'] = doctorNote;
    data['doctor_instructions'] = doctorInstructions;
    return data;
  }
}

class DrugItem {
  BasicListItem? drug;
  Param? drugType;
  int? duration;
  FixedInterval? fixedInterval;
  VariableInterval? variableInterval;

  // Param? morningDosage;
  // Param? afternoonDosage;
  // Param? eveningDosage;
  // Param? nightDosage;
  Param? drugUnit;
  String? instructions;

  DrugItem(
      {this.drug,
      this.fixedInterval,
      this.drugType,
      this.variableInterval,
      this.duration,
      // this.morningDosage,
      // this.afternoonDosage,
      // this.eveningDosage,
      // this.nightDosage,
      this.drugUnit,
      this.instructions});

  DrugItem.fromJson(Map<String, dynamic> json) {
    fixedInterval = json['fixed_interval'] != null
        ? FixedInterval.fromJson(json['fixed_interval'])
        : null;
    variableInterval = json['variable_interval'] != null
        ? VariableInterval.fromJson(json['variable_interval'])
        : null;

    drug = json['drug'];
    drugType = json['drug_type'];
    duration = json['duration'];
    // morningDosage = json['morning_dosage'];
    // afternoonDosage = json['afternoon_dosage'];
    // eveningDosage = json['evening_dosage'];
    // nightDosage = json['night_dosage'];
    drugUnit = json['drug_unit'];
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (fixedInterval != null) {
      data['fixed_interval'] = fixedInterval!.toJson();
    }
    if (variableInterval != null) {
      data['variable_interval'] = variableInterval!.toJson();
    }
    data['drug'] = drug;
    data['drug_type'] = drugType;
    data['duration'] = duration;
    // data['"morning_dosage"'] = this.morningDosage;
    // data['afternoon_dosage'] = this.afternoonDosage;
    // data['evening_dosage'] = this.eveningDosage;
    // data['night_dosage'] = this.nightDosage;
    data['drug_unit'] = drugUnit;
    data['instructions'] = instructions;
    return data;
  }
}

class FixedInterval {
  Param? morningDosage;
  Param? afternoonDosage;
  Param? eveningDosage;
  Param? nightDosage;
  String? intervalType;

  FixedInterval({
    this.morningDosage,
    this.afternoonDosage,
    this.eveningDosage,
    this.nightDosage,
    this.intervalType,
  });

  FixedInterval.fromJson(Map<String, dynamic> json) {
    intervalType = json['interval_type'];

    morningDosage = json['morning_dosage'] != null
        ? Param.fromJson(json['morning_dosage'])
        : null;
    afternoonDosage = json['afternoon_dosage'] != null
        ? Param.fromJson(json['afternoon_dosage'])
        : null;
    eveningDosage = json['evening_dosage'] != null
        ? Param.fromJson(json['evening_dosage'])
        : null;
    nightDosage = json['night_dosage'] != null
        ? Param.fromJson(json['night_dosage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (morningDosage != null) {
      data['morning_dosage'] = morningDosage!.toJson();
    }
    if (afternoonDosage != null) {
      data['afternoon_dosage'] = afternoonDosage!.toJson();
    }
    if (eveningDosage != null) {
      data['evening_dosage'] = eveningDosage!.toJson();
    }
    if (nightDosage != null) {
      data['night_dosage'] = nightDosage!.toJson();
    }
    data['interval_type'] = intervalType;

    return data;
  }
}

class VariableInterval {
  double? dosage;
  int? interval;
  String? intervalType;
  String? durationType;

  VariableInterval(
      {this.dosage, this.interval, this.intervalType, this.durationType});

  VariableInterval.fromJson(Map<String, dynamic> json) {
    dosage = json['dosage'];
    durationType = json['duration_type'];
    interval = json['interval'];
    intervalType = json['interval_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dosage'] = dosage;
    data['interval'] = interval;
    data['interval_type'] = intervalType;
    data['duration_type'] = durationType;
    return data;
  }
}
