import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/Logger.dart';

import '../model/model_customer.dart';

class CustomerChatProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  List<CustomerData> customerList = [];

  getAllCustomer() {
    requestRouter.getAllCustomerByAgent(
        null,
        RequestCallbacks(
            onSuccess: (response) => {
                  _createList(response),
                },
            onError: (error) => {}));
  }

  _createList(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data']['customersDetails'];
    customerList = data.map((item) => CustomerData.fromJson(item)).toList();
    notifyListeners();
  }
}
