import 'dart:developer';

import 'package:flame/game.dart';

import '../components/BackgroundComponent.dart';

class FaceGuessGameInstance extends FlameGame{

  @override
  Future<void> onLoad() async {
    log("load back");
    await add(BackgroundComponent("background.jpg"));
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

}