
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../components/pip.dart';
import '../game/game_audio.dart';
import '../game/gravity_flip_game.dart';
import 'music_toggle.dart';

class StartScreen extends StatefulWidget {
  final GravityFlipGame game;

  const StartScreen({
    super.key,
    required this.game,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late final AnimationController backgroundController;
  late final AnimationController pulseController;
  late final AnimationController characterController;

  bool soundReady = false;

  @override
  void initState() {
    super.initState();

    backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    characterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await GameAudio.initialize();
    } catch (error) {
      debugPrint('Audio initialization failed: $error');
    }

    if (mounted) {
      setState(() {
        soundReady = true;
      });
    }
  }

  @override
  void dispose() {
    backgroundController.dispose();
    pulseController.dispose();
    characterController.dispose();
    super.dispose();
  }

  void _startGame() {
    if (!soundReady) return;

    GameAudio.click();
    widget.game.showLoadingScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0B102C),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 650;
          final isShort = constraints.maxHeight < 650;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ANIMATED SPACE BACKGROUND
              AnimatedBuilder(
                animation: backgroundController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _SpaceBackgroundPainter(
                      backgroundController.value,
                    ),
                  );
                },
              ),

              // TOP GLOW
              Positioned(
                top: -130,
                left: constraints.maxWidth * .2,
                child: _glowCircle(
                  300,
                  const Color(0xFF5543CF),
                ),
              ),

              // BOTTOM GLOW
              Positioned(
                bottom: -150,
                right: -80,
                child: _glowCircle(
                  320,
                  const Color(0xFFB83DAB),
                ),
              ),

              // MAIN CONTENT
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, screenConstraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenConstraints.maxHeight,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: isMobile
                                ? _mobileLayout(
                              context,
                              isShort,
                            )
                                : Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35,
                                  vertical: 25,
                                ),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 1000,
                                  ),
                                  child: _desktopLayout(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // MUSIC ON / OFF TOGGLE
              Positioned(
                top: 12,
                right: 14,
                child: SafeArea(
                  child: const MusicToggle(compact: true),
                ),
              ),

              // VERSION LABEL
              Positioned(
                bottom: 10,
                right: 14,
                child: IgnorePointer(
                  child: Text(
                    'GRAVITY FLIP  •  2026',
                    style: TextStyle(
                      color: Colors.white.withOpacity(.35),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --------------------------------------------------
  // DESKTOP LAYOUT
  // --------------------------------------------------

  Widget _desktopLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xAA17183F),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0x558DEEFF),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5543CF).withOpacity(.17),
            blurRadius: 45,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 11,
            child: _heroContent(context, false),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 9,
            child: _characterShowcase(false),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // FULL SCREEN MOBILE LAYOUT
  // --------------------------------------------------

  Widget _mobileLayout(
      BuildContext context,
      bool isShort,
      ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 500,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 22,
        vertical: isShort ? 12 : 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xAA17183F),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _characterShowcase(true),
          SizedBox(height: isShort ? 8 : 16),
          _heroContent(context, true),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // HERO CONTENT
  // --------------------------------------------------

  Widget _heroContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // GAME LABEL
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF70E8FF).withOpacity(.10),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: const Color(0xFF70E8FF).withOpacity(.5),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Color(0xFF70E8FF),
                size: 14,
              ),
              SizedBox(width: 7),
              Text(
                'A COSMIC ADVENTURE',
                style: TextStyle(
                  color: Color(0xFF70E8FF),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // TITLE
        AnimatedBuilder(
          animation: pulseController,
          builder: (context, child) {
            final glow = 12 + pulseController.value * 12;

            return Text(
              'GRAVITY\nFLIP',
              textAlign: isMobile ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                fontSize: isMobile ? 43 : 58,
                height: .98,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFF70E8FF),
                      Color(0xFFFF91C8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(
                    const Rect.fromLTWH(0, 0, 400, 130),
                  ),
                shadows: [
                  Shadow(
                    color: const Color(0xFF70E8FF).withOpacity(.55),
                    blurRadius: glow,
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 13),

        Text(
          'Defy gravity. Explore the unknown.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            color: Color(0xFFFF91C8),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Flip your world upside down, dodge dangerous obstacles, '
              'collect cosmic stars and find your way to the portal!',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: Colors.white.withOpacity(.72),
            fontSize: 13,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 22),

        // FEATURE CHIPS
        Wrap(
          alignment: isMobile
              ? WrapAlignment.center
              : WrapAlignment.start,
          spacing: 9,
          runSpacing: 9,
          children: [
            _feature(Icons.layers_rounded, '20 LEVELS'),
            _feature(Icons.swap_vert_rounded, 'GRAVITY FLIP'),
            _feature(Icons.star_rounded, 'COLLECT STARS'),
          ],
        ),

        const SizedBox(height: 25),

        // PLAY BUTTON
        AnimatedBuilder(
          animation: pulseController,
          builder: (context, child) {
            return Container(
              width: isMobile ? double.infinity : 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF83C7).withOpacity(
                      .15 + pulseController.value * .25,
                    ),
                    blurRadius: 15 + pulseController.value * 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: soundReady ? _startGame : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF83C7),
                    disabledBackgroundColor: const Color(0xFF725579),
                    foregroundColor: const Color(0xFF241747),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: soundReady
                      ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 25,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'PLAY NOW',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.rocket_launch_rounded,
                        size: 17,
                      ),
                    ],
                  )
                      : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 17,
                        width: 17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 7),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'PREPARING GAME...',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 15),

        // CONTROLS HELP
        Text(
          isMobile
              ? 'USE ON-SCREEN CONTROLS TO PLAY'
              : 'MOVE: A / D OR ← →     •     FLIP: SPACE / ↑',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(.48),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: .8,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // CHARACTER SHOWCASE
  // --------------------------------------------------

  Widget _characterShowcase(bool isMobile) {
    return AnimatedBuilder(
      animation: characterController,
      builder: (context, child) {
        final float = math.sin(
          characterController.value * math.pi,
        ) * 9;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: isMobile ? 175 : 270,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // GLOW
                  Container(
                    width: isMobile ? 145 : 220,
                    height: isMobile ? 145 : 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF70E8FF).withOpacity(.23),
                          const Color(0xFF9B6BFF).withOpacity(.08),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // ORBIT
                  Transform.rotate(
                    angle: characterController.value * math.pi,
                    child: Container(
                      width: isMobile ? 145 : 210,
                      height: isMobile ? 145 : 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x5570E8FF),
                          width: 1.3,
                        ),
                      ),
                    ),
                  ),

                  // PIP
                  Transform.translate(
                    offset: Offset(0, float),
                    child: SizedBox(
                      width: 125,
                      height: 125,
                      child: CustomPaint(
                        painter: _HeroCharacterPainter(
                          characterController.value,
                        ),
                      ),
                    ),
                  ),

                  // FLOATING STARS
                  const Positioned(
                    top: 20,
                    right: 35,
                    child: Icon(
                      Icons.auto_awesome,
                      color: Color(0xFFFFE477),
                      size: 22,
                    ),
                  ),

                  const Positioned(
                    bottom: 25,
                    left: 30,
                    child: Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFF91C8),
                      size: 19,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'MEET YOUR HERO',
              style: TextStyle(
                color: Color(0xFF70E8FF),
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'PIP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Your little space companion',
              style: TextStyle(
                color: Colors.white.withOpacity(.55),
                fontSize: 11,
              ),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------
  // FEATURE CHIP
  // --------------------------------------------------

  Widget _feature(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.055),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: const Color(0xFFFFE477),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: .3,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BACKGROUND GLOW
  // --------------------------------------------------

  Widget _glowCircle(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(.19),
              color.withOpacity(.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// PIP PAINTER
// --------------------------------------------------

class _HeroCharacterPainter extends CustomPainter {
  final double time;

  const _HeroCharacterPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(
      size.width / 2,
      size.height / 2 + 5,
    );

    canvas.scale(1.65);

    Pip.draw(
      canvas,
      Offset.zero,
      time * 4,
      grounded: true,
      facing: 1,
      characterIndex: 0,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(
      covariant _HeroCharacterPainter oldDelegate,
      ) {
    return oldDelegate.time != time;
  }
}

// --------------------------------------------------
// ANIMATED SPACE BACKGROUND
// --------------------------------------------------

class _SpaceBackgroundPainter extends CustomPainter {
  final double progress;

  _SpaceBackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF111633),
          Color(0xFF17143D),
          Color(0xFF251746),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      background,
    );

    // STARS
    for (int i = 0; i < 85; i++) {
      final x = (i * 73.0) % size.width;
      final rawY = (i * 47.0) % size.height;

      final y = (rawY + progress * (15 + i % 20)) %
          size.height;

      final opacity = .25 +
          .65 *
              ((math.sin(progress * math.pi * 2 + i) + 1) / 2);

      final radius = 1.0 + (i % 3) * .6;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(opacity),
      );
    }

    // FLOATING COSMIC ORBS
    for (int i = 0; i < 9; i++) {
      final x = size.width * (.08 + ((i * 17) % 85) / 100);
      final y = size.height * (.12 + ((i * 23) % 75) / 100);
      final radius = 3.0 + (i % 4) * 2.0;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = const Color(0xFF70E8FF).withOpacity(.12),
      );

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = const Color(0xFF70E8FF).withOpacity(.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // NEON HORIZON
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0x5570E8FF),
          Color(0x66FF91C8),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          size.height * .82,
          size.width,
          2,
        ),
      )
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height * .82),
      Offset(size.width, size.height * .82),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _SpaceBackgroundPainter oldDelegate,
      ) {
    return oldDelegate.progress != progress;
  }
}
