import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/Logger.dart';
import 'package:web_socket_channel/io.dart';

import '../config/const.dart';
import '../config/getter.dart';
import '../model/model_video_call_request.dart';
import '../utils/general.dart';

class WebSocketProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  late VideoCallRequest videoCallRequest;
  late IOWebSocketChannel webSocketChannel;
  bool showVideoCallInfo = false;
  late VoidCallback onJoinCallPressed;

  String room_id = '';
  String customer_id = '';
  String customer_token = '';
  String call_token = '';

  updateRoomStatus(status) {}

  generateRoomId(VoidCallback onJoinCallPressed) {
    this.onJoinCallPressed = onJoinCallPressed;
    final requestBody = {
      "userDetails": {
        "userName": videoCallRequest.message.userInfo.userName,
        "mobile_no": videoCallRequest.message.userInfo.mobileNo,
        "email": "yettodo@todo.com"
      },
      "agentDetails": {"userName": ConfigGetter.USERDETAILS.userId, "email": ConfigGetter.COMPANY_DETAILS.companyName},
      "product_info": {"product_url": videoCallRequest.message.productInfo.productUrl}
    };

    requestRouter.generateRoomId(
        requestBody, RequestCallbacks(onSuccess: (response) => {generateCallToken(response)}, onError: (error) => {print(error)}));
  }

  generateCallToken(response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response);
    room_id = jsonDataMap['room']['room_id'];
    videoCallRequest.ROOM_ID = room_id;

    final postBody = {
      'userID': ConfigGetter.USERDETAILS.userId,
      'userName': ConfigGetter.USERDETAILS.companyName,
      'room_id': videoCallRequest.ROOM_ID
    };

    requestRouter.generateCallToken(
        postBody,
        RequestCallbacks(onSuccess: (response) {
          sendMessageViaSocket();
        }, onError: (error) {
          print(error);
        }));
  }

  showVideoCallRingDialog(Map<String, dynamic> response) {
    Map<String, dynamic> jsonDataMap = jsonDecode(response["data"]);
    print(jsonDataMap);

    videoCallRequest = VideoCallRequest.fromJson(jsonDataMap);
    call_token = videoCallRequest.token;
    showVideoCallInfo = true;
    notifyListeners();
  }

  hideVideoCallRingDialog() {
    showVideoCallInfo = false;
    onJoinCallPressed();
    notifyListeners();
  }

  weSocketListener() async {
    webSocketChannel = IOWebSocketChannel.connect('$WEB_SOCKET_URL?id=${ConfigGetter.USERDETAILS.userId}&type=cms');
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final requestBody = {
      'fcm_token': fcmToken,
    };

    requestRouter.updateFcmToken(
        requestBody,
        RequestCallbacks(
            onSuccess: (response) => {print(response), print("-----------------------------")},
            onError: (error) => {print(error), print("-----------------------------")}));

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      requestRouter.updateFcmToken(
          requestBody,
          RequestCallbacks(
              onSuccess: (response) => {print(response), print("-----------------------------")},
              onError: (error) => {print(error), print("-----------------------------")}));
    }).onError((err) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      showVideoCallRingDialog(message.data);
      GeneralUtils.notificationVibrate();
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    webSocketChannel.stream.listen(
      (data) {
        // Process incoming message
        print('Incoming message: $data');
      },
      onDone: () {
        // Connection closed
        print('WebSocket connection closed');
      },
      onError: (error) {
        // Handle errors
        print('WebSocket error: $error');
      },
    );
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      webSocketChannel.sink.add('ping'); // Send a ping message
    });
  }

  sendMessageViaSocket() {
    final message = {
      "action": "sendMessage",
      "message": {"status": "success", "roomId": videoCallRequest.ROOM_ID},
      "to": videoCallRequest.message.userInfo.userID,
      "token": videoCallRequest.token
    };

    webSocketChannel.sink.add(jsonEncode(message).toString());
    hideVideoCallRingDialog();
  }
}
