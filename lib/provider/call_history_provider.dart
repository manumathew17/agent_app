import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../model/model_call_history.dart';
import '../model/model_call_scheduled.dart';
import '../model/model_missed_call.dart';
import '../network/callback.dart';
import '../network/request_route.dart';
import '../utils/Logger.dart';

class CallHistoryProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  List<CallScheduled> callScheduledList = [];
  List<CallHistory> callHistoryList = [];
  List<MissedCall> callMissedList = [];
  List<CallHistory> todayCallList = [];

  void getScheduledCall() async {
    final queryParams = {
      "self":'true'
    };
    await requestRouter.getScheduledCall(
        queryParams,
        RequestCallbacks(
            onSuccess: (response) => {_createList(response)},
            onError: (error) {
              Logger.log(error);
            }));
  }

   getMissedCall() async {
     final queryParams = {
       "self":'true',
       "limit":"100"
     };
    await requestRouter.getMissedCall(
        queryParams,
        RequestCallbacks(
            onSuccess: (response) {
              _createMissedCallList(response);
            },
            onError: (response) {
              print(response);
            }));
  }

  void getCallHistory() async {
    final queryParams = {
      "self":'true',
      "limit":"100"
    };
    await requestRouter.getCallHistory(
        queryParams, RequestCallbacks(onSuccess: (response) => {_createCallHistoryList(response)}, onError: (error) => {Logger.log(error)}));
  }

  void getTodayCall() {
    DateTime today = DateTime.now();
    DateTime nextDay = today.add(const Duration(days: 1));
    String startDate = DateFormat('yyyy-MM-dd').format(today);
    String endDate = DateFormat('yyyy-MM-dd').format(nextDay);
    final queryParams = {
      "start_date": startDate,
      "end_date" : endDate,
      "limit":"100"
    };

    requestRouter.getCallHistory(queryParams, RequestCallbacks(onSuccess: (response){
      Map<String, dynamic> jsonDataMap = jsonDecode(response);
      List<dynamic> data = jsonDataMap['data']['callHistory'];
      todayCallList = data.map((item) => CallHistory.fromJson(item)).toList();
      notifyListeners();

    }, onError: (error){

    }));

  }

  _createMissedCallList(response) {
    Map<String, dynamic> jsonDatMap = jsonDecode(response);
    List<dynamic> data = jsonDatMap['data']["missed_calls"];
    callMissedList = data.map((item) => MissedCall.fromJson(item)).toList();
    notifyListeners();
  }

  _createList(response) {
    //todo asc by time of schedule call and only show yet to join call entry
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data']['activeScheduleCalls'];
    List<dynamic> filteredData = data.where((item) => item['call_type'] != 'instant').toList();
    callScheduledList = filteredData.map((item) => CallScheduled.fromJson(item)).toList();
    notifyListeners();
  }

  _createCallHistoryList(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data']['callHistory'];
    callHistoryList = data.map((item) => CallHistory.fromJson(item)).toList();
    notifyListeners();
  }
}
