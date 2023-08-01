import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/utils/Logger.dart';

import '../model/model_product.dart';
import '../network/request_route.dart';

class CatalogProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();

  List<Product> productList = [];
  List<Product> filteredProductList = [];
  bool isLoading = true;

  getProductsList() {
    requestRouter.getProductList(
        null,
        RequestCallbacks(
            onSuccess: (response) => _createList(response),
            onError: (error) => {Logger.log(error)}));
  }

  search(String query) {
    filteredProductList = productList.where((product) {
      final String name = product.product.toLowerCase();
      final String searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    notifyListeners();
  }

  _createList(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data']['data'];
    productList = data.map((item) => Product.fromJson(item)).toList();
    print(productList);
    filteredProductList = productList;
    isLoading = false;
    notifyListeners();
  }
}
