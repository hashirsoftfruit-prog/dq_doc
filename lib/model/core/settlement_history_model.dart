class SettlementHistoryModel {
  bool? status;
  String? message;
  List<Settlements>? settlements;
  int? count;
  // Null? next;
  // Null? previous;
  int? currentPage;
  int? totalPages;
  int? pageSize;

  SettlementHistoryModel(
      {this.status,
      this.message,
      this.settlements,
      this.count,
      // this.next,
      // this.previous,
      this.currentPage,
      this.totalPages,
      this.pageSize});

  SettlementHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['settlements'] != null) {
      settlements = <Settlements>[];
      json['settlements'].forEach((v) {
        settlements!.add(Settlements.fromJson(v));
      });
    }
    count = json['count'];
    // next = json['next'];
    // previous = json['previous'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (settlements != null) {
      data['settlements'] = settlements!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    // data['next'] = this.next;
    // data['previous'] = this.previous;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    data['page_size'] = pageSize;
    return data;
  }
}

class Settlements {
  int? id;
  int? doctor;
  String? startDate;
  String? endDate;
  String? doctorRevenue;
  String? transactionId;
  String? settledDate;
  String? settlementNote;
  String? totalConsultationAmount;
  String? totalAmountPaid;
  int? packageOptedBookings;
  int? freeBookings;
  int? freeFollowupBookings;
  int? discountAvailedBookings;
  String? discountAvailedAmount;
  int? couponAppliedBookings;
  String? couponAppliedAmount;
  int? doctorId;
  String? doctorFirstName;
  String? doctorLastName;

  Settlements(
      {this.id,
      this.doctor,
      this.startDate,
      this.endDate,
      this.doctorRevenue,
      this.transactionId,
      this.settledDate,
      this.settlementNote,
      this.totalConsultationAmount,
      this.totalAmountPaid,
      this.packageOptedBookings,
      this.freeBookings,
      this.freeFollowupBookings,
      this.discountAvailedBookings,
      this.discountAvailedAmount,
      this.couponAppliedBookings,
      this.couponAppliedAmount,
      this.doctorId,
      this.doctorFirstName,
      this.doctorLastName});

  Settlements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctor = json['doctor'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    doctorRevenue = json['doctor_revenue']?.toString();
    transactionId = json['transaction_id'];
    settledDate = json['settled_date'];
    settlementNote = json['settlement_note'];
    totalConsultationAmount = json['total_consultation_amount']?.toString();
    totalAmountPaid = json['total_amount_paid']?.toString();
    packageOptedBookings = json['package_opted_bookings'];
    freeBookings = json['free_bookings'];
    freeFollowupBookings = json['free_followup_bookings'];
    discountAvailedBookings = json['discount_availed_bookings'];
    discountAvailedAmount = json['discount_availed_amount']?.toString();
    couponAppliedBookings = json['coupon_applied_bookings'];
    couponAppliedAmount = json['coupon_applied_amount']?.toString();
    doctorId = json['doctor_id'];
    doctorFirstName = json['doctor_first_name'];
    doctorLastName = json['doctor_last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['doctor'] = doctor;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['doctor_revenue'] = doctorRevenue;
    data['transaction_id'] = transactionId;
    data['settled_date'] = settledDate;
    data['settlement_note'] = settlementNote;
    data['total_consultation_amount'] = totalConsultationAmount;
    data['total_amount_paid'] = totalAmountPaid;
    data['package_opted_bookings'] = packageOptedBookings;
    data['free_bookings'] = freeBookings;
    data['free_followup_bookings'] = freeFollowupBookings;
    data['discount_availed_bookings'] = discountAvailedBookings;
    data['discount_availed_amount'] = discountAvailedAmount;
    data['coupon_applied_bookings'] = couponAppliedBookings;
    data['coupon_applied_amount'] = couponAppliedAmount;
    data['doctor_id'] = doctorId;
    data['doctor_first_name'] = doctorFirstName;
    data['doctor_last_name'] = doctorLastName;
    return data;
  }
}
