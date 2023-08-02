class Customer {
  String customerName;
  String customerMobileNo;
  String customerUuid;
  bool isWhatsappSubscribed;

  Customer({
    required this.customerName,
    required this.customerMobileNo,
    required this.customerUuid,
    required this.isWhatsappSubscribed,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerName: json['customer_name'] ?? 'NA',
      customerMobileNo: json['customer_mobile_no'] ?? 'NA',
      customerUuid: json['customer_uuid'] ?? 'NA',
      isWhatsappSubscribed: json['is_whatsapp_subscribed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_mobile_no': customerMobileNo,
      'customer_uuid': customerUuid,
      'is_whatsapp_subscribed': isWhatsappSubscribed,
    };
  }
}
