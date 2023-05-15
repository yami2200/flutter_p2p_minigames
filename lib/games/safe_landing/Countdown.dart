import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/safe_landing/game.dart';



class Countdown extends PositionComponent with HasGameRef<SafeLandingsGame> {
  static const COUNTDOWN_DURATION = 5;
  double _countdown = 5.0;

  bool isPaused = false;
  get isFinished => _countdown <= 0.1;

  final Function onCountdownFinish;

  Countdown({required this.onCountdownFinish});

  @override
  Future<void> onLoad() async {
    }

    double getValue(){
      return _countdown;
    }


  @override
  void update(double dt) {
    super.update(dt);

    if (isPaused) {
      return;
    }
    // Update the countdown
    _countdown -= dt;
    if (_countdown < 0) {
      _countdown = 0;
      onCountdownFinish();
    }
  }

  void pause() {
    isPaused = true;
  }

  @override
  void render(Canvas canvas) {
    // Render the black rectangle background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(10),
      ),
      Paint()..color = Colors.black,
    );

    // Render the text on top of the black rectangle background
    final textSpan = TextSpan(text: _countdown.toStringAsFixed(2), style: const TextStyle(
      color: Colors.black,
      fontSize: 30,
    ));
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