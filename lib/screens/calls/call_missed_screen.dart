import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../style.dart';

class CallMissedScreen extends StatefulWidget {
  const CallMissedScreen({super.key});

  @override
  CallMissedScreenState createState() => CallMissedScreenState();
}

class CallMissedScreenState extends State<CallMissedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 20,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name",
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
                              Text(
                                "Time",
                                style: generalText,
                              ),
                            ],
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
                              onPressed: () {},
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
                                print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
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
    );
  }
}
