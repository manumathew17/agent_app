import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:lively_studio/config/const.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> {
  ZegoUIKitPrebuiltCallController? callController;
  RequestRouter requestRouter = RequestRouter();

  _updateRoomStatus(status) async {
    final requestBody = {'token': Provider.of<WebSocketProvider>(context, listen: false).call_token, 'call_status': status};
    requestRouter.updateCallStatus(requestBody, RequestCallbacks(onSuccess: (response) {}, onError: (error) {}));
  }

  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.stop();
    callController = ZegoUIKitPrebuiltCallController();
    _updateRoomStatus(2);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  // }

  @override
  void dispose() {
    super.dispose();

    callController = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: ZegoUIKitPrebuiltCall(
            appID: ZEGO_APP_ID,
            appSign: ZEGO_CLOUD_APP_SIGN,
            userID: ConfigGetter.USERDETAILS.userId,
            userName: ConfigGetter.USERDETAILS.userId,
            callID: Provider.of<WebSocketProvider>(context).room_id,
            controller: callController,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..onOnlySelfInRoom = (context) {
                if (PrebuiltCallMiniOverlayPageState.idle != ZegoUIKitPrebuiltCallMiniOverlayMachine().state()) {
                  /// in minimizing
                  ZegoUIKitPrebuiltCallMiniOverlayMachine().changeState(PrebuiltCallMiniOverlayPageState.idle);
                } else {
                  Navigator.of(context).pop();
                }
              }
              ..onHangUpConfirmation = (BuildContext context) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text('Are you sure to exit the meeting ?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                             Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Exit',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            await _updateRoomStatus(3);
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );
              }

              /// support minimizing
              ..topMenuBarConfig.isVisible = true

              ..topMenuBarConfig.buttons = [
                ZegoMenuBarButtonName.minimizingButton,
                ZegoMenuBarButtonName.showMemberListButton,
                ZegoMenuBarButtonName.toggleScreenSharingButton,
              ]),
      ),
    );
  }
}
