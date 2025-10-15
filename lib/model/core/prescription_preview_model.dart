class PrescriptionPreviewModel {
  bool? status;
  String? message;
  PrescriptionDetails? prescriptionDetails;

  PrescriptionPreviewModel(
      {this.status, this.message, this.prescriptionDetails});

  PrescriptionPreviewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    prescriptionDetails = json['prescription_details'] != null
        ? PrescriptionDetails.fromJson(json['prescription_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (prescriptionDetails != null) {
      data['prescription_details'] = prescriptionDetails!.toJson();
    }
    return data;
  }
}

class PrescriptionDetails {
  int? id;
  String? patientName;
  String? patientAge;
  String? gender;
  String? address;
  String? complaints;
  String? observations;
  String? instructions;
  String? doctorFirstName;
  String? doctorLastName;
  String? doctorProfessionalQualifications;
  String? doctorCity;
  String? doctorState;
  String? doctorCountry;
  String? height;
  String? weight;
  String? bloodGroup;
  List<Diagnosis>? diagnosis;
  List<Drugs>? drugs;
  List<LabOrders>? labOrders;

  PrescriptionDetails(
      {this.id,
        this.patientName,
        this.patientAge,
        this.gender,
        this.address,
        this.complaints,
        this.observations,
        this.instructions,
        this.height,
        this.doctorFirstName,
        this.weight,
        this.doctorLastName,
        this.bloodGroup,
        this.doctorProfessionalQualifications,
        this.doctorCity,
        this.doctorState,
        this.doctorCountry,
        this.diagnosis,
        this.drugs,
        this.labOrders});

  PrescriptionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientName = json['patient_name'];
    patientAge = json['patient_age'];
    gender = json['gender'];
    address = json['address'];
    height = json['height']?.toString();
    weight = json['weight']?.toString();
    bloodGroup = json['blood_group']?.toString();
    complaints = json['complaints'];
    observations = json['observations'];
    instructions = json['instructions'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
    doctorProfessionalQualifications =
    json['doctor_professional_qualifications'];
    doctorCity = json['doctor_city'];
    doctorState = json['doctor_state'];
    doctorCountry = json['doctor_country'];
    if (json['diagnosis'] != null) {
      diagnosis = <Diagnosis>[];
      json['diagnosis'].forEach((v) {
        diagnosis!.add(Diagnosis.fromJson(v));
      });
    }
    if (json['drugs'] != null) {
      drugs = <Drugs>[];
      json['drugs'].forEach((v) {
        drugs!.add(Drugs.fromJson(v));
      });
    }
    if (json['lab_orders'] != null) {
      labOrders = <LabOrders>[];
      json['lab_orders'].forEach((v) {
        labOrders!.add(LabOrders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_name'] = patientName;
    data['patient_age'] = patientAge;
    data['gender'] = gender;
    data['address'] = address;
    data['complaints'] = complaints;
    data['observations'] = observations;
    data['instructions'] = instructions;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_last_name'] = doctorLastName;
    data['doctor_professional_qualifications'] =
        doctorProfessionalQualifications;
    data['doctor_city'] = doctorCity;
    data['doctor_state'] = doctorState;
    data['doctor_country'] = doctorCountry;
    if (diagnosis != null) {
      data['diagnosis'] = diagnosis!.map((v) => v.toJson()).toList();
    }
    if (drugs != null) {
      data['drugs'] = drugs!.map((v) => v.toJson()).toList();
    }
    if (labOrders != null) {
      data['lab_orders'] = labOrders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diagnosis {
  int? id;
  String? diagnosis;

  Diagnosis({this.id, this.diagnosis});

  Diagnosis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diagnosis = json['diagnosis'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['diagnosis'] = diagnosis;
    return data;
  }
}

class Drugs {
  int? id;
  String? drug;
  String? drugType;
  String? drugUnit;
  bool? dailyMedication;
  String? morningDosage;
  String? afternoonDosage;
  String? eveningDosage;
  String? nightDosage;
  String? dosage;
  String? interval;
  String? intervalType;
  int? duration;
  String? medicineInstruction;
  List<DosageList>? dosageList;

  String? frequencyField;

  Drugs(
      {this.id,
        this.drug,
        this.drugType,
        this.drugUnit,
        this.dailyMedication,
        this.morningDosage,
        this.afternoonDosage,
        this.eveningDosage,
        this.nightDosage,
        this.dosage,
        this.interval,
        this.intervalType,
        this.duration,
        this.medicineInstruction,
        this.dosageList,
        this.frequencyField

      });

  Drugs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drug = json['drug_name'];
    drugType = json['drug_type'];
    drugUnit = json['drug_unit'];
    dailyMedication = json['daily_medication'];
    morningDosage = json['morning_dosage']?.toString();
    afternoonDosage = json['afternoon_dosage']?.toString();
    eveningDosage = json['evening_dosage']?.toString();
    nightDosage = json['night_dosage']?.toString();
    dosage = json['dosage']?.toString();
    interval = json['interval']?.toString();
    intervalType = json['interval_type'];
    duration = json['duration'];
    medicineInstruction = json['medicine_instruction'];
    if (json['dosage_list'] != null) {
      dosageList = <DosageList>[];
      json['dosage_list'].forEach((v) {
        dosageList!.add(DosageList.fromJson(v));
      });
    }
    frequencyField = dailyMedication==true?'$morningDosage -$afternoonDosage -$eveningDosage -$nightDosage $drugUnit  '
        :dailyMedication==false&&interval!=null&&intervalType!=null?'$interval in $intervalType':"-";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['drug_name'] = drug;
    data['drug_type'] = drugType;
    data['drug_unit'] = drugUnit;
    data['daily_medication'] = dailyMedication;
    data['morning_dosage'] = morningDosage;
    data['afternoon_dosage'] = afternoonDosage;
    data['evening_dosage'] = eveningDosage;
    data['night_dosage'] = nightDosage;
    data['dosage'] = dosage;
    data['interval'] = interval;
    data['interval_type'] = intervalType;
    data['duration'] = duration;
    data['medicine_instruction'] = medicineInstruction;
    return data;
  }
}

class DosageList {
  String? time;
  double? dosage;

  DosageList({this.time, this.dosage});

  DosageList.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    dosage = json['dosage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['dosage'] = dosage;
    return data;
  }
}

class LabOrders {
  int? id;
  String? labRemark;
  List<LabTests>? labTests;

  LabOrders({this.id, this.labRemark, this.labTests});

  LabOrders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    labRemark = json['lab_remark'];
    if (json['lab_tests'] != null) {
      labTests = <LabTests>[];
      json['lab_tests'].forEach((v) {
        labTests!.add(LabTests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lab_remark'] = labRemark;
    if (labTests != null) {
      data['lab_tests'] = labTests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LabTests {
  int? id;
  String? labTest;

  LabTests({this.id, this.labTest});

  LabTests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    labTest = json['lab_test'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lab_test'] = labTest;
    return data;
  }
}






class PreviewDrugModel {
  String? drug;
  String? duration;
  String? freq;
  String? instruction;

  PreviewDrugModel({this.drug, this.duration, this.freq, this.instruction});

  PreviewDrugModel.fromJson(Map<String, dynamic> json) {
    drug = json['drug'];
    duration = json['duration'];
    freq = json['freq'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['drug'] = drug;
    data['duration'] = duration;
    data['freq'] = freq;
    data['instruction'] = instruction;
    return data;
  }
}
