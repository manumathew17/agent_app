import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../model/model_call_history.dart';
import '../model/model_call_scheduled.dart';
import '../network/callback.dart';
import '../network/request_route.dart';
import '../utils/Logger.dart';

class CallHistoryProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  List<CallScheduled> callScheduledList = [];
  List<CallHistory> callHistoryList = [];

  void getScheduledCall() async {
    await requestRouter.getScheduledCall(
        null,
        RequestCallbacks(
            onSuccess: (response) => {_createList(response)},
            onError: (error) {
              Logger.log(error);
            }));
  }

  void getCallHistory() async {
    await requestRouter.getCallHistory(
        null, RequestCallbacks(onSuccess: (response) => {_createCallHistoryList(response)},
        onError: (error) => {Logger.log(error)}));
  }

  _createList(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data'];
    List<dynamic> filteredData = data.where((item) => item['call_type'] != 'instant').toList();
    print('jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj');
    print(filteredData[0]);
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
