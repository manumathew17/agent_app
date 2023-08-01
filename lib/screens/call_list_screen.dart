import 'package:flutter/material.dart';
import 'package:lively_studio/provider/call_history_provider.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../app_color.dart';
import '../model/model_call_scheduled.dart';
import '../provider/home-provider.dart';
import '../style.dart';
import '../utils/general.dart';
import '../widgets/call_status_tag.dart';

class CallListScreen extends StatefulWidget {
  const CallListScreen({super.key});

  @override
  CallListScreenState createState() => CallListScreenState();
}

class CallListScreenState extends State<CallListScreen> {
  @override
  void initState() {
    Provider.of<CallHistoryProvider>(context, listen: false).getScheduledCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          title: const Text(
            "Call History",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Consumer<CallHistoryProvider>(
            builder: (context, callHistoryProvider, child) {
          return ListView.builder(
              itemCount: callHistoryProvider.callScheduledList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 100.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        generalBoxShadow
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  callHistoryProvider
                                      .callScheduledList[index].customerName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  callHistoryProvider.callScheduledList[index].customerMobileNo,
                                  style: generalText,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CallStatusTags(
                                    callStatus: callHistoryProvider
                                        .callScheduledList[index].callStatus),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    callHistoryProvider
                                        .callScheduledList[index].callType,
                                    style: generalText),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        "Time \n ${GeneralUtils.readableTime(callHistoryProvider.callScheduledList[index].startTime)}",
                                        textAlign: TextAlign.center,
                                        style: generalText),
                                    IconButton(
                                      icon: const Icon(Icons.call),
                                      color: primary,
                                      onPressed: () async {
                                        GeneralUtils.makePhoneCall(
                                            callHistoryProvider.callScheduledList[index]
                                                .customerMobileNo);
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsWebView(
                                                    productUrl:
                                                        callHistoryProvider
                                                            .callScheduledList[index]
                                                            .productUrl,
                                                  )),
                                        );
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                primary),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                lightPrimary_2),
                                      ),
                                      child: const Text('View'),
                                    ),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetailsWebView(
                                                    productUrl:
                                                        callHistoryProvider
                                                            .callScheduledList[index]
                                                            .productUrl,
                                                  )),
                                        );
                                      },
                                      style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                primary),
                                      ),
                                      child: const Text('Join call'),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }));
        }));
  }
}
