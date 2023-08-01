
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final Color tagColor;
  final String tagName;

  const TagWidget({super.key, required this.tagColor, required this.tagName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        tagName,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
