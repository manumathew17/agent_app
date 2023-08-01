import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../provider/call_history_provider.dart';
import '../../style.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  CallHistoryScreenState createState() => CallHistoryScreenState();
}

class CallHistoryScreenState extends State<CallHistoryScreen> {

  @override
  void initState() {
    Provider.of<CallHistoryProvider>(context, listen: false).getCallHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<CallHistoryProvider>(
      builder: (context, callHistoryProvider, child) {
        return ListView.builder(
            itemCount: callHistoryProvider.callHistoryList.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: greyGeneral,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [generalBoxShadow],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              callHistoryProvider.callHistoryList[index].customerName,
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
                              GeneralUtils.formatDateTime(callHistoryProvider.callHistoryList[index].callDateTime),
                              style: generalText,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
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
                                              productUrl: callHistoryProvider.callHistoryList[index].productUrl,
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
                            // TextButton(
                            //   onPressed: () {},
                            //   style: ButtonStyle(
                            //     foregroundColor: MaterialStateProperty.all<Color>(primaryGreen),
                            //     backgroundColor: MaterialStateProperty.all<Color>(secondaryGreen),
                            //   ),
                            //   child: const Text('Invite'),
                            // ),
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
                                onPressed: () async {
                                  await GeneralUtils.openWhatsApp(callHistoryProvider.callHistoryList[index].phoneNumber, "");
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
    ));
  }
}
