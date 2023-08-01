class CustomerData {
  List<String> productUrls;
  int noOfCalls;
  String customerName;
  String customerMobileNo;
  String customerUuid;

  CustomerData({
    required this.productUrls,
    required this.noOfCalls,
    required this.customerName,
    required this.customerMobileNo,
    required this.customerUuid,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      productUrls: List<String>.from(json['product_urls'] ?? []),
      noOfCalls: json['no_of_calls'] ?? '0',
      customerName: json['customer_name'] ?? "NA",
      customerMobileNo: json['customer_mobile_no'] ?? 'NA',
      customerUuid: json['customer_uuid'] ?? 'NA',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_urls': productUrls,
      'no_of_calls': noOfCalls,
      'customer_name': customerName,
      'customer_mobile_no': customerMobileNo,
      'customer_uuid': customerUuid,
    };
  }
}
