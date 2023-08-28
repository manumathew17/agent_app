class VideoCallRequest {
  VideoCallRequest({
    required this.action,
    required this.message,
    required this.token,
  });

  late String action;
  late Message message;
  late String token;
  late String ROOM_ID;
  late final bool forwarded;

  VideoCallRequest.fromJson(Map<String, dynamic> json) {
    action = json['action'] ?? "NA";
    message = Message.fromJson(json['message']);
    token = json['token'];
    forwarded = json['forwarded'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['action'] = action;
    _data['message'] = message.toJson();
    _data['token'] = token;
    return _data;
  }
}

class Message {
  Message({
    required this.requestType,
    required this.userInfo,
    required this.productInfo,
  });

  late final String requestType;
  late final UserInfo userInfo;
  late final ProductInfo productInfo;

  Message.fromJson(Map<String, dynamic> json) {
    requestType = json['requestType'];
    userInfo = UserInfo.fromJson(json['userInfo']);
    productInfo = ProductInfo.fromJson(json['product_info']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['requestType'] = requestType;
    _data['userInfo'] = userInfo.toJson();
    _data['product_info'] = productInfo.toJson();
    return _data;
  }
}

class UserInfo {
  UserInfo({
    required this.userName,
    required this.userID,
    required this.mobileNo,
  });

  late final String userName;
  late final String userID;
  late final String mobileNo;

  UserInfo.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userID = json['userID'];
    mobileNo = json['mobile_no'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['userName'] = userName;
    _data['userID'] = userID;
    _data['mobile_no'] = mobileNo;
    return _data;
  }
}

class ProductInfo {
  ProductInfo({
    required this.productUrl,
  });

  late final String productUrl;

  ProductInfo.fromJson(Map<String, dynamic> json) {
    productUrl = json['product_url'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['product_url'] = productUrl;
    return _data;
  }
}
