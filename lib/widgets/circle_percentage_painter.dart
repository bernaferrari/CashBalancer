import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class const CirclePercentagePainter({
  required final double percent,
  required final Color color,
  required final Color circleColor,
  required final Color backgroundColor,
}) extends CustomPainter {
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
    return percent != oldDelegate.percent ||
        color != oldDelegate.color ||
        circleColor != oldDelegate.circleColor ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
