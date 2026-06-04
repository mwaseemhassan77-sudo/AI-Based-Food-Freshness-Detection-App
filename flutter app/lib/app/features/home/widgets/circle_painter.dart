
// Custom Painter 

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CirclePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.1), 80, paint);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.9), 60, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
