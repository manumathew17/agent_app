class CompanyDetail {
  String companyName;
  String url;
  String companyId;
  DateTime createdAt;
  DateTime updatedAt;
  Currency currency;
  Website website;
  CallPluginConfiguration callPluginConfiguration;
  String brandLogo;
  String backgroundImage;

  CompanyDetail({
    required this.companyName,
    required this.url,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
    required this.website,
    required this.callPluginConfiguration,
    required this.brandLogo,
    required this.backgroundImage,
  });

  // Factory method to create an instance of the modal class from JSON data
  factory CompanyDetail.fromJson(Map<String, dynamic> json) {
    return CompanyDetail(
      companyName: json['company_name'],
      url: json['url'],
      companyId: json['company_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      currency: Currency.fromJson(json['currency']),
      website: Website.fromJson(json['website']),
      callPluginConfiguration: CallPluginConfiguration.fromJson(json['call_plugin_configuration']),
      brandLogo: json['brand_logo'],
      backgroundImage: json['background_image'],
    );
  }
}

class Currency {
  String currencyName;
  String currencyCode;
  String currencyHtmlCode;

  Currency({
    required this.currencyName,
    required this.currencyCode,
    required this.currencyHtmlCode,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyName: json['currency_name'],
      currencyCode: json['currency_code'],
      currencyHtmlCode: json['currency_html_code'],
    );
  }
}

class Website {
  String id;
  int type;
  DateTime createdAt;
  DateTime updatedAt;

  Website({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      id: json['_id'],
      type: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class CallPluginConfiguration {
  String id;
  String buttonDisplay;
  String color;
  String fontFamily;

  CallPluginConfiguration({
    required this.id,
    required this.buttonDisplay,
    required this.color,
    required this.fontFamily,
  });

  factory CallPluginConfiguration.fromJson(Map<String, dynamic> json) {
    return CallPluginConfiguration(
      id: json['_id'],
      buttonDisplay: json['button_display'],
      color: json['color'],
      fontFamily: json['font_family'],
    );
  }
}
