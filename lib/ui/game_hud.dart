
import 'dart:ui';

import 'package:flutter/material.dart';

class GameHud {
  GameHud._();

  static const double worldWidth = 960.0;
  static const double worldHeight = 540.0;
  static const int maxLives = 3;

  static void render(
      Canvas canvas, {
        required int level,
        required int score,
        required int lives,
        required int starsCollected,
        required int totalStars,
      }) {
    draw(
      canvas,
      level: level,
      score: score,
      lives: lives,
      stars: starsCollected,
      totalStars: totalStars,
    );
  }

  static void draw(
      Canvas canvas, {
        required int level,
        required int score,
        required int lives,
        required int stars,
        int totalStars = 3,
      }) {
    final safeLives = lives.clamp(0, maxLives);
    final safeStars = stars.clamp(0, totalStars);

    // Fixed game-world coordinates.
    const margin = 18.0;
    const top = 14.0;
    const height = 42.0;
    const gap = 10.0;

    // Level and score.
    const levelWidth = 145.0;
    const scoreWidth = 145.0;

    // Right-side lives panel.
    const livesWidth = 190.0;

    // LEVEL
    _pill(
      canvas,
      const Rect.fromLTWH(
        margin,
        top,
        levelWidth,
        height,
      ),
      'LEVEL $level / 20',
      fontSize: 13,
    );

    // SCORE
    _pill(
      canvas,
      const Rect.fromLTWH(
        margin + levelWidth + gap,
        top,
        scoreWidth,
        height,
      ),
      'SCORE $score',
      fontSize: 13,
    );

    // LIVES PANEL
    const livesX = worldWidth - margin - livesWidth;

    _pill(
      canvas,
      const Rect.fromLTWH(
        livesX,
        top,
        livesWidth,
        height,
      ),
      'LIVES  $safeLives / $maxLives',
      fontSize: 13,
      color: const Color(0xFFFF6B91),
    );

    // HEARTS: three total, filled hearts show remaining lives.
    const heartSize = 19.0;
    const heartGap = 13.0;

    const totalHeartWidth =
        maxLives * heartSize + (maxLives - 1) * heartGap;

    const heartStartX =
        livesX + (livesWidth - totalHeartWidth) / 2;

    for (int i = 0; i < maxLives; i++) {
      _heart(
        canvas,
        Offset(
          heartStartX + i * (heartSize + heartGap) + heartSize / 2,
          top + height + 17,
        ),
        size: heartSize,
        filled: i < safeLives,
      );
    }

    // STARS COUNTER
    const starWidth = 150.0;
    const starHeight = 36.0;
    const starX = worldWidth - margin - starWidth;
    const starY = top + height + 43;

    _pill(
      canvas,
      const Rect.fromLTWH(
        starX,
        starY,
        starWidth,
        starHeight,
      ),
      '★  $safeStars / $totalStars',
      fontSize: 13,
      color: const Color(0xFFFFC857),
    );
  }

  static void _pill(
      Canvas canvas,
      Rect rect,
      String text, {
        double fontSize = 13,
        Color color = const Color(0xFF63E6FF),
      }) {
    final background = Paint()
      ..color = const Color(0xDD101B38);

    final border = Paint()
      ..color = color.withOpacity(0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final radius = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(13),
    );

    canvas.drawRRect(radius, background);
    canvas.drawRRect(radius, border);

    _centerText(
      canvas,
      text,
      rect,
      fontSize: fontSize,
      color: color,
    );
  }

  static void _centerText(
      Canvas canvas,
      String text,
      Rect rect, {
        double fontSize = 13,
        Color color = const Color(0xFF63E6FF),
      }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: rect.width - 8);

    painter.paint(
      canvas,
      Offset(
        rect.center.dx - painter.width / 2,
        rect.center.dy - painter.height / 2,
      ),
    );
  }

  static void _heart(
      Canvas canvas,
      Offset center, {
        double size = 19,
        bool filled = true,
      }) {
    final path = Path();

    path.moveTo(
      center.dx,
      center.dy + size * 0.42,
    );

    path.cubicTo(
      center.dx - size * 0.15,
      center.dy + size * 0.25,
      center.dx - size * 0.62,
      center.dy - size * 0.05,
      center.dx - size * 0.48,
      center.dy - size * 0.38,
    );

    path.cubicTo(
      center.dx - size * 0.36,
      center.dy - size * 0.68,
      center.dx - size * 0.06,
      center.dy - size * 0.55,
      center.dx,
      center.dy - size * 0.32,
    );

    path.cubicTo(
      center.dx + size * 0.06,
      center.dy - size * 0.55,
      center.dx + size * 0.36,
      center.dy - size * 0.68,
      center.dx + size * 0.48,
      center.dy - size * 0.38,
    );

    path.cubicTo(
      center.dx + size * 0.62,
      center.dy - size * 0.05,
      center.dx + size * 0.15,
      center.dy + size * 0.25,
      center.dx,
      center.dy + size * 0.42,
    );

    final paint = Paint()
      ..color = filled
          ? const Color(0xFFFF4F83)
          : const Color(0xFF52617E)
      ..style = filled
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawPath(path, paint);
  }
}
