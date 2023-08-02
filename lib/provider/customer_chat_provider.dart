import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lively_studio/model/model_customer.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/Logger.dart';

import '../model/model_customer_data.dart';

class CustomerChatProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  List<Customer> customerList = [];
  late Customer customer;

  setSelectedCustomer(Customer customer) {
    this.customer = customer;
    notifyListeners();
  }

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

    customerList = data.map((item) => Customer.fromJson(item)).toList();
    notifyListeners();
  }
}
