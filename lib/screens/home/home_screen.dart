import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/provider/home-provider.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:lively_studio/utils/general.dart';
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
    Provider.of<CallHistoryProvider>(context, listen: false).getCallHistory();
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "Mon - Fri, 10:00 AM - 6-00 PM",
                              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      );
                    })
                  ],
                ),
              ),
              SizedBox(
                height: 1.w,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Today's call",
                  style: heading14,
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: homeProvider.callHistoryList.length,
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
                                      homeProvider.callHistoryList[index].customerName,
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
                                      GeneralUtils.getTime(homeProvider.callHistoryList[index].callDateTime),
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
                                                      productUrl: homeProvider.callHistoryList[index].productUrl,
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
                                    Ink(
                                      decoration: const ShapeDecoration(
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.call_rounded,
                                          color: Colors.black,
                                        ),
                                        color: primary,
                                        onPressed: () {
                                          GeneralUtils.makePhoneCall(homeProvider.callHistoryList[index].phoneNumber);
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
                    })),
              )
            ],
          ),
        );
      },
    );
  }
}
