class CustomerData {
  String id;
  int totalCalls;
  List<String> productUrls;
  List<CustomerCall> customerCalls;

  CustomerData({
    required this.id,
    required this.totalCalls,
    required this.productUrls,
    required this.customerCalls,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonProductUrls = json['product_urls'] ?? [];
    List<String> productUrls = List<String>.from(jsonProductUrls);

    List<dynamic> jsonCustomerCalls = json['customer_calls'] ?? [];
    List<CustomerCall> customerCalls = jsonCustomerCalls
        .map((callJson) => CustomerCall.fromJson(callJson))
        .toList();

    return CustomerData(
      id: json['_id'] ?? 'NA',
      totalCalls: json['total_calls'] ?? 0,
      productUrls: productUrls,
      customerCalls: customerCalls,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'total_calls': totalCalls,
      'product_urls': productUrls,
      'customer_calls': customerCalls.map((call) => call.toJson()).toList(),
    };
  }
}

class CustomerCall {
  String id;
  String userId;
  String companyId;
  int callStatus;
  String callType;
  String startTime;
  String endTime;
  String customerName;
  String customerMobileNo;
  String url;
  String roomId;
  String customerUuid;
  String createdAt;
  String updatedAt;
  String? callDuration;
  String meetLink;
  String productUrl;

  CustomerCall({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.callStatus,
    required this.callType,
    required this.startTime,
    required this.endTime,
    required this.customerName,
    required this.customerMobileNo,
    required this.url,
    required this.roomId,
    required this.customerUuid,
    required this.createdAt,
    required this.updatedAt,
    this.callDuration,
    required this.meetLink,
    required this.productUrl,
  });

  factory CustomerCall.fromJson(Map<String, dynamic> json) {
    return CustomerCall(
      id: json['_id'] ?? 'NA',
      userId: json['user_id'] ?? 'NA',
      companyId: json['company_id'] ?? 'NA',
      callStatus: json['call_status'] ?? 0,
      callType: json['call_type'] ?? 'NA',
      startTime: json['start_time'] ?? 'NA',
      endTime: json['end_time'] ?? 'NA',
      customerName: json['customer_name'] ?? 'NA',
      customerMobileNo: json['customer_mobile_no'] ?? 'NA',
      url: json['url'] ?? 'NA',
      roomId: json['room_id'] ?? 'NA',
      customerUuid: json['customer_uuid'] ?? 'NA',
      createdAt: json['createdAt'] ?? 'NA',
      updatedAt: json['updatedAt'] ?? 'NA',
      callDuration: json['call_duration'],
      meetLink: json['meet_link'] ?? 'NA',
      productUrl: json['product_url'] ?? 'NA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'company_id': companyId,
      'call_status': callStatus,
      'call_type': callType,
      'start_time': startTime,
      'end_time': endTime,
      'customer_name': customerName,
      'customer_mobile_no': customerMobileNo,
      'url': url,
      'room_id': roomId,
      'customer_uuid': customerUuid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'call_duration': callDuration,
      'meet_link': meetLink,
      'product_url': productUrl,
    };
  }
}
