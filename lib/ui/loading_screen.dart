
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'music_toggle.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _pulseController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 500;

    return Material(
      color: const Color(0xFF090D20),
      child: Stack(
        children: [
          // Galaxy background.
          Positioned.fill(
            child: CustomPaint(
              painter: _GalaxyPainter(
                animation: _controller,
                pulse: _pulseController,
              ),
            ),
          ),

          // Music toggle.
          Positioned(
            top: 12,
            right: 14,
            child: SafeArea(
              child: MusicToggle(compact: true),
            ),
          ),

          // Main loading content.
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 35,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 460,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPlanet(compact),

                      const SizedBox(height: 32),

                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFFFFE58A),
                              Color(0xFFFF91D0),
                              Color(0xFF9C8CFF),
                            ],
                          ).createShader(bounds);
                        },
                        child: Text(
                          'GRAVITY FLIP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 27 : 35,
                            fontWeight: FontWeight.w900,
                            letterSpacing: compact ? 3 : 5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'YOUR NEXT COSMIC ADVENTURE BEGINS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF9EAAD0),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildLoadingCard(compact),

                      const SizedBox(height: 25),

                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.55 +
                                _pulseController.value * 0.45,
                            child: child,
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFFFD978),
                              size: 15,
                            ),
                            SizedBox(width: 9),
                            Text(
                              'GET READY, GALAXY HERO!',
                              style: TextStyle(
                                color: Color(0xFFB8B9E8),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.8,
                              ),
                            ),
                            SizedBox(width: 9),
                            Icon(
                              Icons.auto_awesome,
                              color: Color(0xFFFFD978),
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanet(bool compact) {
    final planetSize = compact ? 145.0 : 180.0;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _controller,
        _pulseController,
      ]),
      builder: (context, child) {
        final pulse = _pulseController.value;

        return SizedBox(
          width: planetSize + 45,
          height: planetSize + 45,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow.
              Container(
                width: planetSize + 25,
                height: planetSize + 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8C65FF)
                          .withValues(alpha: 0.12 + pulse * 0.12),
                      blurRadius: 45 + pulse * 15,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),

              // Rotating orbit.
              Transform.rotate(
                angle: _controller.value * math.pi * 2,
                child: Container(
                  width: planetSize + 20,
                  height: planetSize * 0.42,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF7FE8FF)
                          .withValues(alpha: 0.7),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              // Planet.
              Container(
                width: planetSize * 0.72,
                height: planetSize * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    center: Alignment(-0.35, -0.4),
                    radius: 1.1,
                    colors: [
                      Color(0xFFFFD98D),
                      Color(0xFFFC8CBF),
                      Color(0xFF895BDF),
                      Color(0xFF34266D),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB06BFF)
                          .withValues(alpha: 0.35 + pulse * 0.15),
                      blurRadius: 35,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '🪐',
                    style: TextStyle(
                      fontSize: compact ? 62 : 78,
                    ),
                  ),
                ),
              ),

              // Orbiting small moon.
              Transform.rotate(
                angle: -_controller.value * math.pi * 2,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFE58A),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFE58A),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard(bool compact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 20 : 26),
      decoration: BoxDecoration(
        color: const Color(0xFF171D3A).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF7476B8).withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7864FF).withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bolt_rounded,
                color: Color(0xFFFFD978),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'PREPARING YOUR ADVENTURE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 9,
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: null,
                    backgroundColor: const Color(0xFF343B63),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(
                        const Color(0xFFFF86CB),
                        const Color(0xFF79E8FF),
                        _progressController.value,
                      )!,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 17),

          const Text(
            'Loading levels, characters & cosmic vibes...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFADB8DA),
              fontSize: 12,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          const Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            runSpacing: 10,
            children: [
              _LoadingFeature(
                icon: Icons.layers_rounded,
                label: 'LEVELS',
              ),
              _LoadingFeature(
                icon: Icons.face_rounded,
                label: 'HEROES',
              ),
              _LoadingFeature(
                icon: Icons.stars_rounded,
                label: 'STARS',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingFeature extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LoadingFeature({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: const Color(0xFF8DE9FF),
          size: 14,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFADB8DA),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  final Animation<double> animation;
  final Animation<double> pulse;

  _GalaxyPainter({
    required this.animation,
    required this.pulse,
  }) : super(repaint: Listenable.merge([animation, pulse]));

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    // Background glow.
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF49368F).withValues(alpha: 0.30),
          const Color(0xFF151B3A).withValues(alpha: 0.10),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.45),
          radius: size.width * 0.75,
        ),
      );

    canvas.drawRect(
      Offset.zero & size,
      glowPaint,
    );

    // Twinkling stars.
    for (int i = 0; i < 90; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      final y = (baseY +
          math.sin(animation.value * math.pi * 2 + i) * 8) %
          size.height;

      final opacity = 0.2 +
          (0.5 + 0.5 *
              math.sin(
                animation.value * math.pi * 2 + i * 0.7,
              )) *
              0.55;

      final radius = random.nextDouble() * 1.5 + 0.4;

      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    // Floating cosmic particles.
    for (int i = 0; i < 12; i++) {
      final x = (i * 83.0 + animation.value * 45) %
          (size.width + 30);

      final y = (i * 67.0 +
          math.sin(animation.value * math.pi * 2 + i) * 25) %
          size.height;

      final particlePaint = Paint()
        ..color = const Color(0xFF8DE9FF).withValues(
          alpha: 0.25 + pulse.value * 0.35,
        );

      canvas.drawCircle(
        Offset(x, y),
        2,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.pulse != pulse;
  }
}
