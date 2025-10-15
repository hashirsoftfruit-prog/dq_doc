class DrugParams {
  bool? status;
  String? message;
  List<Param>? drugType;
  List<Param>? drugUnit;
  List<Param>? commonDiagnosis;
  List<Param>? doses;
  List<Drug>? drugs;
  List<Param>? labTest;

  DrugParams(
      {this.status,
      this.message,
      this.drugType,
      this.drugUnit,
      this.labTest,
      this.doses,
      this.drugs,
      this.commonDiagnosis});

  DrugParams.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['drug_type'] != null) {
      drugType = <Param>[];
      json['drug_type'].forEach((v) {
        drugType!.add(Param.fromJson(v));
      });
    }
    if (json['lab_test'] != null) {
      labTest = <Param>[];
      json['lab_test'].forEach((v) {
        labTest!.add(Param.fromJson(v));
      });
    }
    if (json['drugs'] != null) {
      drugs = <Drug>[];
      json['drugs'].forEach((v) {
        drugs!.add(Drug.fromJson(v));
      });
    }
    if (json['drug_unit'] != null) {
      drugUnit = <Param>[];
      json['drug_unit'].forEach((v) {
        drugUnit!.add(Param.fromJson(v));
      });
    }
    if (json['common_diagnosis'] != null) {
      commonDiagnosis = <Param>[];
      json['common_diagnosis'].forEach((v) {
        commonDiagnosis!.add(Param.fromJson(v));
      });
    }
    if (json['doses'] != null) {
      doses = <Param>[];
      json['doses'].forEach((v) {
        doses!.add(Param.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (drugs != null) {
      data['drugs'] = drugs!.map((v) => v.toJson()).toList();
    }
    data['lab_test'] = labTest;
    if (drugType != null) {
      data['drug_type'] = drugType!.map((v) => v.toJson()).toList();
    }
    if (drugUnit != null) {
      data['drug_unit'] = drugUnit!.map((v) => v.toJson()).toList();
    }
    if (commonDiagnosis != null) {
      data['common_diagnosis'] =
          commonDiagnosis!.map((v) => v.toJson()).toList();
    }
    if (doses != null) {
      data['doses'] = doses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Param {
  int? id;
  String? title;

  Param({this.id, this.title});

  Param.fromJson(Map<String, dynamic> json) {
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

class Drug {
  int? id;
  String? title;
  int? drugUnitId;
  String? drugUnitTitle;
  int? drugTypeId;
  String? drugTypeTitle;

  Drug(
      {this.id,
      this.title,
      this.drugUnitId,
      this.drugUnitTitle,
      this.drugTypeId,
      this.drugTypeTitle});

  Drug.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    drugUnitId = json['drug_unit_id'];
    drugUnitTitle = json['drug_unit_title'];
    drugTypeId = json['drug_type_id'];
    drugTypeTitle = json['drug_type_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['drug_unit_id'] = drugUnitId;
    data['drug_unit_title'] = drugUnitTitle;
    data['drug_type_id'] = drugTypeId;
    data['drug_type_title'] = drugTypeTitle;
    return data;
  }
}
