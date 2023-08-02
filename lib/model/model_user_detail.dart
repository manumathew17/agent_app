class UserDetail {
  String companyId;
  String user_name;
  String userId;
  String companyName;
  String token;
  String website;
  String websiteId;

  UserDetail({
    required this.companyId,
    required this.user_name,
    required this.userId,
    required this.companyName,
    required this.token,
    required this.website,
    required this.websiteId,
  });

  // Factory method to create an instance of the modal class from JSON data
  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      companyId: json['company_id'],
      user_name: json['user_name'] ?? "NA",
      userId: json['user_id'] ?? "NA",
      companyName: json['company_name'] ?? "NA",
      token: json['token'] ?? "NA",
      website: json['website'] ?? "NA",
      websiteId: json['website_id'].toString(),
    );
  }

  // Method to convert the modal class instance to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'user_id': userId,
      'company_name': companyName,
      'token': token,
      'website': website,
      'website_id': websiteId,
    };
  }
}
