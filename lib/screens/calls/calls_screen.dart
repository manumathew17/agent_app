import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lively_studio/screens/calls/call_missed_screen.dart';
import 'package:lively_studio/screens/calls/call_scheduled_list_screen.dart';
import 'package:lively_studio/style.dart';

import '../../app_color.dart';
import 'call_history_screen.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  CallScreenState createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackGround,
          title: const Text(
            "Call",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            indicatorColor: primary,
            tabs: <Widget>[
              Tab(
                text: "Scheduled",
              ),
              Tab(
                text: "History",
              ),
              Tab(
                text: "Missed",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[ScheduledCallListScreen(), CallHistoryScreen(), CallMissedScreen()],
        ),
      ),
    );
  }
}
