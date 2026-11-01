
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../game/gravity_flip_game.dart';
import 'music_toggle.dart';

class LevelCompleteOverlay extends StatefulWidget {
  final GravityFlipGame game;

  const LevelCompleteOverlay({
    super.key,
    required this.game,
  });

  @override
  State<LevelCompleteOverlay> createState() =>
      _LevelCompleteOverlayState();
}

class _LevelCompleteOverlayState extends State<LevelCompleteOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;

  GravityFlipGame get game => widget.game;

  bool get isLastLevel => game.level >= 20;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _glowAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xE6100D29),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 400;

          return Stack(
            children: [
              // BACKGROUND DECORATION
              const Positioned(
                top: -75,
                left: -65,
                child: _GlowOrb(
                  size: 210,
                  color: Color(0xFF9B62FF),
                ),
              ),

              const Positioned(
                bottom: -85,
                right: -70,
                child: _GlowOrb(
                  size: 230,
                  color: Color(0xFFFF65B8),
                ),
              ),

              // FLOATING STARS
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _CelebrationPainter(
                          _controller.value,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // MAIN CONTENT
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    18,
                    compact ? 62 : 68,
                    18,
                    22,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 390,
                      ),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(
                                compact ? 20 : 28,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF211A49),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFFFF91C8)
                                      .withOpacity(.65),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF83C7)
                                        .withOpacity(
                                      .10 + _glowAnimation.value * .17,
                                    ),
                                    blurRadius:
                                    25 + _glowAnimation.value * 20,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFF70E8FF)
                                        .withOpacity(.08),
                                    blurRadius: 35,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildAchievementBadge(compact),

                                  const SizedBox(height: 23),

                                  _buildHeading(compact),

                                  const SizedBox(height: 10),

                                  Text(
                                    isLastLevel
                                        ? 'You conquered every challenge!'
                                        : 'Amazing work! Pip is proud of you 💗',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.78),
                                      fontSize: compact ? 12 : 14,
                                      height: 1.5,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  _buildStarsPanel(compact),

                                  const SizedBox(height: 20),

                                  _buildProgressIndicator(),

                                  const SizedBox(height: 25),

                                  if (!isLastLevel)
                                    _buildNextButton(),

                                  if (!isLastLevel)
                                    const SizedBox(height: 11),

                                  _buildChooseLevelButton(),

                                  const SizedBox(height: 15),

                                  Text(
                                    isLastLevel
                                        ? 'YOU ARE A GRAVITY FLIP CHAMPION!'
                                        : 'KEEP EXPLORING THE COSMOS',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF70E8FF)
                                          .withOpacity(.7),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // MUSIC ON / OFF
              const Positioned(
                top: 8,
                right: 8,
                child: MusicToggle(compact: true),
              ),
            ],
          );
        },
      ),
    );
  }

  // ACHIEVEMENT BADGE

  Widget _buildAchievementBadge(bool compact) {
    return Container(
      width: compact ? 105 : 120,
      height: compact ? 105 : 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD86F),
            Color(0xFFFF91C8),
            Color(0xFF9B6BFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF91C8).withOpacity(.35),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF30245F),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isLastLevel
                    ? Icons.emoji_events_rounded
                    : Icons.workspace_premium_rounded,
                color: const Color(0xFFFFE477),
                size: compact ? 39 : 46,
              ),
              const SizedBox(height: 3),
              Text(
                isLastLevel ? 'CHAMPION' : 'CLEARED',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // HEADING

  Widget _buildHeading(bool compact) {
    return Column(
      children: [
        Text(
          isLastLevel ? 'YOU DID IT!' : 'LEVEL ${game.level}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 27 : 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: const Color(0xFF70E8FF).withOpacity(.55),
                blurRadius: 18,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          isLastLevel ? 'GALAXY MASTER!' : 'LEVEL COMPLETE!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFFF91C8),
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // STARS PANEL

  Widget _buildStarsPanel(bool compact) {
    final totalStars = game.stars.length;
    final collected = game.starsCollected
        .clamp(0, totalStars)
        .toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF171437),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFE477).withOpacity(.25),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'YOUR COSMIC REWARD',
            style: TextStyle(
              color: Color(0xFF70E8FF),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),

          const SizedBox(height: 13),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: compact ? 2 : 5,
            runSpacing: 4,
            children: List.generate(totalStars, (index) {
              final active = index < collected;

              return Icon(
                Icons.star_rounded,
                size: totalStars > 8 ? 25 : (compact ? 34 : 42),
                color: active
                    ? const Color(0xFFFFE477)
                    : Colors.white.withOpacity(.15),
                shadows: active
                    ? [
                  const Shadow(
                    color: Color(0xFFFFC857),
                    blurRadius: 16,
                  ),
                ]
                    : null,
              );
            }),
          ),

          const SizedBox(height: 10),

          Text(
            '$collected / $totalStars STARS COLLECTED',
            style: const TextStyle(
              color: Color(0xFFFFE477),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // LEVEL PROGRESS

  Widget _buildProgressIndicator() {
    final progress = game.level.clamp(1, 20) / 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'GALAXY PROGRESS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            Text(
              '${game.level} / 20',
              style: const TextStyle(
                color: Color(0xFF70E8FF),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(.10),
            valueColor: const AlwaysStoppedAnimation(
              Color(0xFF70E8FF),
            ),
          ),
        ),
      ],
    );
  }

  // NEXT LEVEL BUTTON

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFF91C8),
              Color(0xFFFFB2A8),
              Color(0xFFFFD86F),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF83C7).withOpacity(.25),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: game.goToNextLevel,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF241747),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NEXT LEVEL ${game.level + 1}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                ),
              ),
              const SizedBox(width: 9),
              const Icon(
                Icons.rocket_launch_rounded,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CHOOSE LEVEL BUTTON

  Widget _buildChooseLevelButton() {
    return SizedBox(
      width: double.infinity,
      height: 49,
      child: OutlinedButton(
        onPressed: game.showLevelSelection,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(
            color: const Color(0xFF70E8FF).withOpacity(.65),
            width: 1.3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_view_rounded, size: 17),
            SizedBox(width: 8),
            Text(
              'CHOOSE LEVEL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BACKGROUND GLOW

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(.20),
              color.withOpacity(.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// CELEBRATION PARTICLES

class _CelebrationPainter extends CustomPainter {
  final double progress;

  _CelebrationPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    for (int i = 0; i < 28; i++) {
      final x = (i * 79.0) % size.width;

      final startY = (i * 53.0) % size.height;

      final y = (startY +
          progress * (80 + (i % 5) * 35)) %
          size.height;

      final opacity = .15 +
          .55 *
              ((math.sin(progress * math.pi * 2 + i) + 1) / 2);

      final radius = 1.5 + (i % 3);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = (i.isEven
              ? const Color(0xFFFFE477)
              : const Color(0xFF70E8FF))
              .withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _CelebrationPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}
