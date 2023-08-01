class CallScheduled {
  bool isUserInformed;
  String id;
  String userId;
  String companyId;
  int callStatus;
  String callType;
  String startTime;
  String endTime;
  String customerName;
  String customerMobileNo;
  String productUrl;
  String callDuration;
  String customerUuid;
  String room_id;


  CallScheduled({
    required this.isUserInformed,
    required this.id,
    required this.userId,
    required this.companyId,
    required this.callStatus,
    required this.callType,
    required this.startTime,
    required this.endTime,
    required this.customerName,
    required this.customerMobileNo,
    required this.productUrl,
    required this.callDuration,
    required this.customerUuid,
    required this.room_id,
  });

  factory CallScheduled.fromJson(Map<String, dynamic> json) {
    return CallScheduled(
      isUserInformed: json['is_user_informed'] ?? false,
      id: json['_id'] ?? "",
      userId: json['user_id'] ?? "",
      companyId: json['company_id'] ?? "",
      callStatus: json['call_status'] ?? 0,
      callType: json['call_type'] ?? "",
      startTime: json['start_time'],
      endTime: json['end_time'] ?? "",
      customerName: json['customer_name'] ?? "",
      customerMobileNo: json['customer_mobile_no'] ?? "",
      productUrl: json['product_url'] ?? "",
      callDuration: json['call_duration'] ?? "",
      customerUuid: json['customer_uuid'] ?? "",
      room_id:  json['room_id'] ?? "",
    );
  }
}
