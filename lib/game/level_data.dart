
import 'dart:ui';

class LevelData {
  final List<Rect> platforms;
  final List<Offset> stars;
  final List<Rect> hazards;
  final Offset spawn;
  final Offset portal;

  const LevelData({
    required this.platforms,
    required this.stars,
    required this.hazards,
    required this.spawn,
    required this.portal,
  });

  static LevelData forLevel(int level) {
    final n = level.clamp(1, 20).toInt();
    final difficulty = n - 1;

    // Platforms become narrower and gaps increase gradually.
    final platformWidth =
    (145.0 - difficulty * 2.7).clamp(92.0, 145.0);

    final gap =
    (112.0 + difficulty * 1.65).clamp(112.0, 143.0);

    final baseY = 455.0 - (difficulty % 4) * 9.0;

    final platforms = <Rect>[];

    // Main platforms with progressively challenging heights.
    for (var i = 0; i < 6; i++) {
      final x = 18.0 + i * gap;

      final wave =
          ((i + n) % 3) * (43.0 + difficulty * 1.7);

      final extraVariation =
      (i.isEven ? 0.0 : difficulty * 1.1);

      final y = (baseY - wave - extraVariation)
          .clamp(165.0, 465.0)
          .toDouble();

      platforms.add(
        Rect.fromLTWH(
          x,
          y,
          platformWidth.toDouble(),
          17,
        ),
      );
    }

    // Portal landing platform.
    final portalPlatformY =
        445.0 - (n % 3) * 22.0;

    platforms.add(
      Rect.fromLTWH(
        830,
        portalPlatformY,
        112,
        17,
      ),
    );

    // Every level adds one star.
    // Level 1 = 3, Level 10 = 12, Level 20 = 22.
    final starCount = n + 2;
    final stars = <Offset>[];

    // Spread stars across the level instead of clustering them.
    final totalPlatforms = platforms.length;

    for (var i = 0; i < starCount; i++) {
      final platformIndex = i % totalPlatforms;
      final group = i ~/ totalPlatforms;

      final platform = platforms[platformIndex];

      final availableWidth = platform.width - 28;

      // Different positions on each repeated platform.
      final positionFactor =
      ((group * 0.37 + platformIndex * 0.23) % 1.0);

      final starX = platform.left +
          14 +
          availableWidth * positionFactor;

      // Increase vertical challenge on later groups.
      final heightOffset =
          43.0 + (group * 9.0) + (difficulty * 0.35);

      final starY = platform.top - heightOffset;

      stars.add(
        Offset(starX, starY),
      );
    }

    // Hazards increase progressively.
    final hazardCount =
    ((n - 1) ~/ 3).clamp(0, 6).toInt();

    final hazards = <Rect>[];

    for (var i = 0; i < hazardCount; i++) {
      final x = 145.0 + i * 112.0;

      final y = 420.0 -
          ((i + n) % 3) * (42.0 + difficulty * 0.65);

      final width =
      (55.0 + difficulty * 0.65).clamp(55.0, 68.0);

      hazards.add(
        Rect.fromLTWH(
          x,
          y,
          width.toDouble(),
          8,
        ),
      );
    }

    return LevelData(
      spawn: Offset(
        65,
        platforms.first.top - 38,
      ),
      platforms: platforms,
      stars: stars,
      hazards: hazards,
      portal: Offset(
        890,
        platforms.last.top - 28,
      ),
    );
  }
}
