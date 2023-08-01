
import 'package:flutter/material.dart';
import 'package:lively_studio/app_color.dart';

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({super.key, required this.value});

  @override
  _AnimatedProgressIndicatorState createState() =>
      _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: 1), // Adjust the duration as per your preference
    );

    _animation = Tween<double>(begin: 0, end: widget.value).animate(_controller)
      ..addListener(() {
        setState(
            () {}); // To rebuild the widget when the animation value changes
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 10,
        child: LinearProgressIndicator(
          value: _animation.value,
          // Use the animated value instead of the static value
          valueColor: const AlwaysStoppedAnimation<Color>(primaryDark),
          backgroundColor: lightPrimary_1,
        ),
      ),
    );
  }
}
