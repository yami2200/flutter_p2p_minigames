import 'dart:convert';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_p2p_minigames/games/FlameGameInstance.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/platform.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/player.dart';
import 'package:flutter_p2p_minigames/games/components/TextComponent.dart';
import 'package:flutter_p2p_minigames/network/EventData.dart';
import 'package:flutter_p2p_minigames/network/EventType.dart';

import '../../utils/GameParty.dart';
import '../components/BackgroundComponent.dart';
import 'blood.dart';
import 'cloud.dart';

enum GameState { choosing, falling }

class ChooseGoodSideGameInstance extends FlameGameInstance with PanDetector{

  Platform? leftPlatform;
  Platform? rightPlatform;
  String myAvatar = GameParty().player?.avatar ?? 'avatar0.png';
  String? opponentAvatar = GameParty().opponent?.avatar;
  Player? player;
  Player? playerOpponent;
  TextComponent? countdownText;
  double waitTime = 11.0;
  GameState state = GameState.choosing;
  bool sub1 = false;
  double fallingSpeed = 0.0;
  double gravity = 500.0;
  List<Cloud> clouds = [];
  int life = 3;
  Blood? blood;

  @override
  void onMessageFromClient(EventData message) {
    onReceiveMessage(message);
  }

  @override
  void onMessageFromServer(EventData message) {
    onReceiveMessage(message);
    if(message.type == EventType.SIDE_PIKE.text){
      startFallingLogic(message.data == "left");
    }
  }

  void onReceiveMessage(EventData message){
    if(message.type == EventType.SWAP_SIDE.text){
      playerOpponent!.forceSwitch(message.data == "left");
    } else if(message.type == EventType.PIKE_DEAD.text){
      if(life>0){
        getParentWidget()!.setCurrentPlayerScore(20);
      }
    }
  }

  @override
  void onStartGame() {
    getParentWidget()!.setMainPlayerText("Life:\n$life");
    getParentWidget()!.playMusic("audios/goodside.mp3");
  }


  @override
  void onPanUpdate(DragUpdateInfo info) {
    if(sub1) return;
    if(info.delta.viewport.x > 0){
      player!.switchSide(false);
    } else {
      player!.switchSide(true);
    }
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("choosegoodside/background_2sides.png"));

    Sprite cloudSprite = await loadSprite("choosegoodside/cloud.png");
    for(int i = 0; i < 3; i++){
      for(int j = 0; j < 3; j++){
        clouds.add(Cloud(Vector2(((Random().nextBool() ? -1 : 1) * Random().nextDouble() * size.x/3) + size.x/3 + j * size.x/3, ((Random().nextBool() ? 1 : -1) * Random().nextDouble() * size.y/6) + size.y/3 + i * size.y/3), cloudSprite));
      }
    }
    clouds.forEach((element) async {
      await add(element);
    });

    leftPlatform = Platform(Vector2(size.x / 2 - 280, 500), Vector2(280, 175));
    rightPlatform = Platform(Vector2(size.x / 2 , 500), Vector2(280, 175));
    await add(leftPlatform!);
    await add(rightPlatform!);
    await add(player = Player(
      avatar: myAvatar,
      startPosition: GameParty().isServer() ? Vector2(size.x / 2 - 280 / 2 -40, 545) : Vector2(size.x / 2 - 280 / 2 + 40, 545),
      mainCharacter: true,
      training: getParentWidget()!.widget.training,
    ));
    if(!getParentWidget()!.widget.training){
      await add(playerOpponent = Player(
        avatar: opponentAvatar!,
        startPosition: GameParty().isServer() ? Vector2(size.x / 2 - 280 / 2 + 40, 545) : Vector2(size.x / 2 - 280 / 2 - 40, 545),
        mainCharacter: false,
        training: getParentWidget()!.widget.training,
      ));
    }
    await add(countdownText = TextComponent(text: waitTime.toStringAsFixed(2), startPosition: Vector2(size.x / 2, 200), style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0), fontSize: 30, fontFamily: "SuperBubble")));
    await add(blood = Blood(Vector2(size.x / 2 - 150, 570), Vector2(size.x / 2 + 150, 570)));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(state == GameState.choosing){
      waitTime -= dt;
      if(waitTime < 1.0){
        if(!sub1) remove(countdownText!);
        sub1 = true;
        if(waitTime < 0.0){
          if(GameParty().isServer()) startFallingLogic(Random().nextBool());
        }
      } else {
        if(countdownText != null) countdownText!.setText((waitTime-1).toStringAsFixed(2));
      }
    } else if(state == GameState.falling){
      fallingSpeed += gravity * dt;
      clouds.forEach((element) {
        element.downPosition(fallingSpeed * dt);
      });
      bool result = leftPlatform!.goUp(fallingSpeed * dt);
      rightPlatform!.goUp(fallingSpeed * dt);
      if(result){
        if(leftPlatform!.isPiky() && (player!.isDead(true) || (!getParentWidget()!.widget.training && playerOpponent!.isDead(true)))
            || rightPlatform!.isPiky() && (player!.isDead(false) || (!getParentWidget()!.widget.training && playerOpponent!.isDead(false)))){
          blood!.show(leftPlatform!.isPiky());
        }
        if(player!.isDead(leftPlatform!.isPiky())){
          life--;
          getParentWidget()!.setMainPlayerText("Life:\n$life");
          if(life <= 0){
            if(getParentWidget()!.widget.training){
              getParentWidget()!.quitTraining();
            } else {
              getParentWidget()!.setCurrentPlayerScore(0);
              GameParty().sendMessageToServer(jsonEncode(EventData(EventType.PIKE_DEAD.text, "c'est ciao")));
              GameParty().sendMessageToClient(jsonEncode(EventData(EventType.PIKE_DEAD.text, "c'est ciao")));
            }
          }
        }
        fallingSpeed = 0.0;
        state = GameState.choosing;
        waitTime = 7.0;
        leftPlatform!.setPike(false);
        rightPlatform!.setPike(false);
        add(countdownText!);
        sub1 = false;
      }
    }
  }

  void startFallingLogic(bool side){
    state = GameState.falling;
    leftPlatform!.hide();
    rightPlatform!.hide();
    if(side){
      leftPlatform!.setPike(true);
      if(!getParentWidget()!.widget.training) GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.SIDE_PIKE.text, "left")));
    } else {
      rightPlatform!.setPike(true);
      if(!getParentWidget()!.widget.training) GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.SIDE_PIKE.text, "right")));
    }
    fallingSpeed = 0.0;
  }


}