import 'package:flame/game.dart';
import 'package:flutter_p2p_minigames/games/FlameGameInstance.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/platform.dart';
import 'package:flutter_p2p_minigames/network/EventData.dart';

import '../components/BackgroundComponent.dart';

class ChooseGoodSideGameInstance extends FlameGameInstance{

  Platform? leftPlatform;
  Platform? rightPlatform;

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

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("choosegoodside/background_2sides.png"));
    leftPlatform = Platform(Vector2(size.x / 2 - 280, 500), Vector2(280, 175));
    rightPlatform = Platform(Vector2(size.x / 2 , 500), Vector2(280, 175));
    await add(leftPlatform!);
    await add(rightPlatform!);
  }


}