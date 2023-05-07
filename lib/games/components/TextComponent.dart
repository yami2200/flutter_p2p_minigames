import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TextComponent extends PositionComponent{
  String text;
  final TextStyle style;
  final Vector2 startPosition;

  TextComponent({
    required this.text,
    required this.style,
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
    size = Vector2(textPainter.width, textPainter.height);
    position = startPosition;
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

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

  void setText(String text){
    this.text = text;
  }
}