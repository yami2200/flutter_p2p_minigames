import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter_p2p_minigames/widgets/FlameGamePage.dart';

import '../main.dart';
import '../network/EventData.dart';

abstract class FlameGameInstance extends FlameGame {

  void onMessageFromServer(EventData message);

  void onMessageFromClient(EventData message);

  void onStartGame();

  FlameGamePageState? getParentWidget(){
    return keyFlameGamePage.currentState;
  }
}