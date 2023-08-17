import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/config/const.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:lively_studio/screens/home/dashboard_screen.dart';
import 'package:lively_studio/screens/login_screen.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    _checkIsLoggedInOrNot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white, // Set the background color of the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 60.w,
                  child: Image.asset('assets/logo/lively-logo.png'), // Replace with your image asset path
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                'version $APP_VERSION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkIsLoggedInOrNot() async {
    await Future.delayed(const Duration(seconds: 1));

    SharedPreferenceUtility.getStoredAccountDetails().then((valid) => {
          if (valid) {Provider.of<WebSocketProvider>(context, listen: false).fcmNotificationInit(), context.go('/dashboard')} else {context.go('/login')}
        });
  }
}
