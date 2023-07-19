import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/utils/Logger.dart';
import 'package:lively_studio/widgets/loader.dart';
import '../config/const.dart';

class NetworkRequest {
  static const headers = {
    'Authorization': 'Bearer ${ConfigGetter.JWT_TOKEN}',
    'Content-Type': 'application/json'
  };
  Future<void> getCall(String route, RequestCallbacks requestCallbacks) async {
    Logger.log("url $API_ENDPOINT$route");
    try {
      final response = await http.get(
        Uri.parse(API_ENDPOINT + route),
        headers: headers
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        requestCallbacks.onSuccess(responseData);
      } else {
        requestCallbacks.onError(response.body);
      }
      Loader.hide();
    } catch (e) {
      Loader.hide();
    }
  }

  Future<void> postCall(String route, dynamic requestBody,
      RequestCallbacks requestCallbacks) async {
    Logger.log("url $API_ENDPOINT$route\n $requestBody");
    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT + route),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        requestCallbacks.onSuccess(responseData);
      } else {
        requestCallbacks.onError(response.body);
      }
      Loader.hide();
    } catch (e) {
      Loader.hide();
    }
  }

  loginCall(String route, dynamic requestBody,
      RequestCallbacks requestCallbacks) async {
    Logger.log("url $API_ENDPOINT$route\n $requestBody");

    try {
      final response = await http.post(
        Uri.parse(API_ENDPOINT + route),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      if (response.statusCode == 200) {
        final responseData = response.body;
        requestCallbacks.onSuccess(responseData);
      } else {
        requestCallbacks.onError(response.body);
      }
      Loader.hide();
    } catch (e) {
      Loader.hide();
    }
  }
}
