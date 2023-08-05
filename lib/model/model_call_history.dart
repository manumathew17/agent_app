class CallHistory {
  CallHistory({
    required this.id,
    required this.callType,
    required this.customerName,
    required this.productUrl,
    required this.callDuration,
    required this.agentName,
    required this.callDateTime,
    required this.phoneNumber,
    required this.start_time_formatted
  });

  late final String id;
  late final String callType;
  late final String customerName;
  late final String productUrl;
  late final String callDuration;
  late final String agentName;
  late final String callDateTime;
  late final String phoneNumber;
  late final String start_time_formatted;

  CallHistory.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? "";
    callType = json['call_type'] ?? "NA";
    customerName = json['customer_name'] ?? "NA";
    productUrl = json['product_url'] ?? "NA";
    callDuration = json['call_duration'] ?? "NA";
    agentName = json['agent_name'] ?? "NA";
    callDateTime = json['call_date_time'] ?? "NA";
    phoneNumber = json['customer_mobile_no'] ?? "NA";
    start_time_formatted = json['start_time_formatted'] ?? 'NA';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['call_type'] = callType;
    data['customer_name'] = customerName;
    data['product_url'] = productUrl;
    data['call_duration'] = callDuration;
    data['agent_name'] = agentName;
    data['call_date_time'] = callDateTime;
    return data;
  }
}
