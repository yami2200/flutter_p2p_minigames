import 'package:flutter/material.dart';
import '../../network/EventData.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import '../FlameGameInstance.dart';

class TiltMazePage extends FlameGamePage {

  TiltMazePage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      gameInstance: TiltMazeInstance());

  @override
  GamePageState createState() => _TiltMazePageState();
}

class _TiltMazePageState extends FlameGamePageState {

  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets(){
    return null;
  }
}

class TiltMazeInstance extends FlameGameInstance {
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