import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/provider/call_history_provider.dart';
import 'package:lively_studio/provider/catalog_provider.dart';
import 'package:lively_studio/provider/customer_chat_provider.dart';
import 'package:lively_studio/provider/home-provider.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:lively_studio/screens/home/dashboard_screen.dart';
import 'package:lively_studio/screens/login_screen.dart';
import 'package:lively_studio/screens/spash_screen.dart';
import 'package:lively_studio/screens/video-call/videocall_notification_overlay.dart';
import 'package:lively_studio/screens/video-call/videocall_screen.dart';
import 'package:lively_studio/theme.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:lively_studio/utils/life-cycle_obsorver.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import './route/route_config.dart';
import 'firebase_options.dart';




@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.


  print("Handling a background message: ${message.data}");

  try{
    Provider.of<WebSocketProvider>(ConfigGetter.mContext,listen: false).showVideoCallRingDialog(message.data);
  }
  catch (_){

  }



  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GeneralUtils.notificationVibrate();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp(navigatorKey: navigatorKey));
  // ZegoUIKit().initLog().then((value) {
  //   runApp(MyApp(navigatorKey: navigatorKey));
  // });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final AppLifecycleObserver lifecycleObserver = AppLifecycleObserver();
  @override
  void initState() {
    super.initState();
    setUpInteractedMessage();
  }

  Future<void> setUpInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    Provider.of<WebSocketProvider>(context, listen: false).showVideoCallRingDialog(message.data);
  }

  void joinCall() {
    if (ZegoUIKitPrebuiltCallMiniOverlayMachine().isMinimizing) {
      return;
    }
    GoRouter.of(widget.navigatorKey.currentState!.context).push("/video-call");
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addObserver(lifecycleObserver);
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => CatalogProvider()),
            ChangeNotifierProvider(create: (_) => CallHistoryProvider()),
            ChangeNotifierProvider(create: (_) => WebSocketProvider()),
            ChangeNotifierProvider(
              create: (_) => CustomerChatProvider(),
            )
          ],
          child: MaterialApp.router(
              title: 'Flutter Demo',
              builder: (BuildContext context, Widget? child) {
                return Stack(
                  children: [
                    child!,
                    ZegoUIKitPrebuiltCallMiniOverlayPage(
                      contextQuery: () {
                        return widget.navigatorKey.currentState!.context;
                      },
                    ),
                    Consumer<WebSocketProvider>(
                      builder: (context, videoCall, child) {
                        try{
                          ConfigGetter.mContext = widget.navigatorKey.currentState!.context;
                        }
                        catch(_){
                          ConfigGetter.mContext = context;
                        }

                        if (videoCall.showVideoCallInfo) {
                          return VideoCallNotificationPopup(videoCallRequest: videoCall.videoCallRequest, onJoinCallPressed: joinCall);
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                );
              },
              theme: ThemeData(
                colorScheme: customColorScheme,
                fontFamily: GoogleFonts.poppins().fontFamily,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.light,
              routerConfig: route));
    });
  }
}
