import 'dart:math' as math;

import 'package:flutter/material.dart';

class CirclePercentagePainter extends CustomPainter {
  const CirclePercentagePainter({
    required this.percent,
    required this.color,
    required this.circleColor,
    required this.backgroundColor,
  });

  final double percent;
  final Color color;
  final Color circleColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = backgroundColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 6;
    paint.strokeCap = StrokeCap.square;

    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, math.pi * 2,
        false, paint);
    paint.color = color;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -math.pi / 2,
      -2 * math.pi * percent,
      false,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 3,
      Paint()..color = circleColor,
    );
  }

  @override
  bool shouldRepaint(CirclePercentagePainter oldDelegate) {
    return percent != oldDelegate.percent || color != oldDelegate.color;
  }
}
