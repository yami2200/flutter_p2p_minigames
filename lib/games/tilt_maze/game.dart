import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/tilt_maze/cheese.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../network/EventData.dart';
import '../../network/EventType.dart';
import '../../utils/GameParty.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';
import 'rat.dart';



const int maxCheese = 1;

class TiltMazePage extends FlameGamePage {

  TiltMazePage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      gameInstance: TiltMazeInstance(training: training));

  @override
  GamePageState createState() => _TiltMazePageState();
}

class _TiltMazePageState extends FlameGamePageState {

  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets(){
    return {
      'winTraining': (context, data) => AlertDialog(
        title: const Text('Bravo!'),
        content: const Text('You ate $maxCheese cheese!'),
        actions: [
          TextButton(
              onPressed: () {
                quitTraining();
                widget.gameInstance?.overlays.remove('winTraining');
              },

              child: const Text('OK'))
        ],

      ),
      'waitingOpponent': (context, data) => const AlertDialog(
        title: Text('Waiting for your opponent...'),
        content: Text('You can do it!'),
      ),
    };
  }
}

class TiltMazeInstance extends FlameGameInstance with HasCollisionDetection {
  final bool training;


  TiltMazeInstance({required this.training});
  late final Rat _rat;
  late Vector2 _acceleration;
  
  final Random _random = Random();

  late Cheese _cheese;

  int _cheeseCount = 0;


  void onCheeseCollision() {
    updateCheese();
    _cheeseCount++;
    getParentWidget()?.setMainPlayerText("You ate $_cheeseCount cheese!");

    if (_cheeseCount >= maxCheese) {
      remove(_rat);
      if (training) {
        overlays.add("winTraining");
      } else {
        GameParty().sendToOpponent(jsonEncode(EventData(EventType.TILT_MAZE_END.text, jsonEncode({}))));
        var score = 20 * _cheeseCount / maxCheese;
        var ceil = score.ceil();
        getParentWidget()?.setCurrentPlayerScore(ceil);
        overlays.add("waitingOpponent");
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("tilt_maze/floor.jpg"));
    super.onLoad();
    add(ScreenHitbox());
    _rat = Rat(onCheeseCollision);
    add(_rat);
    _acceleration = Vector2.zero();
    _initSensors();

    addCheese();

  }

  void addCheese() {
    // random position on the screen
    var position = Vector2(
      _random.nextDouble() * (size.x),
      _random.nextDouble() * (size.y),
    );

    // add the cheese
    _cheese = Cheese(position: position);
    add(_cheese);
  }

  void updateCheese() {
    var position = Vector2(
      _random.nextDouble() * (size.x),
      _random.nextDouble() * (size.y),
    );

    remove(_cheese);
    _cheese = Cheese(position: position);
    add(_cheese);
  }

  void _initSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _acceleration = Vector2(-event.x, event.y) * 1; // Adjust the multiplier for sensitivity
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rat.updateAcceleration(_acceleration);
  }


  @override
  void onMessageFromClient(EventData message) {
    if (message.type == EventType.TILT_MAZE_END.text) {
      getParentWidget()?.setCurrentPlayerScore(_cheeseCount);
      overlays.add("waitingOpponent");
    }
  }

  @override
  void onMessageFromServer(EventData message) {
    if (message.type == EventType.TILT_MAZE_END.text) {
      getParentWidget()?.setCurrentPlayerScore(_cheeseCount);
      overlays.add("waitingOpponent");
    }
  }

  @override
  void onStartGame() {
    // TODO: implement onStartGame
  }
}