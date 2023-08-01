import 'package:flutter/material.dart';
import 'package:lively_studio/widgets/tags.dart';

class CallStatusTags extends StatelessWidget {
  final int callStatus;

  const CallStatusTags({super.key,  required this.callStatus});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (callStatus == 1)
          const TagWidget(tagColor: Colors.cyan, tagName: 'new'),
        if (callStatus == 2)
          const TagWidget(tagColor: Colors.blue, tagName: 'started'),
        if (callStatus == 3)
          const TagWidget(tagColor: Colors.green, tagName: 'finished'),
        if (callStatus == 4)
          const TagWidget(tagColor: Colors.red, tagName: 'no-show'),
        if (callStatus == 5)
          const TagWidget(tagColor: Colors.orange, tagName: 'Disconnected'),
      ],
    );
  }
}
