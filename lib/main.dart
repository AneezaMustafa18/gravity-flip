
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/gravity_flip_game.dart';
import 'ui/game_overlay.dart';
import 'ui/start_screen.dart';
import 'ui/touch_controls.dart';
import 'ui/level_complete_overlay.dart';
import 'ui/select_level_overlay.dart';
import 'ui/loading_screen.dart';
import 'ui/character_select_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GravityFlipApp());
}

class GravityFlipApp extends StatefulWidget {
  const GravityFlipApp({super.key});

  @override
  State<GravityFlipApp> createState() => _GravityFlipAppState();
}

class _GravityFlipAppState extends State<GravityFlipApp> {
  late final GravityFlipGame game;

  @override
  void initState() {
    super.initState();
    game = GravityFlipGame();
  }

  @override
  void dispose() {
    game.uiUpdates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gravity Flip',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF11152F),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFF11152F),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: GameWidget<GravityFlipGame>(
                  game: game,
                  overlayBuilderMap: {
                    'startScreen': (context, game) {
                      return StartScreen(game: game);
                    },
                    'loadingScreen': (context, game) {
                      return const LoadingScreen();
                    },
                    'levelSelect': (context, game) {
                      return LevelSelectOverlay(game: game);
                    },
                    'characterSelect': (context, game) {
                      return CharacterSelectScreen(game: game);
                    },
                    'levelComplete': (context, game) {
                      return LevelCompleteOverlay(game: game);
                    },
                    'gameOver': (context, game) {
                      return GameOverOverlay(game: game);
                    },
                    'touchControls': (context, game) {
                      return TouchControls(game: game);
                    },
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
