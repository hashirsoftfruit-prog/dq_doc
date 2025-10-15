import 'basic_response_model.dart';

class PriscriptionSaveModel {
  int? bookingId;
  double? height;
  double? weight;
  String? bloodGroup;
  String? patientName1;
  int? patientAge1;
  String? gender;
  String? address;
  String? allergy;
  String? pastMedicalHistory;
  List<int>? existingPastMedicationList;
  List<String>? newPastMedicationList;
  String? complaints;
  String? observations;
  List<String>? diagnosis;
  List<int>? existingLabTestList;
  List<String>? newLabTestList;
  String? labTestRemark;
  List<DrugsList>? drugsList;
  String? doctorNote;
  String? doctorInstructions;

  PriscriptionSaveModel(
      {this.bookingId,
        this.height,
        this.weight,
        this.bloodGroup,
        this.allergy,
        this.patientName1,
        this.patientAge1,
        this.gender,
        this.address,
        this.pastMedicalHistory,
        this.existingPastMedicationList,
        this.newPastMedicationList,
        this.complaints,
        this.observations,
        this.diagnosis,
        this.existingLabTestList,
        this.newLabTestList,
        this.labTestRemark,
        this.drugsList,
        this.doctorNote,
        this.doctorInstructions});

  PriscriptionSaveModel.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    height = json['height'];
    weight = json['weight'];
    bloodGroup = json['blood_group'];
    patientName1 = json['patient_name'];
    patientAge1 = json['patient_age'];
    gender = json['gender'];
    address = json['address'];
    allergy = json['allergy'];
    pastMedicalHistory = json['past_medical_history'];
    existingPastMedicationList =
        json['existing_past_medication_list'].cast<int>();
    newPastMedicationList = json['new_past_medication_list'].cast<String>();
    complaints = json['complaints'];
    observations = json['observations'];
    diagnosis = json['diagnosis'].cast<String>();
    existingLabTestList = json['existing_lab_test_list'].cast<int>();
    newLabTestList = json['new_lab_test_list'].cast<String>();
    labTestRemark = json['lab_test_remark'];
    if (json['drugs_list'] != null) {
      drugsList = <DrugsList>[];
      json['drugs_list'].forEach((v) {
        drugsList!.add(DrugsList.fromJson(v));
      });
    }
    doctorNote = json['doctor_note'];
    doctorInstructions = json['doctor_instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['height'] = height;
    data['weight'] = weight;
    data['blood_group'] = bloodGroup;
    data['patient_age'] = patientAge1;
    data['patient_name'] = patientName1;
    data['gender'] = gender;
    data['address'] = address;
    data['allergy'] = allergy;
    data['past_medical_history'] = pastMedicalHistory;
    data['existing_past_medication_list'] = existingPastMedicationList;
    data['new_past_medication_list'] = newPastMedicationList;
    data['complaints'] = complaints;
    data['observations'] = observations;
    data['diagnosis'] = diagnosis;
    data['existing_lab_test_list'] = existingLabTestList;
    data['new_lab_test_list'] = newLabTestList;
    data['lab_test_remark'] = labTestRemark;
    if (drugsList != null) {
      data['drugs_list'] = drugsList!.map((v) => v.toJson()).toList();
    }
    data['doctor_note'] = doctorNote;
    data['doctor_instructions'] = doctorInstructions;
    return data;
  }
}

class DrugsList {
  String? dailyMedication;
  SingleDrugItem? drug;
  int? drugTypeId;
  int? drugUnitId;
  double? morningDosage;
  double? afternoonDosage;
  double? eveningDosage;
  double? nightDosage;
  int? duration;
  String? durationType;
  String? medicineInstruction;
  double? dosage;
  int? interval;
  String? intervalType;

  DrugsList(
      {this.dailyMedication,
        this.drug,
        this.drugTypeId,
        this.drugUnitId,
        this.morningDosage,
        this.afternoonDosage,
        this.eveningDosage,
        this.nightDosage,
        this.duration,
        this.durationType,
        this.medicineInstruction,
        this.dosage,
        this.interval,
        this.intervalType});

  DrugsList.fromJson(Map<String, dynamic> json) {
    dailyMedication = json['daily_medication'];
    drug = json['drug'];
    drugTypeId = json['drug_type_id'];
    drugUnitId = json['drug_unit_id'];
    morningDosage = json['morning_dosage'];
    afternoonDosage = json['afternoon_dosage'];
    eveningDosage = json['evening_dosage'];
    nightDosage = json['night_dosage'];
    duration = json['duration'];
    durationType = json['duration_type'];
    medicineInstruction = json['medicine_instruction'];
    dosage = json['dosage'];
    interval = json['interval'];
    intervalType = json['interval_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['daily_medication'] = dailyMedication;
    data['drug'] = drug;
    data['drug_type_id'] = drugTypeId;
    data['drug_unit_id'] = drugUnitId;
    data['morning_dosage'] = morningDosage;
    data['afternoon_dosage'] = afternoonDosage;
    data['evening_dosage'] = eveningDosage;
    data['night_dosage'] = nightDosage;
    data['duration'] = duration;
    data['duration_type'] = durationType;
    data['medicine_instruction'] = medicineInstruction;
    data['dosage'] = dosage;
    data['interval'] = interval;
    data['interval_type'] = intervalType;
    return data;
  }
}







