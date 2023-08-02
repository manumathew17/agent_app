import 'dart:convert';

class MissedCall {
  String id;
  String companyId;
  int callStatus;
  String callType;
  String startTime;
  String endTime;
  String customerName;
  String customerMobileNo;
  String productUrl;
  bool isUserInformed;
  String customerUuid;
  String createdAt;
  String updatedAt;
  int v;

  MissedCall({
    this.id = "NA",
    this.companyId = "NA",
    this.callStatus = 0,
    this.callType = "NA",
    this.startTime = "NA",
    this.endTime = "NA",
    this.customerName = "NA",
    this.customerMobileNo = "NA",
    this.productUrl = "NA",
    this.isUserInformed = false,
    this.customerUuid = "NA",
    this.createdAt = "NA",
    this.updatedAt = "NA",
    this.v = 0,
  });

  factory MissedCall.fromJson(Map<String, dynamic> json) {
    return MissedCall(
      id: json['_id'] ?? "NA",
      companyId: json['company_id'] ?? "NA",
      callStatus: json['call_status'] ?? 0,
      callType: json['call_type'] ?? "NA",
      startTime: json['start_time'] ?? "NA",
      endTime: json['end_time'] ?? "NA",
      customerName: json['customer_name'] ?? "NA",
      customerMobileNo: json['customer_mobile_no'] ?? "NA",
      productUrl: json['product_url'] ?? "NA",
      isUserInformed: json['is_user_informed'] ?? false,
      customerUuid: json['customer_uuid'] ?? "NA",
      createdAt: json['createdAt'] ?? "NA",
      updatedAt: json['updatedAt'] ?? "NA",
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'company_id': companyId,
      'call_status': callStatus,
      'call_type': callType,
      'start_time': startTime,
      'end_time': endTime,
      'customer_name': customerName,
      'customer_mobile_no': customerMobileNo,
      'product_url': productUrl,
      'is_user_informed': isUserInformed,
      'customer_uuid': customerUuid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
