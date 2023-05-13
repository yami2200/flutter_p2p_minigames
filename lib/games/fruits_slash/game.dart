import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/fruits_slash/fruit_type.dart';
import 'package:flutter_p2p_minigames/games/fruits_slash/slash.dart';

import '../../network/EventData.dart';
import '../../network/EventType.dart';
import '../../utils/GameParty.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';
import 'fruit.dart';


const int maxSlicedFruits = 20;

class FruitsSlashPage extends FlameGamePage {

  FruitsSlashPage({super.key, required bool training})
      : super(bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
      training: training,
      gameInstance: FruitsSlashInstance(training: training));

  @override
  GamePageState createState() => _FruitsSlashPageState();
}

class _FruitsSlashPageState extends FlameGamePageState {

  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets(){
    return {
      'winTraining': (context, data) => AlertDialog(
        title: const Text('Bravo!'),
        content: const Text('You sliced $maxSlicedFruits fruits!'),
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

class FruitsSlashInstance extends FlameGameInstance with DragCallbacks, HasCollisionDetection {





  FruitsSlashInstance({required this.training});

  List<Fruit> fruits = [];
  final Random _random = Random();

  final Paint _slashPaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 10..color = Colors.grey;
  late final Slash _slash = Slash(initialPoints: [], paint: _slashPaint);
  final bool training;
  bool finished = false;

  int slicedFruits = 0;

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("fruits_slash/background.jpg"));

    for (int i = 0; i < 4; i++) {
      addFruit();
    }

    add(_slash);
  }

  void addFruit() {
    final position = Vector2(
      _random.nextDouble() * (size.x - 20) + 20,
      size.y + 10,
    );
    final velocity = Vector2(
      _random.nextDouble() * 2 - 1,
      -_random.nextDouble() * 500 - 500,
    );

    final rotationSpeed = _random.nextDouble() * 2 - 1;

    final fruit = Fruit(
      FruitType.values[_random.nextInt(FruitType.values.length)],
      position: position,
      velocity: velocity,
      rotationSpeed: rotationSpeed,
    );

    fruits.add(fruit);
    add(fruit);
  }

  bool _isCollision(Fruit fruit, Slash slash) {
    if (fruit.isSliced) {
      return false;
    }
    if (slash.points.length < 2) {
      return false;
    }
    for (int i = 0; i < slash.points.length - 1; i++) {
      final startPoint = slash.points.first;
      final endPoint = slash.points.last;
      if (fruit.toRect().intersectsSegment(startPoint, endPoint)) {
        return true;
      }
    }
    return false;
  }


  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (slicedFruits >= maxSlicedFruits) return;
    _slash.addPoint(event.localPosition);
  }

  @override
  void update(double dt) {
    super.update(dt);
      fruits.forEach((fruit) {
        if (_isCollision(fruit, _slash)) {
          fruit.slice();
          slicedFruits = min(slicedFruits + 1, maxSlicedFruits);
          getParentWidget()?.setMainPlayerText("$slicedFruits fruits\nsliced!");
        }
      });

    // filter all fruits that are or are out of the screen
    var filterdFruits = fruits.where((fruit) => fruit.position.y > size.y).toList();

    filterdFruits.forEach((fruit) {
      remove(fruit);
      fruits.remove(fruit);
    });

    if (slicedFruits >= maxSlicedFruits) {
      if (training) {
        overlays.add("winTraining");
      } else {
        if(!finished){
          finished = true;
          GameParty().sendToOpponent(jsonEncode(EventData(EventType.FRUITS_SLASH_END.text, jsonEncode({}))));
          getParentWidget()?.setCurrentPlayerScore(slicedFruits);
          overlays.add("waitingOpponent");
        }
      }
      return;
    }
    children.whereType<Fruit>().length < 4 ? addFruit() : null;
  }


  @override
  void onMessageFromClient(EventData message) {
    if (message.type == EventType.FRUITS_SLASH_END.text) {
      if(!finished){
        getParentWidget()?.setCurrentPlayerScore(slicedFruits);
        overlays.add("waitingOpponent");
        finished = true;
      }
    }
  }

  @override
  void onMessageFromServer(EventData message) {
    if (message.type == EventType.FRUITS_SLASH_END.text) {
      if(!finished){
        getParentWidget()?.setCurrentPlayerScore(slicedFruits);
        overlays.add("waitingOpponent");
        finished = true;
      }
    }
  }

  @override
  void onStartGame() {
    getParentWidget()?.setMainPlayerText("0 fruit\nsliced!");
    getParentWidget()!.playMusic("audios/fruits.mp3");
  }
}