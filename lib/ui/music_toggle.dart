
import 'package:flutter/material.dart';

import '../game/game_audio.dart';

class MusicToggle extends StatelessWidget {
  const MusicToggle({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GameAudio.musicNotifier,
      builder: (context, musicEnabled, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              GameAudio.toggleMusic(!musicEnabled);
            },
            borderRadius: BorderRadius.circular(30),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 11 : 15,
                vertical: compact ? 8 : 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xDD101B38),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: musicEnabled
                      ? const Color(0xFF63E6FF)
                      : const Color(0xFF52617E),
                  width: 1.2,
                ),
                boxShadow: musicEnabled
                    ? [
                  BoxShadow(
                    color: const Color(0xFF63E6FF)
                        .withOpacity(0.15),
                    blurRadius: 12,
                  ),
                ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    musicEnabled
                        ? Icons.music_note_rounded
                        : Icons.music_off_rounded,
                    color: musicEnabled
                        ? const Color(0xFF63E6FF)
                        : const Color(0xFF9AA8C2),
                    size: compact ? 18 : 21,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    musicEnabled ? 'MUSIC ON' : 'MUSIC OFF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 10 : 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: compact ? 29 : 34,
                    height: compact ? 16 : 19,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: musicEnabled
                          ? const Color(0xFF35C9E8)
                          : const Color(0xFF52617E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 220),
                      alignment: musicEnabled
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: compact ? 12 : 15,
                        height: compact ? 12 : 15,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
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
    );
  }
}
