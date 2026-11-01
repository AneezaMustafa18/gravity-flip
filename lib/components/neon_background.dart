import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class NeonBackground {
  static void draw(Canvas canvas, double time, int level) {
    final colors = [
      const Color(0xFF17143D),
      const Color(0xFF30205B),
      const Color(0xFF572B72),
      const Color(0xFF183C64),
      const Color(0xFF42205F),
      const Color(0xFF172B55),
    ];

    final base = colors[(level - 1) % colors.length];

    final rect = const Rect.fromLTWH(0, 0, 960, 540);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [base, const Color(0xFF11152F), const Color(0xFF251A49)],
        ).createShader(rect),
    );

    // Soft colorful glow
    for (int i = 0; i < 4; i++) {
      final x = 150.0 + i * 240 + math.sin(time * 0.4 + i) * 35;
      final y = 120.0 + math.cos(time * 0.5 + i) * 35;

      canvas.drawCircle(
        Offset(x, y),
        115,
        Paint()
          ..color = [
            const Color(0xFFB65CFF),
            const Color(0xFF55DFFF),
            const Color(0xFFFF80C8),
            const Color(0xFF8C83FF),
          ][i].withOpacity(0.10)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 55),
      );
    }

    // Twinkling stars
    for (int i = 0; i < 65; i++) {
      final x = (i * 137.0 + 23) % 960;
      final y = (i * 79.0 + 17) % 540;
      final twinkle = 0.45 + 0.55 * math.sin(time * 2 + i).abs();

      canvas.drawCircle(
        Offset(x, y),
        1.0 + (i % 3) * 0.6,
        Paint()
          ..color = Colors.white.withOpacity(twinkle * 0.8),
      );
    }

    // Floating bubbles
    for (int i = 0; i < 13; i++) {
      final x = (i * 91.0 + math.sin(time * 0.5 + i) * 20) % 960;
      final y = (480 - (time * (12 + i % 4) + i * 53) % 570);

      canvas.drawCircle(
        Offset(x, y),
        5 + (i % 4) * 2,
        Paint()
          ..color = const Color(0xFFB7EFFF).withOpacity(0.12),
      );

      canvas.drawCircle(
        Offset(x, y),
        5 + (i % 4) * 2,
        Paint()
          ..color = const Color(0xFFB7EFFF).withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Cartoon floating clouds
    for (int i = 0; i < 5; i++) {
      final x = ((i * 235.0 + time * (8 + i)) % 1120) - 100;
      final y = 90.0 + i * 78 + math.sin(time + i) * 10;

      _drawCloud(canvas, Offset(x, y), 0.7 + (i % 2) * 0.2);
    }

    // Small planets
    _drawPlanet(
      canvas,
      Offset(820 + math.sin(time * 0.3) * 12, 105),
      28,
      const Color(0xFFFF91C8),
      time,
    );

    _drawPlanet(
      canvas,
      Offset(115 + math.cos(time * 0.25) * 10, 285),
      17,
      const Color(0xFF72E8FF),
      -time,
    );

    // Shooting star
    final sx = (time * 110) % 1100 - 120;
    final sy = 45 + (time * 35) % 130;

    final path = Path()
      ..moveTo(sx, sy)
      ..lineTo(sx - 55, sy - 18);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFFFFF2C8).withOpacity(0.7)
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  static void _drawCloud(Canvas canvas, Offset p, double scale) {
    canvas.save();
    canvas.translate(p.dx, p.dy);
    canvas.scale(scale);

    final paint = Paint()
      ..color = const Color(0xFFD9D5FF).withOpacity(0.17);

    canvas.drawOval(
      const Rect.fromLTWH(0, 10, 80, 27),
      paint,
    );
    canvas.drawCircle(const Offset(23, 10), 19, paint);
    canvas.drawCircle(const Offset(45, 4), 24, paint);
    canvas.drawCircle(const Offset(65, 14), 16, paint);

    canvas.restore();
  }

  static void _drawPlanet(
      Canvas canvas,
      Offset center,
      double radius,
      Color color,
      double rotation,
      ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 0.12);

    final ring = Paint()
      ..color = color.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: radius * 3,
        height: radius * 0.8,
      ),
      ring,
    );

    canvas.drawCircle(
      Offset.zero,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color, color.withOpacity(0.25)],
        ).createShader(
          Rect.fromCircle(center: Offset.zero, radius: radius),
        ),
    );

    canvas.restore();
  }

  static void render(Canvas canvas, double time) => draw(canvas, time, 1);
}