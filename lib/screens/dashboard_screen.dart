import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_color.dart';
import '../style.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PopupMenuButton<SampleItem>(
          enableFeedback: true,
          tooltip: 'Options',
          surfaceTintColor: Colors.white,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // Callback that sets the selected popup menu item.
          onSelected: (SampleItem item) {},
          itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemOne,
              child: Text('Item 1'),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemTwo,
              child: Text('Item 2'),
            ),
            const PopupMenuItem<SampleItem>(
              value: SampleItem.itemThree,
              child: Text('Item 3'),
            ),
          ],
          child: IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: lightPrimary_2, // Replace with your primary color
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Weekly',
                      style: generalText,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down_rounded),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
