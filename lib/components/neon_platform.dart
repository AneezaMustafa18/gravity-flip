import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class NeonPlatform {
  static void draw(Canvas canvas, Rect rect, {double time = 0}) {
    final radius = Radius.circular(9);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    canvas.drawRRect(
      rrect.inflate(5),
      Paint()
        ..color = const Color(0xFF8A66FF).withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF514B91),
            Color(0xFF282B62),
          ],
        ).createShader(rect),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0xFF8DEEFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawLine(
      Offset(rect.left + 10, rect.top + 4),
      Offset(rect.right - 10, rect.top + 4),
      Paint()
        ..color = const Color(0xFFFFFFFF).withOpacity(0.55)
        ..strokeWidth = 2,
    );
  }

  static void render(Canvas canvas, Rect rect, double time) => draw(canvas, rect, time: time);

  static void renderHazard(Canvas canvas, Rect rect, double time) {
    final glow = Paint()
      ..color = const Color(0xFFFF5CBA).withOpacity(0.55 + 0.2 * math.sin(time * 5).abs())
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(RRect.fromRectAndRadius(rect.inflate(3), const Radius.circular(5)), glow);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      Paint()..shader = const LinearGradient(colors: [Color(0xFFFFB2E0), Color(0xFFFF3E9D)]).createShader(rect),
    );
  }
}