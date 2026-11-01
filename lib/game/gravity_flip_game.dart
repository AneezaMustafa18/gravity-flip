
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show KeyEventResult;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/collectible_star.dart';
import '../components/neon_background.dart';
import '../components/neon_platform.dart';
import '../components/pip.dart';
import '../components/portal.dart';
import '../ui/game_hud.dart';
import 'game_audio.dart';
import 'level_data.dart';

class GravityFlipGame extends FlameGame with KeyboardEvents {
  static const double worldWidth = 960;
  static const double worldHeight = 540;

  final ValueNotifier<int> uiUpdates = ValueNotifier(0);

  int level = 1;
  int lives = 3;
  int score = 0;
  int starsCollected = 0;
  int unlockedLevel = 1;
  int selectedCharacter = 0;

  final List<String> characters = [
    'Pip',
    'Nova',
    'Bibi',
    'Bolt',
  ];

  double playerX = 90;
  double playerY = 420;
  double velocityY = 0;
  double elapsed = 0;

  final double playerWidth = 34;
  final double playerHeight = 40;

  // Difficulty increases progressively.
  double get gravityStrength =>
      850 + (level - 1) * 13.0;

  double get maxFallSpeed =>
      (560 + (level - 1) * 9.0).clamp(560.0, 730.0);

  double get moveSpeed =>
      (250 + (level - 1) * 4.0).clamp(250.0, 326.0);

  int gravityDirection = 1;

  bool hasStarted = false;
  bool grounded = false;
  bool isComplete = false;
  bool gameOver = false;

  bool leftPressed = false;
  bool rightPressed = false;

  bool _bonusPlayed = false;
  bool _processingLifeLoss = false;
  bool _progressSaving = false;

  List<Rect> platforms = [];
  List<Rect> hazards = [];
  List<Offset> stars = [];

  final Set<int> collectedStarIds = {};

  Offset portalCenter = const Offset(900, 430);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await _loadProgress();
    await GameAudio.initialize();

    _buildLevel();

    overlays.add('startScreen');
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      unlockedLevel =
          prefs.getInt('gravity_flip_unlocked_level') ?? 1;

