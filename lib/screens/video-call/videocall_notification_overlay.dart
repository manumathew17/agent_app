import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:lively_studio/screens/video-call/videocall_screen.dart';
import 'package:lively_studio/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/model_video_call_request.dart';

class VideoCallNotificationPopup extends StatefulWidget {
  final VideoCallRequest videoCallRequest;
  final VoidCallback onJoinCallPressed;

  const VideoCallNotificationPopup({super.key, required this.videoCallRequest, required this.onJoinCallPressed});

  @override
  VideoCallNotificationPopupState createState() => VideoCallNotificationPopupState();
}

class VideoCallNotificationPopupState extends State<VideoCallNotificationPopup> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: IntrinsicHeight(
          child: Container(
            width: 70.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Color(0x1e000000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0)],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text("Video call request", style: heading14),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text("Name : ${widget.videoCallRequest.message.userInfo.userName}", style: generalText),
                  ),
                  SizedBox(
                    height: 60.w,
                    child:  WebView(
                      backgroundColor: Colors.white,
                      javascriptMode: JavascriptMode.disabled,
                      initialUrl: widget.videoCallRequest.message.productInfo.productUrl,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          onPressed: () {
                            Provider.of<WebSocketProvider>(context, listen: false).generateRoomId(widget.onJoinCallPressed);

                          },
                          child: const Text('Join call'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ), // Loader widget
      ),
    );
  }
}
