import 'package:flame/game.dart';
import 'package:flutter_p2p_minigames/widgets/FlameGamePage.dart';

import '../network/EventData.dart';

abstract class FlameGameInstance extends FlameGame {
  FlameGamePageState? parentWidget;

  void onMessageFromServer(EventData message);

  void onMessageFromClient(EventData message);

  void onStartGame();

  void setParentWidget(FlameGamePageState parentWidget){
    this.parentWidget = parentWidget;
  }
}