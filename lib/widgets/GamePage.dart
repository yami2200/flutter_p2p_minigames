import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../network/EventData.dart';
import '../network/EventType.dart';
import '../utils/GameParty.dart';
import '../utils/PlayerInfo.dart';
import 'TwoPlayerInfo.dart';

class GamePage extends StatefulWidget {
  final Color bannerColor;
  final bool training;
  final String background;

  const GamePage({required this.bannerColor, required this.training, required this.background});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  String mainPlayerText = "";
  String opponentPlayerText = "";
  final Completer<PlayerInfo> _myOpponentCompleter = Completer<PlayerInfo>();
  Future<PlayerInfo> get opponentPlayer => _myOpponentCompleter.future;

  void setMainPlayerText(String text){
    setState(() {
      mainPlayerText = text;
    });
    if(!widget.training){
      GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.PLAYER_PROGESS_TEXT.text, text)));
    }
  }

  @override
  void initState() {
    super.initState();
    if(!widget.training){
      GameParty().connection!.addClientMessageListener((message) {
        checkIsTextPlayerMessage(message);
        onMessageFromClient(message);
      });
      GameParty().connection!.addServerMessageListener((message) {
        checkIsTextPlayerMessage(message);
        onMessageFromServer(message);
      });
      if(GameParty().opponent != null){
        _myOpponentCompleter.complete(GameParty().opponent!);
      }
    }
  }

  void checkIsTextPlayerMessage(EventData message){
    if(message.type == EventType.PLAYER_PROGESS_TEXT.text){
      setState(() {
        opponentPlayerText = message.data;
      });
    }
  }

  void onMessageFromServer(EventData message) {}

  void onMessageFromClient(EventData message) {}

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>.from(buildWidget(context));
    widgets.insert(0, Padding(
      padding: const EdgeInsets.all(8.0),
      child: TwoPlayerInfo(
        player2: widget.training ? null : opponentPlayer,
        player1Text: mainPlayerText,
        player2Text: widget.training ? null : opponentPlayerText,
        cardColor: widget.bannerColor,
      ),
    ));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.background),
            fit: BoxFit.cover,
        ),
      ),
      child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
    );
  }

  List<StatelessWidget> buildWidget(BuildContext context) {
    return [const Text("Override this method")];
  }
}