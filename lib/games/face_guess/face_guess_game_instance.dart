import 'dart:convert';
import 'dart:math';
import "dart:developer" as dev;

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_p2p_minigames/games/components/ButtonComponent.dart';
import 'package:flutter_p2p_minigames/games/components/TextComponent.dart';
import 'package:flutter_p2p_minigames/games/face_guess/FaceWheelComp.dart';
import 'package:flutter_p2p_minigames/network/EventType.dart';

import '../../network/EventData.dart';
import '../../utils/GameParty.dart';
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
  double waitTime = 8.0;
  TextComponent? countdownText;
  TextComponent? rememberText;
  List<FaceWheelComp> wheelsAnswer = [];
  ButtonComponent? selectBtn;
  ButtonComponent? opponentBtn;
  List<int> indexesAnswer = [];
  List<int> indexesGuess = [];

  FaceGuessGameInstance(this.training) {
    s = training ? 330 : 180;
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("faceguess/background_faceguess.jpg"));

    steps.add(await WheelStep.create(0.6, "faceguess/face/Face", 6));
    steps.add(await WheelStep.create(0.5, "faceguess/eyes/Eyes", 4));
    steps.add(await WheelStep.create(0.4, "faceguess/mouth/Mouth", 5));
    steps.add(await WheelStep.create(0.3, "faceguess/nose/Nose", 5));

    dev.log("steps loaded");

    if(GameParty().isServer()) {

      String indexesToSend = "";
      for(int i = 0; i < steps.length; i++){
        indexesAnswer.add(Random().nextInt(steps[i].maxIndex));
        indexesToSend += "${indexesAnswer[i]},";
      }

      if(!training) GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.FACE_ANSWER.text, indexesToSend)));
      generateFaceToGuess(indexesAnswer);
    }
  }

  void generateFaceToGuess(List<int> indexes) async{
    if(steps.length < 4) {
      await Future.delayed(Duration(milliseconds: 200), () => generateFaceToGuess(indexes));
      return;
    }
    for(int i = 0; i < steps.length; i++){
      dev.log("generating face $i");
      FaceWheelComp comp = FaceWheelComp(steps[i], Vector2(size.x / 2 - 330 / 2, 200), Vector2(330, 330));
      wheelsAnswer.add(comp);
      await add(comp);
      comp.select(indexes[i]);
    }
    rememberText = TextComponent(text: "Remember!",startPosition: Vector2(size.x / 2, 550), style: const TextStyle(fontFamily: "SuperBubble", fontSize: 30, color: Color.fromRGBO(0, 0, 0, 1.0)));
    await add(rememberText!);
    countdownText = TextComponent(text: "5",startPosition: Vector2(size.x / 2, 600), style: const TextStyle(fontFamily: "SuperBubble", fontSize: 30, color: Color.fromRGBO(0, 0, 0, 1.0)));
    await add(countdownText!);
    waitTime = 8.0;
  }

  void startGuessing(){
    loadStep(true);
    loadStep(false);

    currentWheel!.start();
    selectBtn = ButtonComponent(
      text: "Select",
      style: const TextStyle(fontFamily: "SuperBubble", fontSize: 25, color: Color.fromRGBO(255, 255, 255, 1.0)),
      color: const Color.fromRGBO(128, 57, 14, 1.0),
      onTap: hitSelect,
      startPosition: training ? Vector2(size.x / 2 - 65, 545) : Vector2(size.x / 4 - 65, 375),
    );
    add(selectBtn!);
    if(!training){
      opponentBtn = ButtonComponent(
        text: "Opponent",
        style: const TextStyle(fontFamily: "SuperBubble", fontSize: 25, color: Color.fromRGBO(255, 255, 255, 1.0)),
        color: const Color.fromRGBO(0, 0, 0, 1.0),
        onTap: (){},
        startPosition: Vector2(size.x / 4 * 3 - 75, 375),
      );
      add(opponentBtn!);
    }
  }

  @override
  void onMessageFromServer(EventData message){
    checkFaceGuessOponent(message);
    if(message.type == EventType.FACE_ANSWER.text){
      List<String> indexesString = message.data.split(",");
      for(int i = 0; i < indexesString.length; i++){
        if(indexesString[i].isEmpty) continue;
        indexesAnswer.add(int.parse(indexesString[i].replaceAll(",","")));
      }
      dev.log("generate face received");
      generateFaceToGuess(indexesAnswer);
    }
  }

  @override
  void onMessageFromClient(EventData message){
    checkFaceGuessOponent(message);
  }

  void checkFaceGuessOponent(EventData message){
      if(message.type == EventType.FACE_PART_GUESS.text){
      opponentWheel!.select(int.parse(message.data));
      opponentStepIndex++;
      if(opponentStepIndex < 4) loadStep(false);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(countdownText != null && waitTime>0){
      waitTime -= dt;
      countdownText!.setText(waitTime.toStringAsFixed(2));
      if(waitTime<=0){
        remove(countdownText!);
        remove(rememberText!);
        wheelsAnswer.forEach((element) {
          remove(element);
        });
        countdownText = null;
        startGuessing();
      }
    }
  }

  void loadStep(bool mainPlayer) async{
    if(!mainPlayer && training) return;

    if(mainPlayer){
      currentWheel = FaceWheelComp(
          steps[stepIndex],
          training ? Vector2(size.x / 2 - s / 2, 200) : Vector2(size.x / 4 - s / 2, 180),
          Vector2(s.toDouble(), s.toDouble()));
          await add(currentWheel!);
      currentWheel!.start();
    } else {
      opponentWheel = FaceWheelComp(
          steps[opponentStepIndex],
          Vector2(size.x / 4 * 3 - s / 2, 180),
          Vector2(s.toDouble(), s.toDouble()));
          await add(opponentWheel!);
      opponentWheel!.start();
    }
  }

  void hitSelect(){
    if(end) return;
    int result = currentWheel!.stop();
    if(!training) {
      if (GameParty().isServer()) {
        GameParty().connection!.sendMessageToClient(jsonEncode(
            EventData(EventType.FACE_PART_GUESS.text, result.toString())));
      } else {
        GameParty().connection!.sendMessageToServer(jsonEncode(
            EventData(EventType.FACE_PART_GUESS.text, result.toString())));
      }
    }
    indexesGuess.add(result);
    stepIndex++;
    if(stepIndex >= steps.length){
      end = true;
      int score = finish();
      getParentWidget()!.setMainPlayerText("Finished!\nScore: $score");
      if(!training) getParentWidget()!.setCurrentPlayerScore(score);
    } else {
      getParentWidget()!.setMainPlayerText("Step ${stepIndex + 1}");
      loadStep(true);
    }
  }

  int finish(){
    if(selectBtn != null) remove(selectBtn!);
    if(opponentBtn != null) remove(opponentBtn!);
    if(training){
      add(ButtonComponent(
        text: "Quit",
        style: const TextStyle(fontFamily: "SuperBubble", fontSize: 25, color: Color.fromRGBO(255, 255, 255, 1.0)),
        color: const Color.fromRGBO(128, 57, 14, 1.0),
        onTap: hitQuit,
        startPosition: Vector2(size.x / 2 - 50, 545),
      ));
    }
    int score = getScore();
    add(TextComponent(text: "Your score : $score", style: const TextStyle(fontSize: 30, fontFamily: "SuperBubble", color: Color.fromRGBO(0, 0, 0, 1.0)), startPosition: Vector2(size.x / 2, 625)));
    return score;
  }

  int getScore(){
    int score = 0;
    for(int i = 0; i < indexesAnswer.length; i++){
      if(indexesGuess[i] == indexesAnswer[i]) score += 4;
    }
    if(training || !getParentWidget()!.scoreReceived) score += 4;
    return score;
  }

  void hitQuit(){
    getParentWidget()!.quitTraining();
  }

  @override
  void onStartGame() {
    getParentWidget()!.setMainPlayerText("Step ${stepIndex + 1}");
    getParentWidget()!.playMusic("audios/faceguess.mp3");
  }

}