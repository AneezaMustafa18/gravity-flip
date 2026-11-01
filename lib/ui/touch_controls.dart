
import 'package:flutter/material.dart';

import '../game/gravity_flip_game.dart';

class TouchControls extends StatelessWidget {
  final GravityFlipGame game;

  const TouchControls({
    super.key,
    required this.game,
  });

  // DIRECTION BUTTON
  Widget _control(
      String symbol,
      VoidCallback onDown,
      VoidCallback onUp,
      double size,
      ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onDown(),
      onTapUp: (_) => onUp(),
      onTapCancel: onUp,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xCC30245F),
          borderRadius: BorderRadius.circular(size * 0.30),
          border: Border.all(
            color: const Color(0xFF8DEEFF),
            width: 1.7,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x553BCEFF),
              blurRadius: 9,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          symbol,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.42,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final shortestSide = width < height ? width : height;

          final isMobile = shortestSide < 600;

          final buttonSize = isMobile
              ? (shortestSide * 0.105)
              .clamp(38.0, 50.0)
              .toDouble()
              : 56.0;

          final flipSize = isMobile
              ? (shortestSide * 0.125)
              .clamp(46.0, 58.0)
              .toDouble()
              : 64.0;

          final horizontalPadding = isMobile ? 12.0 : 20.0;
          final bottomPadding = isMobile ? 12.0 : 18.0;

          return Stack(
            children: [
              // LEFT + RIGHT BUTTONS
              Positioned(
                left: horizontalPadding,
                bottom: bottomPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _control(
                      '◀',
                          () => game.leftPressed = true,
                          () => game.leftPressed = false,
                      buttonSize,
                    ),

                    SizedBox(
                      width: isMobile ? 8 : 12,
                    ),

                    _control(
                      '▶',
                          () => game.rightPressed = true,
                          () => game.rightPressed = false,
                      buttonSize,
                    ),
                  ],
                ),
              ),

              // GRAVITY FLIP BUTTON
              Positioned(
                right: horizontalPadding,
                bottom: bottomPadding,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: game.flipGravity,
                  child: Container(
                    width: flipSize,
                    height: flipSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF83C7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66FF83C7),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.swap_vert_rounded,
                      color: const Color(0xFF241747),
                      size: flipSize * 0.58,
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
}
