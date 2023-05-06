import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../network/EventData.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import 'FlameGameInstance.dart';

class GAMENAMEPage extends FlameGamePage {

  GAMENAMEPage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      gameInstance: GAMENAMEInstance());

  @override
  GamePageState createState() => _GAMENAMEPageState();
}

class _GAMENAMEPageState extends FlameGamePageState {

  @override
  void onMessageFromServer(EventData message) {}

  @override
  void onMessageFromClient(EventData message) {}

  @override
  void onStartGame(){}

  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets(){
    return null;
  }
}

class GAMENAMEInstance extends FlameGameInstance{
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
    // TODO: implement onStartGame
  }
}