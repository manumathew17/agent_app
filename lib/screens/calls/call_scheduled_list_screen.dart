import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:lively_studio/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../provider/call_history_provider.dart';
import '../../provider/websocket_provider.dart';
import '../../style.dart';
import '../product/product_detail_screen.dart';

class ScheduledCallListScreen extends StatefulWidget {
  const ScheduledCallListScreen({super.key});

  @override
  ScheduledCallListScreenState createState() => ScheduledCallListScreenState();
}

class ScheduledCallListScreenState extends State<ScheduledCallListScreen> {
  late GeneralSnackBar _snackBar;

  @override
  void initState() {
    Provider.of<CallHistoryProvider>(context, listen: false).getScheduledCall();
    _snackBar = GeneralSnackBar(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<CallHistoryProvider>(
      builder: (context, scheduledCall, child) {
        return ListView.builder(
            itemCount: scheduledCall.callScheduledList.length,
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
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              scheduledCall.callScheduledList[index].customerName,
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
                              GeneralUtils.formatDateTime(scheduledCall.callScheduledList[index].start_time_formatted),
                              style: generalText,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetailsWebView(
                                        productUrl: scheduledCall.callScheduledList[index].productUrl,
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
                        TextButton(
                          onPressed: () {
                            if (_canJoinTheMeet(scheduledCall.callScheduledList[index].start_time_formatted)) {
                              var provider = Provider.of<WebSocketProvider>(context, listen: false);
                              provider.room_id = scheduledCall.callScheduledList[index].room_id;
                              provider.call_token = scheduledCall.callScheduledList[index].id;
                              provider.isInstantCall = false;
                              GoRouter.of(context).push("/video-call");
                            } else {
                              _snackBar.showErrorSnackBar("Please join the meet on specified time");
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(primaryGreen),
                            backgroundColor: MaterialStateProperty.all<Color>(secondaryGreen),
                          ),
                          child: const Text('Join'),
                        ),

                        SizedBox(
                          width: 1.w,
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Ink(
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const FaIcon(
                                  FontAwesomeIcons.whatsapp,
                                  color: Colors.green,
                                ),
                                color: primary,
                                onPressed: () {
                                  GeneralUtils.openWhatsApp(scheduledCall.callMissedList[index].customerMobileNo, "");
                                },
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.phone),
                              color: Colors.black,
                              onPressed: () {
                                GeneralUtils.makePhoneCall(scheduledCall.callMissedList[index].customerMobileNo);
                              },
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

  bool _canJoinTheMeet(String dateTimeString) {
    try {
      DateTime passedTimeUTC = DateTime.parse(dateTimeString);

      DateTime passedTime = passedTimeUTC.toLocal();

      DateTime now = DateTime.now();

      DateTime rangeStart = passedTime.subtract(const Duration(minutes: 5));
      DateTime rangeEnd = passedTime.add(const Duration(minutes: 30));

      return now.isAfter(rangeStart) && now.isBefore(rangeEnd);
    } catch (_) {
      return false;
    }
  }
}
