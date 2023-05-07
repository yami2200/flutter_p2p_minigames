import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter_p2p_minigames/games/FlameGameInstance.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/platform.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/player.dart';
import 'package:flutter_p2p_minigames/network/EventData.dart';

import '../../utils/GameParty.dart';
import '../components/BackgroundComponent.dart';

class ChooseGoodSideGameInstance extends FlameGameInstance with PanDetector{

  Platform? leftPlatform;
  Platform? rightPlatform;
  String myAvatar = GameParty().player?.avatar ?? 'avatar0.png';
  String? opponentAvatar = GameParty().opponent?.avatar;
  Player? player;
  Player? playerOpponent;

  @override
  void onMessageFromClient(EventData message) {
    // TODO: implement onMessageFromClient
  }

  @override
  void onMessageFromServer(EventData message) {
    // TODO: implement onMessageFromServer
  }

  @override
  void onStartGame() {
    getParentWidget()!.setMainPlayerText("Life:\n3");
  }


  @override
  void onPanUpdate(DragUpdateInfo info) {
    if(info.delta.viewport.x > 0){
      log("go right");
    } else {
      log("go left");
    }
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("choosegoodside/background_2sides.png"));
    leftPlatform = Platform(Vector2(size.x / 2 - 280, 500), Vector2(280, 175));
    rightPlatform = Platform(Vector2(size.x / 2 , 500), Vector2(280, 175));
    await add(leftPlatform!);
    await add(rightPlatform!);
    await add(player = Player(
      avatar: myAvatar,
      startPosition: GameParty().isServer() ? Vector2(size.x / 2 - 235, 500) : Vector2(size.x / 2 -135, 500),
    ));
    if(!getParentWidget()!.widget.training){
      await add(playerOpponent = Player(
        avatar: opponentAvatar!,
        startPosition: GameParty().isServer() ? Vector2(size.x / 2 -135, 500) : Vector2(size.x / 2 - 235, 500),
      ));
    }
  }




}