import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/face_guess/face_guess_game_instance.dart';

import '../../network/EventData.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';

class FaceGuessPage extends FlameGamePage {

  FaceGuessPage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      gameInstance: FaceGuessGameInstance());

  @override
  GamePageState createState() => _FaceGuessPageState();
}

class _FaceGuessPageState extends FlameGamePageState {

  @override
  void onMessageFromServer(EventData message) {}

  @override
  void onMessageFromClient(EventData message) {}

  @override
  void onStartGame(){
    setMainPlayerText("In progess...");
  }

  @override
  Widget buildWidget(BuildContext context) {
    return GameWidget(
        game: FaceGuessGameInstance(),
      );
  }
}