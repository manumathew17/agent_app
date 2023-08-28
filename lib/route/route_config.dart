import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/screens/home/dashboard_screen.dart';
import 'package:lively_studio/screens/login_screen.dart';
import 'package:lively_studio/screens/spash_screen.dart';
import 'package:lively_studio/screens/video-call/call-forward/warehouse_list_screen.dart';

import '../screens/video-call/videocall_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final route = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/video-call',
      builder: (context, state) => const VideoCallScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashBoardScreen(),
    ),
    GoRoute(
        path: '/locations',
        builder: (context, state) => WareHouseList(
              onCallForwarded: () {
                GoRouter.of(context).go("/dashboard");
              },
            ))
  ],
);
