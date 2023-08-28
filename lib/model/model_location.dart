class Location {
  String id;
  String name;
  String warehouseUuid;
  String companyId;
  String companyFkId;
  String pinCode;
  String address;

  Location({
    required this.id,
    required this.name,
    required this.warehouseUuid,
    required this.companyId,
    required this.companyFkId,
    required this.pinCode,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        id: json['_id'] ?? "NA",
        name: json['name'] ?? "NA",
        warehouseUuid: json['warehouse_uuid'] ?? "NA",
        companyId: json['company_id'] ?? "NA",
        companyFkId: json['company_fk_id'] ?? "NA",
        pinCode: json['pin_code'] ?? "NA",
        address: json['address'] ?? "NA");
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'warehouse_uuid': warehouseUuid,
      'company_id': companyId,
      'company_fk_id': companyFkId,
      'pin_code': pinCode,
      'address': address
    };
  }

  @override
  String toString() {
    return 'Location{id: $id, name: $name, warehouseUuid: $warehouseUuid, companyId: $companyId, companyFkId: $companyFkId, pinCode: $pinCode, address: $address}';
  }
}
