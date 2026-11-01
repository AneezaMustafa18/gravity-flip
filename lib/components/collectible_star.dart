import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CollectibleStar {
  static void draw(Canvas canvas, Offset center, double time, int index) {
    final pulse = 1 + 0.12 * math.sin(time * 4 + index);
    final rotation = time * 1.2 + index;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.scale(pulse);

    final path = Path();

    for (int i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final radius = i.isEven ? 13.0 : 6.0;
      final point = Offset(
        math.cos(angle) * radius,
        math.sin(angle) * radius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFFC94F)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
    );

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFFFFE477),
    );

    canvas.drawCircle(
      const Offset(-3, -4),
      2,
      Paint()..color = Colors.white,
    );

    canvas.restore();
  }
  static void render(Canvas canvas, Offset center, double time) => draw(canvas, center, time, 0);
}