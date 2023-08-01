class UserDetail {
  String companyId;
  String userId;
  String companyName;
  String token;
  String website;
  String websiteId;

  UserDetail({
    required this.companyId,
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
      userId: json['user_id'],
      companyName: json['company_name'],
      token: json['token'],
      website: json['website'],
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