      unlockedLevel = unlockedLevel.clamp(1, 20).toInt();
    } catch (_) {
      unlockedLevel = 1;
    }
  }

  Future<void> _saveProgress() async {
    if (_progressSaving) return;

    _progressSaving = true;

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt(
        'gravity_flip_unlocked_level',
        unlockedLevel,
      );
    } catch (_) {
      // Game remains playable if progress saving fails.
    } finally {
      _progressSaving = false;
    }
  }

  // Music and effects controls.
  bool get musicEnabled => GameAudio.musicEnabled;
  bool get effectsEnabled => GameAudio.effectsEnabled;

  Future<void> setMusicEnabled(bool value) async {
    await GameAudio.toggleMusic(value);
    uiUpdates.value++;
  }

  Future<void> setEffectsEnabled(bool value) async {
    await GameAudio.toggleEffects(value);
    uiUpdates.value++;
  }

  void showLoadingScreen() {
    hasStarted = false;

    overlays.remove('startScreen');
    overlays.remove('levelSelect');
    overlays.remove('characterSelect');

    overlays.add('loadingScreen');

    uiUpdates.value++;

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (isMounted && overlays.isActive('loadingScreen')) {
        overlays.remove('loadingScreen');
        overlays.add('levelSelect');
        uiUpdates.value++;
      }
    });
  }

  void showLevelSelection() {
    hasStarted = false;

    overlays.remove('startScreen');
    overlays.remove('gameOver');
    overlays.remove('levelComplete');
    overlays.remove('touchControls');
    overlays.remove('characterSelect');

    overlays.add('levelSelect');

    uiUpdates.value++;
  }

  void selectLevel(int selectedLevel) {
    if (selectedLevel < 1 ||
        selectedLevel > 20 ||
        selectedLevel > unlockedLevel) {
      return;
    }

    level = selectedLevel;

    lives = 3;
    score = 0;
    starsCollected = 0;

    gameOver = false;
    isComplete = false;
    hasStarted = false;

    overlays.remove('levelSelect');
    overlays.add('characterSelect');

    uiUpdates.value++;
  }

  void chooseCharacter(int index) {
    selectedCharacter = index.clamp(0, 3).toInt();
    uiUpdates.value++;
  }

  void startSelectedLevel() {
    _startGameplay();
  }

  void _startGameplay() {
    lives = 3;
    score = 0;
    starsCollected = 0;

    gameOver = false;
    isComplete = false;
    hasStarted = true;

    overlays.remove('characterSelect');
    overlays.remove('levelSelect');
    overlays.remove('loadingScreen');
    overlays.remove('levelComplete');
    overlays.remove('gameOver');

    _buildLevel();

    overlays.add('touchControls');

    GameAudio.levelUp();

    uiUpdates.value++;
  }

  void restart() {
    _startGameplay();
  }

  void _buildLevel() {
    final data = LevelData.forLevel(level);

    platforms = List<Rect>.from(data.platforms);
    hazards = List<Rect>.from(data.hazards);
    stars = List<Offset>.from(data.stars);

    playerX = data.spawn.dx;
    playerY = data.spawn.dy;

    velocityY = 0;
    gravityDirection = 1;

    grounded = false;

    collectedStarIds.clear();

    elapsed = 0;
    _bonusPlayed = false;
    _processingLifeLoss = false;

    leftPressed = false;
    rightPressed = false;

    portalCenter = data.portal;

    uiUpdates.value++;
  }

  void flipGravity() {
    if (!hasStarted || gameOver || isComplete) return;

    gravityDirection *= -1;

    velocityY = 0;
    grounded = false;

    GameAudio.flip();

    uiUpdates.value++;
  }

  void _loseLife() {
    if (_processingLifeLoss ||
        !hasStarted ||
        gameOver ||
        isComplete) {
      return;
    }

    _processingLifeLoss = true;

    lives--;

    GameAudio.pipOut();

    leftPressed = false;
    rightPressed = false;

    if (lives <= 0) {
      lives = 0;

      gameOver = true;
      hasStarted = false;

      GameAudio.gameOver();

      overlays.remove('touchControls');
      overlays.add('gameOver');

      uiUpdates.value++;

      _processingLifeLoss = false;
      return;
    }

    final data = LevelData.forLevel(level);

    playerX = data.spawn.dx;
    playerY = data.spawn.dy;

    velocityY = 0;
    gravityDirection = 1;
    grounded = false;

    _processingLifeLoss = false;

    uiUpdates.value++;
  }

  void _collectStars() {
    for (int i = 0; i < stars.length; i++) {
      if (collectedStarIds.contains(i)) continue;

      final star = stars[i];

      final dx = playerX - star.dx;
      final dy = playerY - star.dy;

      final distanceSquared = dx * dx + dy * dy;

      if (distanceSquared < 34 * 34) {
        collectedStarIds.add(i);

        starsCollected++;
        score += 100;

        GameAudio.collect();

        if (collectedStarIds.length == stars.length &&
            !_bonusPlayed) {
          _bonusPlayed = true;

          score += 200;

          GameAudio.bonus();
        }

        uiUpdates.value++;
      }
    }
  }

  void _checkHazards() {
    final playerRect = Rect.fromCenter(
      center: Offset(playerX, playerY),
      width: playerWidth,
      height: playerHeight,
    );

    for (final hazard in hazards) {
      if (playerRect.overlaps(hazard)) {
        _loseLife();
        return;
      }
    }
  }

  Future<void> _completeLevel() async {
    if (isComplete || gameOver || !hasStarted) return;

    isComplete = true;
    hasStarted = false;

    leftPressed = false;
    rightPressed = false;

    if (level < 20 && unlockedLevel < level + 1) {
      unlockedLevel = level + 1;
      await _saveProgress();
    }

    GameAudio.levelComplete();

    overlays.remove('touchControls');
    overlays.add('levelComplete');

    uiUpdates.value++;
  }

  void goToNextLevel() {
    if (!isComplete || level >= 20) return;

    showLevelSelection();
  }

  void returnToStartScreen() {
    hasStarted = false;

    overlays.remove('levelSelect');
    overlays.remove('characterSelect');
    overlays.remove('loadingScreen');
    overlays.remove('levelComplete');
    overlays.remove('gameOver');
    overlays.remove('touchControls');

    overlays.add('startScreen');

    uiUpdates.value++;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!hasStarted || gameOver || isComplete) return;

    dt = dt.clamp(0.0, 0.033).toDouble();

    elapsed += dt;

    final previousY = playerY;

    if (leftPressed) {
      playerX -= moveSpeed * dt;
    }

    if (rightPressed) {
      playerX += moveSpeed * dt;
    }

    playerX = playerX
        .clamp(
      playerWidth / 2,
      worldWidth - playerWidth / 2,
    )
        .toDouble();

    velocityY += gravityStrength * gravityDirection * dt;

    velocityY = velocityY
        .clamp(-maxFallSpeed, maxFallSpeed)
        .toDouble();

    playerY += velocityY * dt;

    grounded = false;

    final playerRect = Rect.fromCenter(
      center: Offset(playerX, playerY),
      width: playerWidth,
      height: playerHeight,
    );

    for (final platform in platforms) {
      if (!playerRect.overlaps(platform)) continue;

      if (gravityDirection == 1 &&
          previousY + playerHeight / 2 <= platform.top + 12) {
        playerY = platform.top - playerHeight / 2;
        velocityY = 0;
        grounded = true;
      } else if (gravityDirection == -1 &&
          previousY - playerHeight / 2 >= platform.bottom - 12) {
        playerY = platform.bottom + playerHeight / 2;
        velocityY = 0;
        grounded = true;
      }
    }

    if (playerY > worldHeight + 50 || playerY < -50) {
      _loseLife();
      return;
    }

    _checkHazards();

    if (gameOver || !hasStarted) return;

    _collectStars();

    final portalDistance =
        (Offset(playerX, playerY) - portalCenter).distance;

    if (portalDistance < 38) {
      _completeLevel();
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.space) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        flipGravity();
      }
    }

    leftPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);

    rightPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    return KeyEventResult.handled;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final scale = (size.x / worldWidth)
        .clamp(0.0, size.y / worldHeight);

    final offsetX = (size.x - worldWidth * scale) / 2;
    final offsetY = (size.y - worldHeight * scale) / 2;

    canvas.save();

    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);

    NeonBackground.render(canvas, elapsed);

    for (final platform in platforms) {
      NeonPlatform.render(canvas, platform, elapsed);
    }

    for (final hazard in hazards) {
      NeonPlatform.renderHazard(canvas, hazard, elapsed);
    }

    for (int i = 0; i < stars.length; i++) {
      if (collectedStarIds.contains(i)) continue;

      CollectibleStar.render(
        canvas,
        stars[i],
        elapsed,
      );
    }

    Portal.render(
      canvas,
      portalCenter,
      elapsed,
    );

    Pip.draw(
      canvas,
      Offset(playerX, playerY),
      elapsed,
      grounded: grounded,
      facing: leftPressed ? -1.0 : 1.0,
      characterIndex: selectedCharacter,
    );

    GameHud.render(
      canvas,
      level: level,
      score: score,
      lives: lives,
      starsCollected: starsCollected,
      totalStars: stars.length,
    );

    canvas.restore();
  }
}
