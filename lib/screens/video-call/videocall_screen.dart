import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:lively_studio/config/const.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:lively_studio/utils/notification/notification_controller.dart';
import 'package:lively_studio/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../utils/shared_preference.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> {
  ZegoUIKitPrebuiltCallController? callController;
  RequestRouter requestRouter = RequestRouter();
  late String callToken;
  late GeneralSnackBar _generalSnackBar;

  _updateRoomStatus(status, BuildContext ctx) {
    callToken = Provider.of<WebSocketProvider>(ctx, listen: false).call_token;
    if (Provider.of<WebSocketProvider>(ctx, listen: false).isInstantCall) {
      final requestBody = {'token': callToken, 'call_status': status};
      requestRouter.updateCallStatus(
          requestBody,
          RequestCallbacks(onSuccess: (response) {
            if (status == 3) {
              Navigator.of(ctx).pop(true);
            }
          }, onError: (error) {
            if (status == 3) {
              Navigator.of(ctx).pop(true);
            }
          }));
    } else {
      final requestBody = {'scheduled_call_id': callToken, 'call_status': status};
      requestRouter.updateScheduledCallStatus(
          requestBody,
          RequestCallbacks(onSuccess: (response) {
            if (status == 3) {
              Navigator.of(ctx).pop(true);
            }
          }, onError: (error) {
            if (status == 3) {
              Navigator.of(ctx).pop(true);
            }
          }));
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterRingtonePlayer.stop();
    callController = ZegoUIKitPrebuiltCallController();
    _generalSnackBar = GeneralSnackBar(context);
    callToken = Provider.of<WebSocketProvider>(context, listen: false).call_token;
    _updateRoomStatus(2, context);
    NotificationController.cancelAllNotification();
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
            userName: ConfigGetter.USERDETAILS.user_name,
            callID: Provider.of<WebSocketProvider>(context).room_id,
            controller: callController,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..onOnlySelfInRoom = (context) {
                if (PrebuiltCallMiniOverlayPageState.idle != ZegoUIKitPrebuiltCallMiniOverlayMachine().state()) {
                  /// in minimizing
                  ZegoUIKitPrebuiltCallMiniOverlayMachine().changeState(PrebuiltCallMiniOverlayPageState.idle);
                } else {
                  _updateRoomStatus(3, context);
                  _generalSnackBar.showErrorSnackBar("Customer has ended the call");
                }
              }
              ..durationConfig = ZegoCallDurationConfig(onDurationUpdate: (duration) {
                if (duration.inMinutes >= MAX_CALL_TIME) {
                  _updateRoomStatus(3, context);
                }
              })
              ..bottomMenuBarConfig.buttons = [
                ZegoMenuBarButtonName.hangUpButton,
                ZegoMenuBarButtonName.minimizingButton,
                ZegoMenuBarButtonName.toggleCameraButton,
                ZegoMenuBarButtonName.toggleMicrophoneButton,
                ZegoMenuBarButtonName.showMemberListButton,
                ZegoMenuBarButtonName.switchCameraButton,
              ]
              ..onHangUpConfirmation = (BuildContext context) async {
                return await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async {
                        return false;
                      },
                      child: AlertDialog(
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
                            onPressed: () {
                              _updateRoomStatus(3, context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              /// support minimizing
              ..topMenuBarConfig.isVisible = false
              ..topMenuBarConfig.buttons = [
                ZegoMenuBarButtonName.minimizingButton,
                ZegoMenuBarButtonName.showMemberListButton,
                ZegoMenuBarButtonName.toggleScreenSharingButton,
              ]),
      ),
    );
  }
}
