import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:provider/provider.dart';

class VideoCallProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  String room_id = '';
  String customer_id = '';
  String customer_token = '';
  String call_token = '';

  updateRoomStatus(status) {}

  generateRoomId(userParams) async {


    await requestRouter.generateRoomId(
        userParams, RequestCallbacks(onSuccess: (response) => {generateCallToken(response)}, onError: (error) => {print(error)}));
  }

  generateCallToken(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    room_id = jsonDataMap['room']['room_id'];
    final postBody = {'userId': ConfigGetter.USERDETAILS.userId, 'userName': ConfigGetter.USERDETAILS.companyName, 'room_id': room_id};

    requestRouter.generateCallToken(postBody, RequestCallbacks(onSuccess: (response) {
      print(response);


    }, onError: (error) {
      print(error);
    }));
  }
}
