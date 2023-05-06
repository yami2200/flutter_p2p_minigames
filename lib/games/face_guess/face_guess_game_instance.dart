import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_minigames/games/components/ButtonComponent.dart';
import 'package:flutter_p2p_minigames/games/face_guess/FaceWheelComp.dart';

import '../components/BackgroundComponent.dart';

class FaceGuessGameInstance extends FlameGame{
  final bool training;
  FaceWheelComp? currentWheel;
  FaceWheelComp? opponentWheel;

  FaceGuessGameInstance(this.training);

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("faceguess/background_faceguess.jpg"));
    int s = training ? 330 : 180;
    currentWheel = FaceWheelComp(
        await WheelStep.create(0.4, "faceguess/face/Face", 6),
        training ? Vector2(size.x / 2 - s / 2, 200) : Vector2(size.x / 4 - s / 2, 180),
        Vector2(s as double, s as double));
    if(!training){
      opponentWheel = FaceWheelComp(
          await WheelStep.create(0.4, "faceguess/face/Face", 6),
          Vector2(size.x / 4 * 3 - s / 2, 180),
          Vector2(s as double, s as double));
      await add(opponentWheel!);
      opponentWheel!.start();
    }
    await add(currentWheel!);
    currentWheel!.start();
    add(ButtonComponent(
        text: "Select",
        style: const TextStyle(fontFamily: "SuperBubble", fontSize: 25, color: Color.fromRGBO(255, 255, 255, 1.0)),
        color: const Color.fromRGBO(128, 57, 14, 1.0),
        onTap: hitSelect,
        startPosition: training ? Vector2(size.x / 2 - 65, 545) : Vector2(size.x / 4 - 35, 220),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void hitSelect(){

  }

}