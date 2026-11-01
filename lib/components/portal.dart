import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Portal {
  static void draw(Canvas canvas, Offset center, double time) {
    final pulse = 1 + math.sin(time * 3) * 0.06;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(pulse);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: 58,
        height: 76,
      ),
      Paint()
        ..color = const Color(0xFFB66CFF).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: 48,
        height: 68,
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF62E9FF),
            Color(0xFFB66CFF),
            Color(0xFFFF84CF),
          ],
        ).createShader(
          const Rect.fromLTWH(-24, -34, 48, 68),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: 30,
        height: 52,
      ),
      Paint()
        ..color = const Color(0xFF17143D)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(math.sin(time * 2) * 5, math.cos(time * 2) * 8),
      4,
      Paint()..color = const Color(0xFFFFE477),
    );

    canvas.restore();
  }
  static void render(Canvas canvas, Offset center, double time) => draw(canvas, center, time);
}