import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_engine.dart';

class RequestRouter {
  final NetworkRequest _networkRequest = NetworkRequest();

  void validateUser(dynamic requestBody, RequestCallbacks requestCallbacks) {
    _networkRequest.loginCall('user/login', requestBody, requestCallbacks);
  }
}
