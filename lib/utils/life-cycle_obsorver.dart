import 'package:flutter/material.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:provider/provider.dart';

import '../provider/websocket_provider.dart';
import '../route/route_config.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  void onAppForegrounded() {
    //Provider.of<WebSocketProvider>(navigatorKey.currentState!.context, listen: false).setupInteractedMessage();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {
      onAppForegrounded();
    }
  }
}
