import 'package:flutter/material.dart';

class RoundedProgressBar extends StatelessWidget {
  final double progress;

  RoundedProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Width of the progress bar
      height: 20, // Height of the progress bar
      child: Stack(
        children: [
          Container(
            width: 200, // Full width of the progress bar
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Background color of the progress bar
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 200 * progress, // Width based on progress
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue, // Progress color
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            top: -40,
            left: 200 * progress - 20, // Position the tooltip at the end of the progress
            child: Tooltip(
              message: '${(progress * 100).toStringAsFixed(1)}%',
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}