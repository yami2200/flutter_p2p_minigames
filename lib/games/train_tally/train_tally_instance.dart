import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_p2p_minigames/games/train_tally/passenger.dart';
import 'package:flutter_p2p_minigames/games/train_tally/wagon.dart';
import 'package:flutter_p2p_minigames/network/EventData.dart';
import 'package:flutter_p2p_minigames/network/EventType.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';
import 'package:flutter_p2p_minigames/games/components/TextComponent.dart' as tc;

import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';

class TrainTallyGameInstance extends FlameGameInstance with TapDetector{
  bool trainMoving = false;
  Sprite? trainSprite;
  List<Wagon> wagons = [];
  double initSpeed = 600;
  double speedGain = 60;
  int count = 0;
  int totalPassengers = 0;
  bool finished = false;
  String trainschema = "";

  @override
  void onMessageFromClient(EventData message) {}

  @override
  void onMessageFromServer(EventData message) {
    if(message.type == EventType.TRAIN_SCHEMA.text){
      createTrainFromServer(message);
    }
  }

  void createTrainFromServer(EventData message) async{
    String schema = message.data;
    int nbWagon = schema.length ~/ 5;

    trainSprite = await loadSprite("train/train.png");

    String currentSchema = "";
    int wagonCount = 0;
    for(int i = 0; i < schema.length; i++){
      currentSchema += schema[i];
      if(currentSchema.length == 5){
        Wagon newWagon;
        if(wagonCount==nbWagon-1){
          newWagon = Wagon(Vector2(size.x*2 + wagonCount*721, size.y), trainSprite!, onQuitScreen: onLastWagonQuit);
        } else {
          newWagon = Wagon(Vector2(size.x*2 + wagonCount*721, size.y), trainSprite!);
        }
        newWagon.addPassengers(currentSchema);
        newWagon.getPassengers().forEach((element) {
          add(element);
        });
        totalPassengers += newWagon.getNbPassengers();
        wagons.add(newWagon);
        add(newWagon);
        wagonCount++;
        currentSchema = "";
      }
    }
  }


  @override
  void onTap() {
    if(!finished)count++;
  }

  @override
  void onStartGame() {
    getParentWidget()!.setMainPlayerText("Counting");
    getParentWidget()!.playMusic("audios/traintally.mp3");
    startMoving();
  }

  void startMoving() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    trainMoving = true;
    dev.log("Train moving : $trainMoving");
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("train/background_train.jpg"));
    Passenger.passenger1 = await loadSprite("train/char1.png");
    Passenger.passenger2 = await loadSprite("train/char2.png");
    Passenger.nopassenger = await loadSprite("train/nochar.jpg");

    if(GameParty().isServer()){
      trainSprite = await loadSprite("train/train.png");
      int nbWagon = 7 + (Random().nextInt(5));
      for(int i = 0; i < nbWagon; i++){
        Wagon newWagon;
        if(i==nbWagon-1){
          newWagon = Wagon(Vector2(size.x*2 + i*721, size.y), trainSprite!, onQuitScreen: onLastWagonQuit);
        } else {
          newWagon = Wagon(Vector2(size.x*2 + i*721, size.y), trainSprite!);
        }
        newWagon.generatePassengers();
        trainschema += newWagon.getSchema();
        newWagon.getPassengers().forEach((element) {
          add(element);
        });
        totalPassengers += newWagon.getNbPassengers();
        wagons.add(newWagon);
        add(newWagon);
      }
      if(!getParentWidget()!.widget.training){
        GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.TRAIN_SCHEMA.text, trainschema)));
      }
    }
    add(tc.TextComponent(text: "Tap on screen\neach time you see a passenger", startPosition: Vector2(size.x / 2, 200), style: const TextStyle(fontFamily: "SuperBubble", fontSize: 20, color: Color.fromRGBO(0, 0, 0, 1.0))));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(trainMoving){
      wagons.forEach((element) {
        element.move(initSpeed * dt);
      });
      initSpeed += speedGain * dt;
    }
  }

  void onLastWagonQuit(){
    overlays.add("end");
    finished=true;
  }


  void clickQuit(){
    overlays.remove("end");
    if(getParentWidget()!.widget.training) {getParentWidget()!.quitTraining();}
    else {
      getParentWidget()!.setCurrentPlayerScore(max(0, 20 - (totalPassengers-count).abs()));
    }
  }


}