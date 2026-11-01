
import 'package:flutter/material.dart';

import '../components/pip.dart';
import '../game/game_audio.dart';
import '../game/gravity_flip_game.dart';
import 'music_toggle.dart';

class CharacterSelectScreen extends StatelessWidget {
  final GravityFlipGame game;

  const CharacterSelectScreen({
    super.key,
    required this.game,
  });

  static const List<String> names = [
    'Pip',
    'Nova',
    'Bibi',
    'Bolt',
  ];

  static const List<String> descriptions = [
    'Your friendly little robot',
    'A cosmic space explorer',
    'A playful little cat',
    'A shining star hero',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;

          final availableWidth =
          screenWidth > 0 ? screenWidth : 360.0;

          final isMobile = availableWidth < 600;
          final horizontalPadding = isMobile ? 16.0 : 32.0;
          const spacing = 12.0;

          final contentWidth = (availableWidth - horizontalPadding * 2)
              .clamp(0.0, double.infinity)
              .toDouble();

          final columns = isMobile ? 2 : 4;

          final calculatedWidth =
              (contentWidth - spacing * (columns - 1)) / columns;

          final cardWidth = calculatedWidth
              .clamp(0.0, 220.0)
              .toDouble();

          return Stack(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: game.uiUpdates,
                builder: (context, value, child) {
                  final selected =
                  game.selectedCharacter.clamp(0, names.length - 1);

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      65,
                      horizontalPadding,
                      24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'CHOOSE YOUR HERO',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Pick a character for your gravity adventure!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65),
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 28),

                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: spacing,
                              runSpacing: spacing,
                              children: List.generate(names.length, (index) {
                                final isSelected = selected == index;

                                return SizedBox(
                                  width: cardWidth,
                                  child: GestureDetector(
                                    onTap: () {
                                      GameAudio.click();
                                      game.chooseCharacter(index);
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF172C55)
                                            : const Color(0xFF101A32),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF36E5FF)
                                              : Colors.white.withOpacity(0.12),
                                          width: isSelected ? 2.2 : 1,
                                        ),
                                        boxShadow: isSelected
                                            ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF36E5FF,
                                            ).withOpacity(0.22),
                                            blurRadius: 18,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                            : [],
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 115,
                                            child: CustomPaint(
                                              size: const Size(
                                                double.infinity,
                                                115,
                                              ),
                                              painter:
                                              _CharacterPreviewPainter(
                                                index: index,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          Text(
                                            names[index],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 5),

                                          Text(
                                            descriptions[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.6),
                                              fontSize: 11,
                                            ),
                                          ),

                                          const SizedBox(height: 12),

                                          Icon(
                                            isSelected
                                                ? Icons.check_circle
                                                : Icons.circle_outlined,
                                            color: isSelected
                                                ? const Color(0xFF36E5FF)
                                                : Colors.white38,
                                            size: 22,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              width: 240,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  GameAudio.click();
                                  game.startSelectedLevel();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(0xFF36D9F5),
                                  foregroundColor:
                                  const Color(0xFF071326),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'LET\'S PLAY  →',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
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
}

class _CharacterPreviewPainter extends CustomPainter {
  final int index;

  const _CharacterPreviewPainter({
    required this.index,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(1.7);

    Pip.draw(
      canvas,
      Offset.zero,
      1.5,
      grounded: true,
      characterIndex: index,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(
      covariant _CharacterPreviewPainter oldDelegate,
      ) {
    return oldDelegate.index != index;
  }
}
