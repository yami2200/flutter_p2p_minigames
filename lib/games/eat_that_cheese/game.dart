import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/eat_that_cheese/cheese.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../network/EventData.dart';
import '../../network/EventType.dart';
import '../../utils/GameParty.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';
import 'rat.dart';

const int maxCheese = 5;

class EatThatCheesePage extends FlameGamePage {
  EatThatCheesePage({super.key, required bool training})
      : super(
            bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
            training: training,
            gameInstance: EatThatCheeseInstance(training: training));

  @override
  GamePageState createState() => _EatThatCheesePageState();
}

class _EatThatCheesePageState extends FlameGamePageState {
  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets() {
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

class EatThatCheeseInstance extends FlameGameInstance
    with HasCollisionDetection {
  final bool training;

  EatThatCheeseInstance({required this.training});

  late final Rat _rat;
  late Vector2 _acceleration;

  final Random _random = Random();

  late Cheese _cheese;

  int _cheeseCount = 0;

  Queue<Vector2> cheesePositions = Queue<Vector2>();

  late Vector2 smallestScreenSize;

  void onCheeseCollision() {
    if(cheesePositions.isNotEmpty) updateCheese();
    _cheeseCount++;
    getParentWidget()?.setMainPlayerText("$_cheeseCount cheese\neated!");

    if (_cheeseCount >= maxCheese) {
      remove(_rat);
      if (training) {
        overlays.add("winTraining");
      } else {
        GameParty().sendToOpponent(jsonEncode(
            EventData(EventType.TILT_MAZE_END.text, jsonEncode({}))));
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
    smallestScreenSize = size;
  }

  void addCheese() {
    // get the cheese from the queue
    var position = cheesePositions.removeFirst();

    // add the cheese
    _cheese = Cheese(position: Vector2(position.x * size.x, position.y * size.y));
    add(_cheese);
  }

  void updateCheese() {
    var position = cheesePositions.removeFirst();

    remove(_cheese);
    _cheese = Cheese(position: Vector2(position.x * size.x, position.y * size.y));
    add(_cheese);
  }

  Vector2 randomPositionOnScreen(double maxX, double maxY) {
    // generate a random position on the screen, have a margin of 100px each side
    var vector = Vector2(
        _random.nextDouble() * (maxX - 200) + 100,
        _random.nextDouble() * (maxY - 200) + 100);

    // normalize the position so that it will be a percentage of the screen
    vector = Vector2(vector.x / maxX, vector.y / maxY);

    return vector;
  }

  void _initSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      _acceleration = Vector2(-event.x, event.y) *
          1; // Adjust the multiplier for sensitivity
    });
  }


  var lastCheeseTime = DateTime.now();

  @override
  void update(double dt) {
    super.update(dt);
    _rat.updateAcceleration(_acceleration);


  }

  @override
  void onMessageFromClient(EventData message) {
    if (message.type == EventType.SCREEN_DIMENSION.text) {
      // get the screen size
      var screenSize = vector2FromJson(jsonDecode(message.data)['size']);
      // set the screen size to the smallest screen size (between screenSize and this.size)
      smallestScreenSize = Vector2(
          min(screenSize.x, size.x), min(screenSize.y, size.y));

      // generate random positions
      List<Vector2> positions = generateRandomPositions();

      // add the positions to the queue
      cheesePositions.addAll(positions);

      // send the positions to the client
      GameParty().sendToOpponent(jsonEncode(EventData(
          EventType.TILT_MAZE_START.text,
          jsonEncode({'positions': positions.map((e) => vector2ToJson(e)).toList()}))));

      // add the first cheese
      addCheese();
    } else if (message.type == EventType.TILT_MAZE_END.text) {
      getParentWidget()?.setCurrentPlayerScore(_cheeseCount);
      overlays.add("waitingOpponent");
    }
  }




  @override
  void onMessageFromServer(EventData message) {
    if (message.type == EventType.TILT_MAZE_START.text) {
      // get the positions from the message
      List<dynamic> rawPositions = jsonDecode(message.data)['positions'];

      // convert the positions to Vector2
      Iterable<Vector2> positions = rawPositions.map((e) => vector2FromJson(e) as Vector2);
      // add the positions to the queue
      cheesePositions.addAll(positions);
      // add the first cheese
      addCheese();

    } else if (message.type == EventType.TILT_MAZE_END.text) {
      getParentWidget()?.setCurrentPlayerScore(_cheeseCount);
      overlays.add("waitingOpponent");
    }
  }

  @override
  void onStartGame() {

    getParentWidget()!.playMusic("audios/eatcheese.mp3");

    if (training) {
      // generate random positions
      List<Vector2> positions = generateRandomPositions();

      // add the positions to the queue
      cheesePositions.addAll(positions);

      // add the first cheese
      addCheese();

      return;
    }

    if (!GameParty().isServer()) {
      // send screen size to the server
      GameParty().sendToOpponent(jsonEncode(EventData(
          EventType.SCREEN_DIMENSION.text,
          jsonEncode({'size': vector2ToJson(size)}))));
    }
  }

  List<Vector2> generateRandomPositions() {
    var positions = <Vector2>[];
    for (var i = 0; i < maxCheese; i++) {
      positions.add(randomPositionOnScreen(smallestScreenSize.x, smallestScreenSize.y));
    }
    return positions;
  }

  Object vector2ToJson(Vector2 vector2) {
    return {
      'x': vector2.x,
      'y': vector2.y,
    };
  }

  Vector2 vector2FromJson(Map json) {
    return Vector2(
      json['x'],
      json['y'],
    );
  }
}
