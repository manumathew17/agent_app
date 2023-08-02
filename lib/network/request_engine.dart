import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/utils/Logger.dart';
import 'package:lively_studio/widgets/loader.dart';
import 'package:lively_studio/widgets/snackbar.dart';
import '../config/const.dart';
import '../route/route_config.dart';

class NetworkRequest {
  final GeneralSnackBar _generalSnackBar = GeneralSnackBar(navigatorKey.currentContext!);

  static Map<String, String> getHeaders() {
    return {'Authorization': 'Bearer ${ConfigGetter.JWT_TOKEN}', 'Content-Type': 'application/json'};
  }

  Future<void> getCall(String route, Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) async {
    Logger.log(Uri.parse(API_ENDPOINT + route).replace(queryParameters: queryParams));
    try {
      final response = await http.get(Uri.parse(API_ENDPOINT + route).replace(queryParameters: queryParams), headers: getHeaders());

      if (response.statusCode == 200) {
        final responseData = response.body;
        Logger.log(responseData);
        requestCallbacks.onSuccess(responseData.toString());
      } else {
        _showError(response.body);
        requestCallbacks.onError(response.body);
      }
      Loader.hide();
    } catch (e) {
      _showInternetError();
      requestCallbacks.onError(e.toString());
      Loader.hide();
    }
  }

  Future<void> postCall(String route, dynamic requestBody, RequestCallbacks requestCallbacks) async {
    Logger.log("url $API_ENDPOINT$route\n $requestBody");
    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT + route),
        headers: getHeaders(),
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        Logger.log(responseData);
        Loader.hide();
        requestCallbacks.onSuccess(responseData);
      } else {
        Loader.hide();
        print(response.body);
        _showError(response.body);
        requestCallbacks.onError(response.body);
      }
    } catch (e) {
      print(e.toString());
      Loader.hide();
      _showInternetError();
      requestCallbacks.onError(e.toString());
    }
  }

  Future<void> putCall(String route, dynamic requestBody, RequestCallbacks requestCallbacks) async {
    Logger.log("url $API_ENDPOINT$route\n ${jsonEncode(requestBody)}");
    Logger.log("JWT ${ConfigGetter.JWT_TOKEN}");
    try {
      final response = await http.put(
        // Use http.put instead of http.post
        Uri.parse(API_ENDPOINT + route),
        headers: getHeaders(),
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        Logger.log(responseData);
        requestCallbacks.onSuccess(responseData);
      } else {
        _showError(response.body);
        requestCallbacks.onError(response.body);
      }
    } catch (e) {
      _showInternetError();
      requestCallbacks.onError(e.toString());
    }
  }

  loginCall(String route, dynamic requestBody, RequestCallbacks requestCallbacks) async {
    Logger.log("url $API_ENDPOINT$route\n $requestBody");

    try {
      final response =
          await http.post(Uri.parse(API_ENDPOINT + route), body: json.encode(requestBody), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final responseData = response.body;
        print(responseData);
        requestCallbacks.onSuccess(responseData);
      } else {
        _showError(response.body);
        requestCallbacks.onError(response.body);
      }
      Loader.hide();
    } catch (e) {
      _showInternetError();
      Loader.hide();
    }
  }

  _showError(error) {
    Map<String, dynamic> jsonDataMap = jsonDecode(error);
    _generalSnackBar.showErrorSnackBar(jsonDataMap['message']);
  }

  _showInternetError() {
    _generalSnackBar.showErrorSnackBar("Something went wrong");
  }
}
