
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameAudio {
  GameAudio._();

  static bool effectsEnabled = true;
  static bool musicEnabled = true;

  static bool _initialized = false;
  static bool _musicStarted = false;

  static final ValueNotifier<bool> musicNotifier =
  ValueNotifier<bool>(true);

  static final ValueNotifier<bool> effectsNotifier =
  ValueNotifier<bool>(true);

  static const String _music = 'background_loop.wav';

  static const String _musicPreferenceKey =
      'gravity_flip_music_enabled';

  static const String _effectsPreferenceKey =
      'gravity_flip_effects_enabled';

  static const Map<String, String> _sounds = {
    'click': 'click.mp3.wav',
    'flip': 'flip.mp3.wav',
    'pipOut': 'laser.mp3.wav',
    'collect': 'collect.mp3.wav',
    'bonus': 'bonus.mp3.wav',
    'levelComplete': 'level_complete.mp3.wav',
    'levelUp': 'level_up.mp3.wav',
    'gameOver': 'game_over.mp3.wav',
  };

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      musicEnabled =
          prefs.getBool(_musicPreferenceKey) ?? true;

      effectsEnabled =
          prefs.getBool(_effectsPreferenceKey) ?? true;

      musicNotifier.value = musicEnabled;
      effectsNotifier.value = effectsEnabled;
    } catch (_) {
      musicEnabled = true;
      effectsEnabled = true;
    }

    for (final file in [..._sounds.values, _music]) {
      try {
        await FlameAudio.audioCache.load(file);
      } catch (_) {
        // Continue if an individual audio file is unavailable.
      }
    }

    try {
      await FlameAudio.bgm.initialize();
    } catch (_) {
      // Game can still run without background music.
    }

    _initialized = true;

    if (musicEnabled) {
      startMusic();
    }
  }

  static void startMusic() {
    if (!_initialized || !musicEnabled || _musicStarted) {
      return;
    }

    try {
      FlameAudio.bgm.play(_music, volume: 0.24);
      _musicStarted = true;
    } catch (_) {
      _musicStarted = false;
    }
  }

  static void stopMusic() {
    try {
      FlameAudio.bgm.stop();
    } catch (_) {}

    _musicStarted = false;
  }

  static Future<void> toggleMusic(bool value) async {
    musicEnabled = value;
    musicNotifier.value = value;

    if (value) {
      startMusic();
    } else {
      stopMusic();
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_musicPreferenceKey, value);
    } catch (_) {}
  }

  static Future<void> toggleEffects(bool value) async {
    effectsEnabled = value;
    effectsNotifier.value = value;

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_effectsPreferenceKey, value);
    } catch (_) {}
  }

  static void _play(
      String key, {
        double volume = 0.45,
      }) {
    if (!effectsEnabled) return;

    final file = _sounds[key];

    if (file == null) return;

    try {
      FlameAudio.play(file, volume: volume);
    } catch (_) {}
  }

  static void click() => _play('click', volume: 0.35);

  static void flip() => _play('flip');

  static void pipOut() => _play('pipOut', volume: 0.5);

  static void collect() => _play('collect');

  static void bonus() => _play('bonus', volume: 0.5);

  static void levelComplete() =>
      _play('levelComplete', volume: 0.55);

  static void levelUp() => _play('levelUp');

  static void gameOver() => _play('gameOver', volume: 0.5);
}
