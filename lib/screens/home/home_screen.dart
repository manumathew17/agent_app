import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/provider/home-provider.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../provider/call_history_provider.dart';
import '../../style.dart';
import '../../widgets/animated_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();
    // Provider.of<CallHistoryProvider>(context, listen: false).getCallHistory();
    Provider.of<CallHistoryProvider>(context, listen: false).getTodayCall();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CallHistoryProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 100.w,
                height: 20.h,
                decoration: const BoxDecoration(
                  color: lightPrimary_2,
                  boxShadow: [BoxShadow(color: Color(0x1e000000), offset: Offset(0, 2), blurRadius: 10, spreadRadius: 0)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.h,
                            child: Image.asset('assets/logo/lively-logo.png'), // Replace with your image asset path
                          ),
                          Text(
                            'Hello ${ConfigGetter.USERDETAILS.user_name}',
                            style: generalText,
                          )
                        ],
                      ),
                    ),
                    Consumer<HomeProvider>(builder: (context, onlineStatus, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              onlineStatus.isOnline ? 'Online' : 'Offline',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Switch(
                            value: onlineStatus.isOnline,
                            onChanged: (bool value) {
                              Provider.of<HomeProvider>(context, listen: false).updateOnlineStatus();
                            },
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(right: 10),
                          //   child: Text(
                          //     "Mon - Fri, 10:00 AM - 6-00 PM",
                          //     style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                          //   ),
                          // )
                        ],
                      );
                    })
                  ],
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Lottie.asset(
                  'assets/anim/videocall.json',
                  repeat: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
