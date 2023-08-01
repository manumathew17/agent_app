import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../app_color.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(20.h);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool light1 = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: lightPrimary_2,
      // Set the background color
      elevation: 10,
      // Set the elevation (shadow)
      automaticallyImplyLeading: false,
      // Remove the default back button
      titleSpacing: 0,
      // Remove the default title spacing
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10.h,
                  child: Image.asset(
                      'assets/logo/lively-logo.png'), // Replace with your image asset path
                ),
                Text(
                  'Hello Manu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: light1,
                onChanged: (bool value) {
                  setState(() {
                    light1 = value;
                  });
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
          ),
        ],
      ),
    );
  }
}
