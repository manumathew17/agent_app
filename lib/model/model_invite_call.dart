class InviteCall {
  String userId;
  String userName;
  String companyId;
  int callStatus;
  String callType;
  String startTime;
  String endTime;
  String customerName;
  String customerMobileNo;
  String productUrl;
  bool isUserInformed;
  String source;
  String roomId;
  String customerUuid;
  String startTimeFormatted;
  String id;
  String createdAt;
  String updatedAt;
  int v;
  String meetLink;

  InviteCall({
    required this.userId,
    required this.userName,
    required this.companyId,
    required this.callStatus,
    required this.callType,
    required this.startTime,
    required this.endTime,
    required this.customerName,
    required this.customerMobileNo,
    required this.productUrl,
    required this.isUserInformed,
    required this.source,
    required this.roomId,
    required this.customerUuid,
    required this.startTimeFormatted,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.meetLink,
  });

  factory InviteCall.fromJson(Map<String, dynamic> json) {
    return InviteCall(
      userId: json['user_id'] ?? "NA",
      userName: json['user_name'] ?? "NA",
      companyId: json['company_id'] ?? "NA",
      callStatus: json['call_status'] ?? 0,
      callType: json['call_type'] ?? "NA",
      startTime: json['start_time'] ?? "NA",
      endTime: json['end_time'] ?? "NA",
      customerName: json['customer_name'] ?? "NA",
      customerMobileNo: json['customer_mobile_no'] ?? "NA",
      productUrl: json['product_url'] ?? "NA",
      isUserInformed: json['is_user_informed'] ?? false,
      source: json['source'] ?? "NA",
      roomId: json['room_id'] ?? "NA",
      customerUuid: json['customer_uuid'] ?? "NA",
      startTimeFormatted: json['start_time_formatted'] ?? "NA",
      id: json['_id'] ?? "NA",
      createdAt: json['createdAt'] ?? "NA",
      updatedAt: json['updatedAt'] ?? "NA",
      v: json['__v'] ?? 0,
      meetLink: json['meet_link'] ?? "NA",
    );
  }

  String getMeetCode() {
    String code = meetLink.split("li/").last;
    return code;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'company_id': companyId,
      'call_status': callStatus,
      'call_type': callType,
      'start_time': startTime,
      'end_time': endTime,
      'customer_name': customerName,
      'customer_mobile_no': customerMobileNo,
      'product_url': productUrl,
      'is_user_informed': isUserInformed,
      'source': source,
      'room_id': roomId,
      'customer_uuid': customerUuid,
      'start_time_formatted': startTimeFormatted,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'meet_link': meetLink,
    };
  }
}
