import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lively_studio/model/model_location.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/utils/Logger.dart';

import '../model/model_product.dart';
import '../network/request_route.dart';

class CatalogProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();

  List<Product> productList = [];
  List<Product> filteredProductList = [];
  bool isLoading = true;

  List<Location> companyLocation = [];
  List<Location> filteredLocation = [];

  getCompanyLocation() {
    requestRouter.getWareHouses(
        null, RequestCallbacks(onSuccess: (response) => _createWareHouseList(response), onError: (error) => {Logger.log(error)}));
  }

  getProductsList() {
    final queryParams = {"limit": "100"};
    requestRouter.getProductList(
        queryParams, RequestCallbacks(onSuccess: (response) => _createList(response), onError: (error) => {Logger.log(error)}));
  }

  search(String query) {
    filteredProductList = productList.where((product) {
      final String name = product.product.toLowerCase();
      final String searchQuery = query.toLowerCase();
      return name.contains(searchQuery);
    }).toList();

    notifyListeners();
  }

  void filterLocations(String searchString) {
    filteredLocation = companyLocation.where((location) {
      Map<String, dynamic> locationJson = location.toJson();

      for (var value in locationJson.values) {
        if (value.toString().toLowerCase().contains(searchString.toLowerCase())) {
          return true;
        }
      }
      return false;
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

  _createWareHouseList(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data'];
    companyLocation = data.map((item) => Location.fromJson(item)).toList();
    filteredLocation = companyLocation;
    notifyListeners();
  }
}
