import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/train_tally/train_tally_instance.dart';

import '../../widgets/FancyButton.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';

class TrainTallyPage extends FlameGamePage {

  TrainTallyPage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(40, 63, 140, 0.8),
      training: training,
      gameInstance: TrainTallyGameInstance());

  @override
  GamePageState createState() => _TrainTallyGameWidgetState();
}

class _TrainTallyGameWidgetState extends FlameGamePageState {
  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets() {
    final TrainTallyGameInstance game = widget.gameInstance as TrainTallyGameInstance;
    return {
      'end': (context, data) => AlertDialog(
        title: const Text('Finished !', style: TextStyle(color: Colors.black, fontFamily: "SuperBubble", fontSize: 25)),
        content: Text('You counted ${game.count} passengers, the train had ${game.totalPassengers} passengers.', style: const TextStyle(color: Colors.black, fontFamily: "SuperBubble", fontSize: 20)),
        actions: [
          FancyButton(
            size: 20,
            color: const Color(0xFFCA3034),
            onPressed: () => game.clickQuit(),
            child: const Text(
              "Leave",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'SuperBubble',
              ),
            ),
          ),
        ],

      ),
    };
  }
}