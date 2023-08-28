import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/Logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../config/const.dart';
import '../config/getter.dart';
import '../model/model_video_call_request.dart';
import '../utils/general.dart';
import '../utils/notification/notification_controller.dart';

class WebSocketProvider extends ChangeNotifier {
  RequestRouter requestRouter = RequestRouter();
  late VideoCallRequest videoCallRequest;
  late IOWebSocketChannel webSocketChannel;
  bool isWebSocketConnected = false;
  Timer? _timer;
  bool showVideoCallInfo = false;
  bool isButtonDisabled = false;
  late VoidCallback onJoinCallPressed;

  String room_id = '';
  String customer_id = '';
  String customer_token = '';
  String call_token = '';
  bool isInstantCall = true;

  updateRoomStatus(status) {}

  generateRoomId(VoidCallback onJoinCallPressed) {
    isButtonDisabled = true;
    notifyListeners();
    this.onJoinCallPressed = onJoinCallPressed;
    final requestBody = {
      "userDetails": {
        "userName": videoCallRequest.message.userInfo.userName,
        "mobile_no": videoCallRequest.message.userInfo.mobileNo,
        "email": "yettodo@todo.com"
      },
      "agentDetails": {"userName": ConfigGetter.USERDETAILS.userId},
      "product_info": {"product_url": videoCallRequest.message.productInfo.productUrl}
    };

    requestRouter.generateRoomId(
        requestBody,
        RequestCallbacks(
            onSuccess: (response) => {generateCallToken(response)},
            onError: (error) {
              isButtonDisabled = false;
              notifyListeners();
            }));
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
          isButtonDisabled = false;
          notifyListeners();
        }));
  }

  showVideoCallRingDialog(Map<String, dynamic> response) {
    ConfigGetter.isCallAttended = false;
    Map<String, dynamic> jsonDataMap = response;
    isInstantCall = true;

    videoCallRequest = VideoCallRequest.fromJson(jsonDataMap);
    call_token = videoCallRequest.token;
    showVideoCallInfo = true;
    _startTimer();
    _timer?.cancel();
    clearCallRequestData();
    notifyListeners();
  }

  hideVideoCallRingDialog() {
    showVideoCallInfo = false;
    isButtonDisabled = false;
    onJoinCallPressed();
    notifyListeners();
  }

  initialiseWebSocket() async {
    if (isWebSocketConnected) {
      return;
    }

    webSocketChannel = IOWebSocketChannel.connect('$WEB_SOCKET_URL?id=${ConfigGetter.USERDETAILS.userId}&type=cms');

    webSocketChannel.stream.listen(
      (data) {
        print('Incoming message: $data');
      },
      onDone: () {
        isWebSocketConnected = false;
        print('WebSocket connection closed');
      },
      onError: (error) {
        isWebSocketConnected = false;
      },
    );

    isWebSocketConnected = true;
  }

  fcmNotificationInit() async {
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

      showVideoCallRingDialog(jsonDecode(message.data["data"]));
      NotificationController.createNewNotification();
      GeneralUtils.notificationVibrate();

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  sendMessageViaSocket() {
    final message = {
      "action": "sendMessage",
      "message": {"status": "success", "roomId": videoCallRequest.ROOM_ID},
      "to": videoCallRequest.message.userInfo.userID,
      "token": videoCallRequest.token
    };

    sendWebSocketMessage(message);

    hideVideoCallRingDialog();
  }

  sendMessageForCallForwarding(String warehouse_uuid) {
    final message = {
      "action": "sendMessage",
      "message": {"status": "success", "type": "forwardCall", "warehouse_uuid": warehouse_uuid},
      "to": videoCallRequest.message.userInfo.userID,
      "token": videoCallRequest.token
    };

    sendWebSocketMessage(message);
    //hideVideoCallRingDialog();
  }

  sendWebSocketMessage(Map<String, Object> message) {
    initialiseWebSocket();
    webSocketChannel.sink.add(jsonEncode(message).toString());
  }

  _startTimer() {
    Future.delayed(const Duration(seconds: WAIT_TIME), () {
      closeVideoCallOverlay();
    });
  }

  closeVideoCallOverlay(){
    showVideoCallInfo = false;
    isButtonDisabled = false;

    _timer?.cancel();

    notifyListeners();
  }


  Future<void> checkData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String notificationData = prefs.getString(PREF_NOTIFICATION) ?? "";
    String savedTimeString = prefs.getString(PREF_CALL_TIME) ?? "";

    if (notificationData != "" && savedTimeString != "") {
      DateTime savedTime = DateTime.parse(savedTimeString);
      DateTime currentTime = DateTime.now();

      Duration difference = currentTime.difference(savedTime);

      if (difference.inSeconds <= 30) {
        showVideoCallRingDialog(json.decode(notificationData));
      } else {
        clearCallRequestData();
      }
    }
  }

  Future<void> checkNotification() async {
    const duration = Duration(seconds: 1);
    _timer?.cancel();

    _timer = Timer.periodic(duration, (timer) {
      checkData();
    });
  }

  clearCallRequestData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    _timer?.cancel();

    await prefs.remove(PREF_NOTIFICATION);
    await prefs.remove(PREF_CALL_TIME);
  }
}
