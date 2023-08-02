import 'package:flutter/material.dart';
import 'package:lively_studio/provider/call_history_provider.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../style.dart';
import '../product/product_detail_screen.dart';

class CallMissedScreen extends StatefulWidget {
  const CallMissedScreen({super.key});

  @override
  CallMissedScreenState createState() => CallMissedScreenState();
}

class CallMissedScreenState extends State<CallMissedScreen> {

  @override
  void initState() {
    Provider.of<CallHistoryProvider>(context, listen: false).getMissedCall();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Consumer<CallHistoryProvider>(
        builder: (context, missedCalls, child) {
          return ListView.builder(
              itemCount: missedCalls.callMissedList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 100.w,
                    decoration: const BoxDecoration(
                      color: greyGeneral,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        generalBoxShadow
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  missedCalls.callMissedList[index].customerName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.call_missed_rounded, // Replace with the desired icon
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 1.w), // Add some spacing between the icon and the text
                                    Expanded(
                                      child: Text(
                                        GeneralUtils.formatDateTime(missedCalls.callMissedList[index].createdAt),
                                        style: generalText,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 3, right: 2),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetailsWebView(
                                            productUrl: missedCalls.callMissedList[index].productUrl,
                                          )),
                                    );
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(primary),
                                  ),
                                  child: const Text(
                                    'View Product',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all<Color>(primaryGreen),
                                  backgroundColor: MaterialStateProperty.all<Color>(secondaryGreen),
                                ),
                                child: const Text('Invite'),
                              ),
                              Ink(
                                decoration: const ShapeDecoration(
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.chat_rounded,
                                    color: Colors.black,
                                  ),
                                  color: primary,
                                  onPressed: () {
                                    GeneralUtils.openWhatsApp(missedCalls.callMissedList[index].customerMobileNo,"");
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }));
        },
      )


    );
  }
}
