import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/arrow_swiping/arrow.dart';
import 'package:flutter_p2p_minigames/games/arrow_swiping/black_box.dart';

import '../../network/EventData.dart';
import '../../network/EventType.dart';
import '../../utils/GameParty.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';

class ArrowSwipingPage extends FlameGamePage {
  ArrowSwipingPage({super.key, required bool training})
      : super(
            bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
            training: training,
            gameInstance: ArrowSwipingInstance(training: training));

  @override
  GamePageState createState() => _ArrowSwipingPageState();
}

class _ArrowSwipingPageState extends FlameGamePageState {
  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets() {
    return {
      'winTraining': (context, data) => AlertDialog(
            title: const Text('Bravo!'),
            content: const Text('You are a beast!'),
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

class ArrowSwipingInstance extends FlameGameInstance
    with PanDetector, HasCollisionDetection {
  final double arrowSpeed = 400;
  final double arrowSpawnInterval = 0.7; // In seconds
  double _spawnArrowTimer = 0;
  final int maxArrows = 20;
  int arrowsCount = 0;
  bool finished = false;

  Arrow? selectedArrow;

  int score = 0;

  late BlackBox blackBox;

  final bool training;

  ArrowSwipingInstance({required this.training});

  Queue<ArrowDirection> arrowDirections = Queue();

  bool spawnArrow = false;

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("arrow_swiping/background.jpg"));
    add(blackBox = BlackBox(
        position: Vector2(size.x / 2, size.y - 100),
        onArrowCollision: onArrowCollision,
        onArrowCollisionEnd: onArrowCollisionEnd));
  }

  void onArrowCollision(Arrow arrow) {
    selectedArrow = arrow;
  }

  void onArrowCollisionEnd(Arrow arrow) {
    if (selectedArrow == arrow) {
      selectedArrow = null;
      remove(arrow);
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final EventDelta delta = info.delta;
    final swipeAngle = atan2(delta.viewport.x, delta.viewport.y);

    if (selectedArrow != null) {
      if (_isSwipeDirectionCorrect(swipeAngle, selectedArrow!.direction)) {
        score++;
        remove(selectedArrow!);
        if(selectedArrow!.waitEnd){
          if (training) {
            overlays.add("winTraining");
          } else {
            finishGame();
          }
        }
        selectedArrow = null;
        blackBox.showOverlay();

        getParentWidget()?.setMainPlayerText("$score/$maxArrows");
      }
    }
  }

  void finishGame(){
    if(finished) return;
    finished = true;
    if(getParentWidget()!.widget.training){
      overlays.add("winTraining");
      return;
    }
    getParentWidget()?.setCurrentPlayerScore(score);
    overlays.add("waitingOpponent");
  }

  bool _isSwipeDirectionCorrect(double swipeAngle, ArrowDirection direction) {
    double targetAngle;

    switch (direction) {
      case ArrowDirection.down:
        targetAngle = 0;
        break;
      case ArrowDirection.right:
        targetAngle = pi / 2;
        break;
      case ArrowDirection.up:
        targetAngle = pi;
        break;
      case ArrowDirection.left:
        targetAngle = 3 * pi / 2;
        break;
    }

    const double tolerance = pi / 8; // 22.5 degrees
    final diff = (swipeAngle - targetAngle).abs() % (2 * pi);
    return diff < tolerance || diff > 2 * pi - tolerance;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!spawnArrow || arrowsCount >= maxArrows) {
      return;
    }

    _spawnArrowTimer += dt;
    if (_spawnArrowTimer >= arrowSpawnInterval) {
      _spawnArrowTimer = 0;
      _addArrow();
    }
  }

  void _addArrow() {
    if (arrowDirections.isEmpty) {
      return;
    }
    var direction = arrowDirections.removeFirst();
    var position = Vector2(size.x / 2, 100);
    var arrow = Arrow(direction, position: position, speed: arrowSpeed);
    if(arrowDirections.isEmpty){
      arrow.addLeaveScreenEventListener(finishGame, size.y);
    }
    add(arrow);
    arrowsCount++;
  }

  Object arrowDirectionToJson(ArrowDirection arrowDirection) {
    return arrowDirection.name;
  }
  ArrowDirection arrowDirectionFromJson(dynamic json) {
    return ArrowDirection.values.firstWhere((element) => element.name == json);
  }

  List<ArrowDirection> randomArrowDirections(int count) {
    var directions = <ArrowDirection>[];
    for (var i = 0; i < count; i++) {
      directions.add(ArrowDirection.values[Random().nextInt(ArrowDirection.values.length)]);
    }
    return directions;
  }

  @override
  void onMessageFromClient(EventData message) {}

  @override
  void onMessageFromServer(EventData message) {
    if (message.type == EventType.ARROW_SWIPING_START.text) {

      List<dynamic> json = jsonDecode(message.data);

      List<ArrowDirection> arrowDirectionsL = json.map((e) => arrowDirectionFromJson(e)).toList();

      print(json);
      print(arrowDirectionsL);

      arrowDirections.addAll(arrowDirectionsL);

      spawnArrow = true;
    }
  }

  @override
  void onStartGame() {
    getParentWidget()?.setMainPlayerText("$score/$maxArrows");
    getParentWidget()!.playMusic("audios/swipe.mp3");

    if (training) {
      arrowDirections.addAll(randomArrowDirections(maxArrows));
      spawnArrow = true;
      return;
    }

    if (GameParty().isServer()) {
      var randomArrowDirections = this.randomArrowDirections(maxArrows);
      arrowDirections.addAll(randomArrowDirections);
      GameParty().sendToOpponent(jsonEncode(EventData(EventType.ARROW_SWIPING_START.text, jsonEncode(randomArrowDirections.map(arrowDirectionToJson).toList()))));
      spawnArrow = true;
    }
  }
}
