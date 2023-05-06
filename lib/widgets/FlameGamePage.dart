import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../widgets/GamePage.dart';
import '../games/FlameGameInstance.dart';
import '../network/EventData.dart';
import 'TwoPlayerInfo.dart';

class FlameGamePage extends GamePage {
  FlameGamePage({required super.key, required bool training, required Color bannerColor, required FlameGameInstance gameInstance})
      : super(bannerColor: bannerColor,
      training: training,
      background: "assets/ui/background_capyquiz.jpg",
      gameInstance: gameInstance);

  @override
  GamePageState createState() => FlameGamePageState();
}

// Edit the state class name here (it should always extends GamePageState)
class FlameGamePageState extends GamePageState {

  @override
  void initState() {
    super.initState();
  }

  @override
  void onMessageFromServer(EventData message) {
    widget.gameInstance!.onMessageFromServer(message);
  }

  @override
  void onMessageFromClient(EventData message) {
    widget.gameInstance!.onMessageFromClient(message);
  }

  @override
  void onStartGame(){
    widget.gameInstance!.onStartGame();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget Function(BuildContext, dynamic)> overlay = {
      "banner" : (context, game) {
        return SizedBox(
          height: 170,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TwoPlayerInfo(
              player2: widget.training ? null : opponentPlayer,
              player1Text: mainPlayerText,
              player2Text: widget.training ? null : opponentPlayerText,
              cardColor: widget.bannerColor,
            ),
          ),
        );
      },
    };
    Map<String, Widget Function(BuildContext, dynamic)>? otherWidgets = overlayWidgets();
    if(otherWidgets != null){
      overlay.addAll(otherWidgets);
    }

    return GameWidget(
      game: widget.gameInstance!,
      overlayBuilderMap: overlay,
        initialActiveOverlays: ["banner"],
    );
  }

  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets(){
    return null;
  }
}