
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/gravity_flip_game.dart';
import 'music_toggle.dart';

class GameOverOverlay extends StatefulWidget {
  final GravityFlipGame game;

  const GameOverOverlay({
    super.key,
    required this.game,
  });

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _glowController;
  late final AnimationController _floatController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 400;

    return Material(
      color: const Color(0xEE100B27),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GameOverBackgroundPainter(
                animation: _floatController,
              ),
            ),
          ),

          // Music control.
          Positioned(
            top: 10,
            right: 12,
            child: SafeArea(
              child: MusicToggle(compact: true),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 380,
                      ),
                      child: AnimatedBuilder(
                        animation: _glowController,
                        builder: (context, child) {
                          final glow = _glowController.value;

                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              compact ? 20 : 28,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF38245F),
                                  Color(0xFF21163F),
                                  Color(0xFF17112F),
                                ],
                              ),
                              border: Border.all(
                                color: Color.lerp(
                                  const Color(0xFFFF80C8),
                                  const Color(0xFFB78BFF),
                                  glow,
                                )!,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF65B5)
                                      .withValues(
                                    alpha: 0.15 + glow * 0.2,
                                  ),
                                  blurRadius: 22 + glow * 14,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: child,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCharacter(compact),

                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF80C8)
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFFF80C8)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: const Text(
                                'MISSION FAILED',
                                style: TextStyle(
                                  color: Color(0xFFFFA6D7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'OH NO, ${widget.game.characters[widget.game.selectedCharacter]}!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: compact ? 25 : 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                                shadows: const [
                                  Shadow(
                                    color: Color(0xFFFF69B4),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 9),

                            const Text(
                              'The galaxy needs you!\n'
                                  'All lives are gone. But heroes never give up.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFC9BCE8),
                                fontSize: 13,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 22),

                            _buildStats(compact),

                            const SizedBox(height: 24),

                            _buildRetryButton(),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed:
                                widget.game.showLevelSelection,
                                icon: const Icon(
                                  Icons.grid_view_rounded,
                                  size: 18,
                                ),
                                label: const Text('LEVEL SELECTION'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFF9B83C9),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'DON’T GIVE UP, GALAXY HERO!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF9986BD),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter(bool compact) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            math.sin(_floatController.value * math.pi) * -8,
          ),
          child: child,
        );
      },
      child: Container(
        width: compact ? 104 : 122,
        height: compact ? 104 : 122,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFF70438F),
              Color(0xFF39245F),
              Color(0xFF25173F),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFFF91CA),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF70BC)
                  .withValues(alpha: 0.35),
              blurRadius: 28,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            '🥺',
            style: TextStyle(
              fontSize: compact ? 55 : 66,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats(bool compact) {
    final game = widget.game;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF17112F).withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8062AD).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(
            icon: Icons.flag_rounded,
            label: 'LEVEL',
            value: '${game.level}',
            color: const Color(0xFFB89AFF),
            compact: compact,
          ),

          _statDivider(),

          _statItem(
            icon: Icons.star_rounded,
            label: 'STARS',
            value: '${game.starsCollected}/${game.stars.length}',
            color: const Color(0xFFFFD76A),
            compact: compact,
          ),

          _statDivider(),

          _statItem(
            icon: Icons.favorite_rounded,
            label: 'LIVES',
            value: '${game.lives}',
            color: const Color(0xFFFF83B8),
            compact: compact,
          ),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(
      width: 1,
      height: 42,
      color: const Color(0xFF70578F),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool compact,
  }) {
    return Flexible(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: compact ? 19 : 21,
          ),

          const SizedBox(height: 6),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 16 : 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFAA9AC9),
              fontSize: compact ? 8 : 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFA1D5),
              Color(0xFFFF69B4),
              Color(0xFFCE70FF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF69B4)
                  .withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: widget.game.restart,
          icon: const Icon(
            Icons.refresh_rounded,
            size: 23,
          ),
          label: const Text(
            'RETRY LEVEL',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF29153F),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameOverBackgroundPainter extends CustomPainter {
  final Animation<double> animation;

  _GameOverBackgroundPainter({
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(24);

    for (int i = 0; i < 45; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      final y = (baseY +
          math.sin(animation.value * math.pi * 2 + i) * 12) %
          size.height;

      final radius = random.nextDouble() * 1.8 + 0.5;

      final paint = Paint()
        ..color = const Color(0xFFFFB5E1).withValues(
          alpha: 0.2 + random.nextDouble() * 0.5,
        );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFB35CFF).withValues(alpha: 0.13),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * 0.5,
            size.height * 0.5,
          ),
          radius: size.width * 0.7,
        ),
      );

    canvas.drawRect(
      Offset.zero & size,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _GameOverBackgroundPainter oldDelegate,
      ) {
    return oldDelegate.animation != animation;
  }
}
