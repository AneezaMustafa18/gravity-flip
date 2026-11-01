
import 'package:flutter/material.dart';

import '../game/game_audio.dart';
import '../game/gravity_flip_game.dart';
import 'music_toggle.dart';

class LevelSelectOverlay extends StatelessWidget {
  final GravityFlipGame game;

  const LevelSelectOverlay({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xF0181438),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;

            final crossAxisCount = screenWidth >= 560
                ? 5
                : screenWidth >= 400
                ? 4
                : 3;

            final compact = screenWidth < 400;

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    12,
                    compact ? 58 : 62,
                    12,
                    12,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 650,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(compact ? 14 : 22),
                        decoration: BoxDecoration(
                          color: const Color(0xFF29245D),
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(
                            color: const Color(0xFFFF91C8),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '🌟 CHOOSE YOUR LEVEL',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFFFE477),
                                fontSize: compact ? 20 : 25,
                                fontWeight: FontWeight.w900,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'UNLOCKED ${game.unlockedLevel} / 20\n'
                                  'Complete a level to unlock the next',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 16),

                            GridView.builder(
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount: 20,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1.25,
                              ),
                              itemBuilder: (context, index) {
                                final number = index + 1;
                                final unlocked =
                                    number <= game.unlockedLevel;

                                return InkWell(
                                  onTap: unlocked
                                      ? () {
                                    GameAudio.click();
                                    game.selectLevel(number);
                                  }
                                      : null,
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: unlocked
                                          ? const Color(0xFFFF83C7)
                                          : const Color(0xFF49445F),
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      border: Border.all(
                                        color: unlocked
                                            ? Colors.white
                                            : Colors.white24,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          unlocked
                                              ? Icons.star_rounded
                                              : Icons.lock_rounded,
                                          color: unlocked
                                              ? const Color(0xFFFFF1A6)
                                              : Colors.white54,
                                          size: compact ? 19 : 22,
                                        ),

                                        const SizedBox(height: 2),

                                        Text(
                                          'LEVEL $number',
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: unlocked
                                                ? const Color(0xFF241747)
                                                : Colors.white54,
                                            fontWeight: FontWeight.w900,
                                            fontSize:
                                            compact ? 10 : 12,
                                            height: 1.0,
                                          ),
                                        ),

                                        const SizedBox(height: 2),

                                        Text(
                                          unlocked ? 'PLAY' : 'LOCKED',
                                          style: TextStyle(
                                            color: unlocked
                                                ? const Color(0xFF49305E)
                                                : Colors.white38,
                                            fontSize:
                                            compact ? 8 : 9,
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 12),

                            TextButton.icon(
                              onPressed: game.returnToStartScreen,
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('BACK TO HOME'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // MUSIC ON / OFF TOGGLE
                Positioned(
                  top: 8,
                  right: 8,
                  child: const MusicToggle(compact: true),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
