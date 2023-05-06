import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ButtonComponent extends PositionComponent with TapCallbacks, HasGameRef<FlameGame> {

  final String text;
  final TextStyle style;
  final Color color;
  final double padding;
  final VoidCallback onTap;
  final Vector2 startPosition;

  ButtonComponent({
    required this.text,
    required this.style,
    required this.color,
    this.padding = 8.0,
    required this.onTap,
    required this.startPosition,
  }) : super(size: Vector2.zero());

  @override
  Future<void> onLoad() async {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    size = Vector2(textPainter.width + padding * 2, textPainter.height + padding * 2);
    position = startPosition;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    onTap();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Render the black rectangle background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      Paint()..color = color,
    );

    // Render the text on top of the black rectangle background
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final x = (size.x - textPainter.width) / 2;
    final y = (size.y - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(x, y));
  }

}
