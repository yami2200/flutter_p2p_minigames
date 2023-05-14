import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import 'GameParty.dart';

class SoloChallenge{
  static bool inChallenge = false;
  static int gamePlayed = 0;

  static void startChallenge(){
    inChallenge = true;
    gamePlayed = -1;
    continueChallenge();
  }

  static void continueChallenge(){
    gamePlayed++;
    if(gamePlayed >= 3){
      stopChallenge();
      return;
    }
    var nextGame = GameParty().getNextGame();
    BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
    ctx!.go("${nextGame.path.substring(0, nextGame.path.length - 1)}training");
  }

  static void stopChallenge() async{
    inChallenge = false;
    final player = AudioPlayer();
    await player.setSource(AssetSource('audios/win.wav'));
    await player.resume();
    GameParty().resetFromChallenge();
    BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
    ctx!.go("/");
  }
}