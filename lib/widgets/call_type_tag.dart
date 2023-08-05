import 'package:flutter/material.dart';
import 'package:lively_studio/style.dart';
import 'package:sizer/sizer.dart';

class CallTypeTag extends StatelessWidget {
  final String text;

  const CallTypeTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.video_call_rounded, size: 18, color: getColor(text)),
        SizedBox(
          width: 1.w,
        ),
        Text(
          text,
          style: generalText,
        )
      ],
    );
  }

  Color getColor(String text) {
    if (text.toLowerCase() == 'instant') {
      return Colors.red;
    } else if (text.toLowerCase() == 'scheduled') {
      return Colors.deepPurple;
    } else {
      return Colors.orange;
    }
  }
}
