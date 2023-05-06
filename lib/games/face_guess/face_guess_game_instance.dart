import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter_p2p_minigames/games/face_guess/FaceWheelComp.dart';

import '../components/BackgroundComponent.dart';

class FaceGuessGameInstance extends FlameGame{


  @override
  Future<void> onLoad() async {
    log("load back");
    await add(BackgroundComponent("background.jpg"));
    await add(FaceWheelComp(await WheelStep.create(0.4, "faceguess/face/Face", 6)));
    await add(FaceWheelComp(await WheelStep.create(0.3, "faceguess/eyes/Eyes", 4)));

  }

  @override
  void update(double dt) {
    super.update(dt);
  }

}