
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pip {
  static const List<String> characterNames = [
    'Pip',
    'Nova',
    'Bibi',
    'Bolt',
  ];

  static void draw(
      Canvas canvas,
      Offset center,
      double time, {
        bool grounded = false,
        double facing = 1,
        int characterIndex = 0,
      }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(facing, 1);

    final bounce = grounded ? math.sin(time * 12) * 1.5 : 0.0;
    canvas.translate(0, bounce);

    // Character shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, 25),
        width: 42,
        height: 9,
      ),
      Paint()..color = const Color(0x66090D24),
    );

    switch (characterIndex.clamp(0, 3)) {
      case 0:
        _drawPip(canvas, time);
        break;
      case 1:
        _drawNova(canvas, time);
        break;
      case 2:
        _drawBibi(canvas, time);
        break;
      case 3:
        _drawBolt(canvas, time);
        break;
    }

    canvas.restore();
  }

  // --------------------------------------------------
  // PIP - ORIGINAL ROBOT
  // --------------------------------------------------

  static void _drawPip(Canvas canvas, double time) {
    final antennaX = math.sin(time * 3) * 3;

    canvas.drawLine(
      const Offset(0, -23),
      Offset(antennaX, -35),
      Paint()
        ..color = const Color(0xFFB7F5FF)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(antennaX, -37),
      5,
      Paint()..color = const Color(0xFFFF8FCB),
    );

    _drawRobotFeet(canvas);

    _rounded(
      canvas,
      const Rect.fromLTWH(-22, -25, 44, 43),
      15,
      const Color(0xFF70E8FF),
      glow: true,
    );

    _rounded(
      canvas,
      const Rect.fromLTWH(-20, -25, 40, 42),
      14,
      const Color(0xFF8DEBFF),
      gradient: const [
        Color(0xFFF5FFFF),
        Color(0xFF8DEBFF),
        Color(0xFF70BCEB),
      ],
    );

    _drawRobotFace(canvas, time);
  }

  // --------------------------------------------------
  // NOVA - FLYING UFO
  // --------------------------------------------------

  static void _drawNova(Canvas canvas, double time) {
    final hover = math.sin(time * 4) * 3;

    canvas.save();
    canvas.translate(0, hover);

    // UFO top dome
    canvas.drawOval(
      const Rect.fromLTWH(-14, -31, 28, 28),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFE5F5FF),
            Color(0xFF7D9CFF),
            Color(0xFF5369D9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(-14, -31, 28, 28)),
    );

    // Glass shine
    canvas.drawOval(
      const Rect.fromLTWH(-8, -26, 7, 12),
      Paint()..color = const Color(0xAAFFFFFF),
    );

    // UFO body
    canvas.drawOval(
      const Rect.fromLTWH(-27, -12, 54, 24),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFB9C8FF),
            Color(0xFF728BFF),
            Color(0xFF4658C9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(-27, -12, 54, 24)),
    );

    // Bottom rim
    canvas.drawArc(
      const Rect.fromLTWH(-25, -5, 50, 20),
      0,
      math.pi,
      false,
      Paint()
        ..color = const Color(0xFF293A9A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Glowing UFO lights
    for (int i = 0; i < 5; i++) {
      final x = -17.0 + i * 8.5;
      final pulse = 0.6 + 0.4 * math.sin(time * 5 + i);

      canvas.drawCircle(
        Offset(x, 1),
        2.5,
        Paint()..color = const Color(0xFFB9FFFF).withOpacity(pulse),
      );
    }

    // Small floating side lights
    canvas.drawCircle(
      const Offset(-29, -2),
      3,
      Paint()..color = const Color(0xFFFF91C8),
    );
    canvas.drawCircle(
      const Offset(29, -2),
      3,
      Paint()..color = const Color(0xFFFF91C8),
    );

    // Alien eyes
    canvas.drawOval(
      const Rect.fromLTWH(-9, -22, 5, 9),
      Paint()..color = const Color(0xFF24305F),
    );
    canvas.drawOval(
      const Rect.fromLTWH(4, -22, 5, 9),
      Paint()..color = const Color(0xFF24305F),
    );

    // UFO energy beam
    final beamPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0x557DFFFF),
          Color(0x007DFFFF),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(const Rect.fromLTWH(-17, 10, 34, 16));

    final beam = Path()
      ..moveTo(-13, 10)
      ..lineTo(13, 10)
      ..lineTo(18, 25)
      ..lineTo(-18, 25)
      ..close();

    canvas.drawPath(beam, beamPaint);

    canvas.restore();
  }

  // --------------------------------------------------
  // BIBI - CUTE CAT
  // --------------------------------------------------

  static void _drawBibi(Canvas canvas, double time) {
    final earWiggle = math.sin(time * 4) * 1.5;

    // Ears
    final leftEar = Path()
      ..moveTo(-20, -17)
      ..lineTo(-23, -37 + earWiggle)
      ..lineTo(-6, -26)
      ..close();

    final rightEar = Path()
      ..moveTo(20, -17)
      ..lineTo(23, -37 - earWiggle)
      ..lineTo(6, -26)
      ..close();

    canvas.drawPath(
      leftEar,
      Paint()..color = const Color(0xFFE96EAF),
    );
    canvas.drawPath(
      rightEar,
      Paint()..color = const Color(0xFFE96EAF),
    );

    // Inner ears
    final innerLeft = Path()
      ..moveTo(-19, -23)
      ..lineTo(-20, -32)
      ..lineTo(-11, -26)
      ..close();

    final innerRight = Path()
      ..moveTo(19, -23)
      ..lineTo(20, -32)
      ..lineTo(11, -26)
      ..close();

    canvas.drawPath(
      innerLeft,
      Paint()..color = const Color(0xFFFFC2E2),
    );
    canvas.drawPath(
      innerRight,
      Paint()..color = const Color(0xFFFFC2E2),
    );

    // Cat body
    _rounded(
      canvas,
      const Rect.fromLTWH(-20, -17, 40, 36),
      16,
      const Color(0xFFFFB5DF),
      gradient: const [
        Color(0xFFFFF4FB),
        Color(0xFFFFB5DF),
        Color(0xFFE96EAF),
      ],
    );

    // Tail
    final tail = Path()
      ..moveTo(17, 10)
      ..quadraticBezierTo(36, 5, 28, -9);

    canvas.drawPath(
      tail,
      Paint()
        ..color = const Color(0xFFE96EAF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    // Eyes
    canvas.drawCircle(
      const Offset(-8, -2),
      3,
      Paint()..color = const Color(0xFF49305F),
    );
    canvas.drawCircle(
      const Offset(8, -2),
      3,
      Paint()..color = const Color(0xFF49305F),
    );

    // Nose
    final nose = Path()
      ..moveTo(-3, 5)
      ..lineTo(3, 5)
      ..lineTo(0, 9)
      ..close();

    canvas.drawPath(
      nose,
      Paint()..color = const Color(0xFFFF5DAB),
    );

    // Whiskers
    final whiskerPaint = Paint()
      ..color = const Color(0xFFB34C88)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(-10, 6),
      const Offset(-23, 3),
      whiskerPaint,
    );
    canvas.drawLine(
      const Offset(-10, 10),
      const Offset(-23, 12),
      whiskerPaint,
    );
    canvas.drawLine(
      const Offset(10, 6),
      const Offset(23, 3),
      whiskerPaint,
    );
    canvas.drawLine(
      const Offset(10, 10),
      const Offset(23, 12),
      whiskerPaint,
    );

    // Cheeks
    canvas.drawCircle(
      const Offset(-13, 7),
      3.5,
      Paint()..color = const Color(0xFFFF80B9).withOpacity(.8),
    );
    canvas.drawCircle(
      const Offset(13, 7),
      3.5,
      Paint()..color = const Color(0xFFFF80B9).withOpacity(.8),
    );

    // Feet
    canvas.drawOval(
      const Rect.fromLTWH(-16, 14, 12, 10),
      Paint()..color = const Color(0xFFE96EAF),
    );
    canvas.drawOval(
      const Rect.fromLTWH(4, 14, 12, 10),
      Paint()..color = const Color(0xFFE96EAF),
    );

    // Star accessory
    _drawSmallStar(
      canvas,
      const Offset(15, -24),
      5,
      const Color(0xFFFFE477),
    );
  }

  // BOLT - CUTE BABY DRAGON 🐉

  static void _drawBolt(Canvas canvas, double time) {
    final hover = math.sin(time * 4) * 2.5;
    final wingFlap = math.sin(time * 10) * 0.18;
    final tailWiggle = math.sin(time * 5) * 5;

    canvas.save();
    canvas.translate(0, hover);

    // Tail
    final tail = Path()
      ..moveTo(15, 10)
      ..quadraticBezierTo(
        34 + tailWiggle,
        8,
        29 + tailWiggle,
        -8,
      )
      ..quadraticBezierTo(
        38 + tailWiggle,
        -15,
        40 + tailWiggle,
        -5,
      );

    canvas.drawPath(
      tail,
      Paint()
        ..color = const Color(0xFF8B65E8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    // Tail tip
    final tailTip = Path()
      ..moveTo(36 + tailWiggle, -8)
      ..lineTo(44 + tailWiggle, -17)
      ..lineTo(43 + tailWiggle, -4)
      ..close();

    canvas.drawPath(
      tailTip,
      Paint()..color = const Color(0xFFFF91C8),
    );

    // Left wing
    canvas.save();
    canvas.rotate(-wingFlap);
    final leftWing = Path()
      ..moveTo(-13, -7)
      ..quadraticBezierTo(-38, -34, -35, -8)
      ..quadraticBezierTo(-30, 5, -16, 10)
      ..close();

    canvas.drawPath(
      leftWing,
      Paint()..color = const Color(0xFF9B7AFF),
    );
    canvas.restore();

    // Right wing
    canvas.save();
    canvas.rotate(wingFlap);
    final rightWing = Path()
      ..moveTo(13, -7)
      ..quadraticBezierTo(38, -34, 35, -8)
      ..quadraticBezierTo(30, 5, 16, 10)
      ..close();

    canvas.drawPath(
      rightWing,
      Paint()..color = const Color(0xFF9B7AFF),
    );
    canvas.restore();

    // Little horns
    final hornPaint = Paint()
      ..color = const Color(0xFFFFD77D);

    final leftHorn = Path()
      ..moveTo(-15, -19)
      ..lineTo(-22, -34)
      ..lineTo(-7, -25)
      ..close();

    final rightHorn = Path()
      ..moveTo(15, -19)
      ..lineTo(22, -34)
      ..lineTo(7, -25)
      ..close();

    canvas.drawPath(leftHorn, hornPaint);
    canvas.drawPath(rightHorn, hornPaint);

    // Dragon body glow
    canvas.drawOval(
      const Rect.fromLTWH(-25, -25, 50, 50),
      Paint()
        ..color = const Color(0xFF9B7AFF).withOpacity(.35)
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          10,
        ),
    );

    // Body
    final bodyRect = const Rect.fromLTWH(-22, -25, 44, 45);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bodyRect,
        const Radius.circular(19),
      ),
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFFE5D5FF),
            Color(0xFFAA8AFF),
            Color(0xFF7854CE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bodyRect),
    );

    // Belly
    canvas.drawOval(
      const Rect.fromLTWH(-12, 0, 24, 16),
      Paint()..color = const Color(0xFFFFD9A5),
    );

    // Eyes
    canvas.drawCircle(
      const Offset(-8, -8),
      3.5,
      Paint()..color = const Color(0xFF33264F),
    );

    canvas.drawCircle(
      const Offset(8, -8),
      3.5,
      Paint()..color = const Color(0xFF33264F),
    );

    // Eye shine
    canvas.drawCircle(
      const Offset(-9, -9),
      1.2,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      const Offset(7, -9),
      1.2,
      Paint()..color = Colors.white,
    );

    // Cute smile
    final smile = Path()
      ..moveTo(-5, 1)
      ..quadraticBezierTo(0, 7, 5, 1);

    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF49305F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Cheeks
    canvas.drawCircle(
      const Offset(-15, 1),
      3.5,
      Paint()..color = const Color(0xFFFF91C8),
    );

    canvas.drawCircle(
      const Offset(15, 1),
      3.5,
      Paint()..color = const Color(0xFFFF91C8),
    );

    // Feet
    canvas.drawOval(
      const Rect.fromLTWH(-17, 15, 13, 9),
      Paint()..color = const Color(0xFF7854CE),
    );

    canvas.drawOval(
      const Rect.fromLTWH(4, 15, 13, 9),
      Paint()..color = const Color(0xFF7854CE),
    );

    canvas.restore();
  }



  // --------------------------------------------------
  // SHARED DRAWING HELPERS
  // --------------------------------------------------

  static void _drawRobotFeet(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFF6B75C9);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-16, 13, 13, 12),
        const Radius.circular(5),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(3, 13, 13, 12),
        const Radius.circular(5),
      ),
      paint,
    );
  }

  static void _drawRobotFace(Canvas canvas, double time) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-15, -18, 30, 25),
        const Radius.circular(9),
      ),
      Paint()..color = const Color(0xFF26345F),
    );

    final blink = math.sin(time * 1.7) > 0.985 ? 2.0 : 5.0;

    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(-7, -7),
        width: 5,
        height: blink,
      ),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(7, -7),
        width: 5,
        height: blink,
      ),
      Paint()..color = const Color(0xFFFFFFFF),
    );

    canvas.drawCircle(
      const Offset(-12, 2),
      4,
      Paint()..color = const Color(0xFFFF91C8).withOpacity(.8),
    );

    canvas.drawCircle(
      const Offset(12, 2),
      4,
      Paint()..color = const Color(0xFFFF91C8).withOpacity(.8),
    );

    final smile = Path()
      ..moveTo(-4, 2)
      ..quadraticBezierTo(0, 7, 4, 2);

    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );
  }

  static void _rounded(
      Canvas canvas,
      Rect rect,
      double radius,
      Color color, {
        bool glow = false,
        List<Color>? gradient,
      }) {
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(radius),
    );

    if (glow) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = color.withOpacity(.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    final paint = Paint();

    if (gradient != null) {
      paint.shader = LinearGradient(
        colors: gradient,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    } else {
      paint.color = color;
    }

    canvas.drawRRect(rrect, paint);

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0x55FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  static void _drawStarShape(
      Canvas canvas,
      double radius,
      Paint paint,
      ) {
    final path = Path();

    for (int i = 0; i < 10; i++) {
      final r = i.isEven ? radius : radius * .48;
      final angle = -math.pi / 2 + i * math.pi / 5;

      final point = Offset(
        math.cos(angle) * r,
        math.sin(angle) * r,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  static void _drawSmallStar(
      Canvas canvas,
      Offset center,
      double radius,
      Color color,
      ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);

    _drawStarShape(
      canvas,
      radius,
      Paint()..color = color,
    );

    canvas.restore();
  }
}
