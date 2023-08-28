import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:lively_studio/utils/Logger.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:lively_studio/utils/life-cycle_obsorver.dart';
import 'package:lively_studio/utils/notification/notification_controller.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import './route/route_config.dart';
import 'config/const.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.data}");
  // NotificationController.cancelAllNotification();

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    await prefs.setString(PREF_NOTIFICATION, message.data["data"]);
    await prefs.setString(PREF_CALL_TIME, message.sentTime.toString());

    String notificationData = prefs.getString(PREF_NOTIFICATION) ?? "";
    print("------------------------------------------------------------------------------");
    print(notificationData);
  } catch (ex) {
    Logger.log(ex.toString());
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationController.createNewNotification();
  GeneralUtils.notificationVibrate();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await NotificationController.initializeLocalNotifications();

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

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppLifecycleObserver lifecycleObserver = AppLifecycleObserver();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //setUpInteractedMessage();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        Provider.of<WebSocketProvider>(widget.navigatorKey.currentState!.context, listen: false).checkNotification();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  // Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  //   print('uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
  //
  //   print(receivedAction.payload.toString());
  //   Provider.of<WebSocketProvider>(widget.navigatorKey.currentState!.context, listen: false)
  //       .showVideoCallRingDialog(receivedAction.payload!.cast<String, dynamic>());
  // }
  //
  // Future<void> setUpInteractedMessage() async {
  //   AwesomeNotifications().setListeners(
  //     onActionReceivedMethod: onActionReceivedMethod,
  //   );
  //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }
  // }
  //
  // void _handleMessage(RemoteMessage message) {
  //   Provider.of<WebSocketProvider>(context, listen: false).showVideoCallRingDialog(message.data);
  // }

  void joinCall() {
    SharedPreferenceUtility.setCallAttended(true);
    if (ZegoUIKitPrebuiltCallMiniOverlayMachine().isMinimizing) {
      return;
    }
    GoRouter.of(widget.navigatorKey.currentState!.context).push("/video-call");
  }

  void forwardCall() {
    SharedPreferenceUtility.setCallAttended(true);
    Provider.of<WebSocketProvider>(widget.navigatorKey.currentState!.context, listen: false).closeVideoCallOverlay();
    GoRouter.of(widget.navigatorKey.currentState!.context).push("/locations");
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
                        try {
                          ConfigGetter.mContext = widget.navigatorKey.currentState!.context;
                        } catch (_) {
                          ConfigGetter.mContext = context;
                        }

                        if (videoCall.showVideoCallInfo) {
                          return VideoCallNotificationPopup(videoCallRequest: videoCall.videoCallRequest, onJoinCallPressed: joinCall, onCallForwardPressed: forwardCall);
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
