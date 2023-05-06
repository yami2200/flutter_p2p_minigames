import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_minigames/games/components/ButtonComponent.dart';
import 'package:flutter_p2p_minigames/games/face_guess/FaceWheelComp.dart';

import '../../network/EventData.dart';
import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';

class FaceGuessGameInstance extends FlameGameInstance{
  final bool training;
  FaceWheelComp? currentWheel;
  FaceWheelComp? opponentWheel;
  List<WheelStep> steps = [];
  int stepIndex = 0;
  int opponentStepIndex = 0;
  int s = 0;
  bool end = false;

  FaceGuessGameInstance(this.training) {
    s = training ? 330 : 180;
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("faceguess/background_faceguess.jpg"));

    steps.add(await WheelStep.create(0.5, "faceguess/face/Face", 6));
    steps.add(await WheelStep.create(0.4, "faceguess/eyes/Eyes", 4));
    steps.add(await WheelStep.create(0.3, "faceguess/mouth/Mouth", 5));
    steps.add(await WheelStep.create(0.2, "faceguess/nose/Nose", 5));

    loadStep(true);
    loadStep(false);

    currentWheel!.start();
    add(ButtonComponent(
        text: "Select",
        style: const TextStyle(fontFamily: "SuperBubble", fontSize: 25, color: Color.fromRGBO(255, 255, 255, 1.0)),
        color: const Color.fromRGBO(128, 57, 14, 1.0),
        onTap: hitSelect,
        startPosition: training ? Vector2(size.x / 2 - 65, 545) : Vector2(size.x / 4 - 65, 375),
    ));
    if(!training){
      add(ButtonComponent(
        text: "Opponent",
        style: const TextStyle(fontFamily: "SuperBubble", fontSize: 25, color: Color.fromRGBO(255, 255, 255, 1.0)),
        color: const Color.fromRGBO(0, 0, 0, 1.0),
        onTap: (){},
        startPosition: Vector2(size.x / 4 * 3 - 75, 375),
      ));
    }
  }

  @override
  void onMessageFromServer(EventData message){
    log("messageeeeeeeeeeeeeee from server");
  }

  @override
  void onMessageFromClient(EventData message){
    log("messageeeeeeeeeeeeeee from client");
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void loadStep(bool mainPlayer) async{
    if(!mainPlayer && training) return;

    if(mainPlayer){
      currentWheel = FaceWheelComp(
          steps[stepIndex],
          training ? Vector2(size.x / 2 - s / 2, 200) : Vector2(size.x / 4 - s / 2, 180),
          Vector2(s as double, s as double));
          await add(currentWheel!);
      currentWheel!.start();
    } else {
      opponentWheel = FaceWheelComp(
          steps[opponentStepIndex],
          Vector2(size.x / 4 * 3 - s / 2, 180),
          Vector2(s as double, s as double));
          await add(opponentWheel!);
      opponentWheel!.start();
    }
  }

  void hitSelect(){
    if(end) return;
    if(currentWheel != null && currentWheel!.running) currentWheel!.stop();
    if(stepIndex >= steps.length - 1){
      end = true;
      parentWidget!.setMainPlayerText("Finished!");
      return;
    }
    stepIndex++;
    parentWidget!.setMainPlayerText("Step ${stepIndex + 1}");
    loadStep(true);
  }

  @override
  void onStartGame() {
    parentWidget!.setMainPlayerText("Step ${stepIndex + 1}");
  }

}