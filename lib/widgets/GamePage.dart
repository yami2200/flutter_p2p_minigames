import 'dart:async';
import 'dart:convert';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';
import '../network/EventData.dart';
import '../network/EventType.dart';
import '../utils/GameParty.dart';
import '../utils/PlayerInfo.dart';
import 'TwoPlayerInfo.dart';

class GamePage extends StatefulWidget {
  final Color bannerColor;
  final bool training;
  final String background;
  final FlameGame? gameInstance;

  GamePage({super.key, required this.bannerColor, required this.training, required this.background, this.gameInstance});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  String mainPlayerText = "";
  String opponentPlayerText = "";
  String backgroundImage = "";
  final Completer<PlayerInfo> _myOpponentCompleter = Completer<PlayerInfo>();
  Future<PlayerInfo> get opponentPlayer => _myOpponentCompleter.future;
  bool scoreReceived = false;
  bool scoreSent = false;

  void setMainPlayerText(String text){
    setState(() {
      mainPlayerText = text;
    });
    if(!widget.training){
      GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.PLAYER_PROGESS_TEXT.text, text)));
      GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.PLAYER_PROGESS_TEXT.text, text)));
    }
  }

  void setBackgroundImage(String background){
    setState(() {
      backgroundImage = background;
    });
  }

  @override
  void initState() {
    super.initState();
    backgroundImage = widget.background;
    if(!widget.training){
      GameParty().connection!.clearMessageListener();
      GameParty().connection!.addClientMessageListener((message) {
        _checkIsTextPlayerMessage(message);
        _checkIsReadyMessage(message);
        _checkIsScoreMessage(message);
        _checkIsEndGameMessageForClient(message);
        onMessageFromServer(message);
      });
      GameParty().connection!.addServerMessageListener((message) {
        _checkIsTextPlayerMessage(message);
        _checkIsReadyMessage(message);
        _checkIsScoreMessage(message);
        onMessageFromClient(message);
      });
      if(GameParty().opponent != null){
        _myOpponentCompleter.complete(GameParty().opponent!);
      }
      GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.READY.text, "ready")));
      GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.READY.text, "ready")));
      if(GameParty().isServer()){
        Future.delayed(const Duration(milliseconds: 150), () {
          onStartGame();
        });
      }
    } else {
      Future.delayed(const Duration(milliseconds: 250), () {
        onStartGame();
      });
    }
  }

  void _checkIsTextPlayerMessage(EventData message){
    if(message.type == EventType.PLAYER_PROGESS_TEXT.text){
      setState(() {
        opponentPlayerText = message.data;
      });
    }
  }

  void _checkIsReadyMessage(EventData message){
    if(message.type == EventType.READY.text){
      if(GameParty().isServer()) {
        BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
        ctx!.go("/hub");
      } else {
        onStartGame();
      }
    }
  }

  void quitTraining(){
    if(widget.training){
      BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
      ctx!.go("/training");
    }
  }

  void setCurrentPlayerScore(int scoreGain){
    if(widget.training) return;
    GameParty().playerList.firstWhere((p) => p.playerInfo.username == GameParty().player!.username).score += scoreGain;
    GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.ADD_PLAYER_SCORE.text, scoreGain.toString())));
    GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.ADD_PLAYER_SCORE.text, scoreGain.toString())));
  }

  void _checkIsScoreMessage(EventData message){
    if(message.type == EventType.ADD_PLAYER_SCORE.text){
      GameParty().playerList.firstWhere((p) => p.playerInfo.username == GameParty().opponent!.username).score += int.parse(message.data);
      scoreReceived = true;
      if(GameParty().isServer()){
        if(scoreSent){
          GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.END_GAME.text, "end")));
          GameParty().gamesPlayed++;
        }
      } else {
        GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.RECEIVED_SCORE.text, "received")));
      }
    } else if(message.type == EventType.RECEIVED_SCORE.text){
      scoreSent = true;
      if(scoreReceived){
        GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.END_GAME.text, "end")));
        GameParty().gamesPlayed++;
      }
    }
  }

  void _checkIsEndGameMessageForClient(EventData message){
    if(message.type == EventType.END_GAME.text){
      GameParty().gamesPlayed++;
      BuildContext? ctx = MyApp.router.routerDelegate.navigatorKey.currentContext;
      ctx!.go("/hub");
    }
  }

  void onMessageFromServer(EventData message) {}

  void onMessageFromClient(EventData message) {}

  void onStartGame(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
              child: TwoPlayerInfo(
                player2: widget.training ? null : opponentPlayer,
                player1Text: mainPlayerText,
                player2Text: widget.training ? null : opponentPlayerText,
                cardColor: widget.bannerColor,
              ),
            ),
            Expanded(child: buildWidget(context)),
          ],
        ),
      ),
    );
  }

  Widget buildWidget(BuildContext context) {
    return const Text("Override this method");
  }
}