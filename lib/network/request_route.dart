import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_engine.dart';

class RequestRouter {
  final NetworkRequest _networkRequest = NetworkRequest();

  void validateUser(dynamic requestBody, RequestCallbacks requestCallbacks) {
    _networkRequest.loginCall('user/login', requestBody, requestCallbacks);
  }

  updateFcmToken(Map<String, dynamic> requestBody, RequestCallbacks requestCallbacks) {
    _networkRequest.putCall("user/fcm_token", requestBody, requestCallbacks);
  }

  getCurrencyCode(RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("company/info", null, requestCallbacks);
  }

  getScheduledCall(Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("schedulecall/status/active", queryParams, requestCallbacks);
  }

  getProductList(Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("products", queryParams, requestCallbacks);
  }

  generateRoomId(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("call/video/generate/room", postBody, requestCallbacks);
  }

  getAllCustomerByAgent(Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("conferenceUsers/agent/wise", queryParams, requestCallbacks);
  }

  getCallHistory(Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("schedulecall/call/history", queryParams, requestCallbacks);
  }

  generateCallToken(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("call/video/generate/call-token", postBody, requestCallbacks);
  }

  updateCallStatus(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("schedulecall/instant-call/update", postBody, requestCallbacks);
  }

  getMissedCall(Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("conferenceUsers/missed/calls", queryParams, requestCallbacks);
  }

  updateOnlineStatus(Map<String, dynamic> putBody, RequestCallbacks requestCallbacks) {
    _networkRequest.putCall("user/change/status", putBody, requestCallbacks);
  }

  getCustomerDetails(Map<String, dynamic> queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("conferenceUsers/customer/details", queryParams, requestCallbacks);
  }

  updateCustomerDetails(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("conferenceUsers/update-conference-user", postBody, requestCallbacks);
  }

  updateUser(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("user/update-user", postBody, requestCallbacks);
  }

  getAgentTiming(RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("user/call-agent-time", null, requestCallbacks);
  }

  callInvitation(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("schedulecall/call-invitation", postBody, requestCallbacks);
  }

  getUserOnlineStatus(RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("user/status", null, requestCallbacks);
  }

  updateScheduledCallStatus(Map<String, dynamic> postBody, RequestCallbacks requestCallbacks) {
    _networkRequest.postCall("schedulecall/update", postBody, requestCallbacks);
  }

  getWareHouses(Map<String, dynamic>? queryParams, RequestCallbacks requestCallbacks) {
    _networkRequest.getCall("company/warehouses", queryParams, requestCallbacks);
  }
}
