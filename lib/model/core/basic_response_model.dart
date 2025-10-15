class BasicResponseModel {
  bool? status;
  String? message;
  String? file;

  // Map<String,dynamic>? data;


  BasicResponseModel({this.status, this.message,this.file,
    // this.data
  });

  BasicResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    file = json['file'];
    message = json['message'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['file'] = file;

    return data;
  }
}

class BasicResponseModel2 {
  bool? status;
  String? message;
  String? prescription;

  // Map<String,dynamic>? data;


  BasicResponseModel2({this.status, this.message,this.prescription,
    // this.data
  });

  BasicResponseModel2.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    prescription = json['prescription'];
    message = json['message'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['prescription'] = prescription;
    data['message'] = message;

    return data;
  }
}


class BasicResponseModel3 {
  bool? status;
  String? message;
  String? prescriptionImg;

  // Map<String,dynamic>? data;


  BasicResponseModel3({this.status, this.message,this.prescriptionImg,
    // this.data
  });

  BasicResponseModel3.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    prescriptionImg = json['prescription_image'];
    message = json['message'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['prescription_image'] = prescriptionImg;
    data['message'] = message;

    return data;
  }
}


class SingleDrugItem {
  int? id;
  String? name;

  // Map<String,dynamic>? data;


  SingleDrugItem({this.id, this.name,
    // this.data
  });

  SingleDrugItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;

    return data;
  }
}



class BasicListItem {
  int? id;
  String? item;

  // Map<String,dynamic>? data;


  BasicListItem({this.id, this.item,
    // this.data
  });

  BasicListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item = json['item'].toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item'] = item;

    return data;
  }
}






