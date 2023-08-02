import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/utils/Logger.dart';
import 'package:web_socket_channel/io.dart';

import '../config/const.dart';
import '../model/model_call_scheduled.dart';
import '../network/request_route.dart';

class HomeProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  List<CallScheduled> callHistoryList = [];
  List<CallScheduled> scheduledCallList = [];
  bool isOnline = false;

  updateOnlineStatus() {
    final putBody = {"online": !isOnline};

    requestRouter.updateOnlineStatus(
        putBody,
        RequestCallbacks(onSuccess: (response) {
          isOnline = !isOnline;

          notifyListeners();
        }, onError: (error) {
          print(error);
        }));
  }

  void getScheduledCall() async {
    await requestRouter.getScheduledCall(
        null,
        RequestCallbacks(
            onSuccess: (response) => {_createList(response)},
            onError: (error) {
              Logger.log(error);
            }));
  }

  _createList(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    List<dynamic> data = jsonDataMap['data'];
    callHistoryList = data.map((item) => CallScheduled.fromJson(item)).toList();
    _getScheduledCall();
  }

  _getScheduledCall() {
    scheduledCallList.clear();
    callHistoryList.forEach((element) {
      if (element.callType != "instant") {
        scheduledCallList.add(element);
      }
    });

    notifyListeners();
  }
}
