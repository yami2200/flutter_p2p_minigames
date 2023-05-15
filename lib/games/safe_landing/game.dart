import 'dart:convert';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/safe_landing/start_button.dart';

import '../../network/EventData.dart';
import '../../network/EventType.dart';
import '../../utils/GameParty.dart';
import '../../widgets/FlameGamePage.dart';
import '../../widgets/GamePage.dart';
import '../FlameGameInstance.dart';
import '../components/BackgroundComponent.dart';
import 'Countdown.dart';
import 'landing_platform.dart';
import 'player.dart';
import 'trapdoor.dart';

class SafeLandingsGame extends FlameGameInstance
    with HasCollisionDetection, HasGameRef<SafeLandingsGame> {
  late final Player player;
  late final Player playerOpponent;

  late final Trapdoor trapdoor;
  late final Trapdoor trapdoorOpponent;

  late final LandingPlatform landingPlatform;
  late final LandingPlatform landingPlatformOpponent;

  late final Countdown countdown;
  late final Countdown countdownOpponent;
  bool countdownfinished = false;

  late final StartButton startButton;
  bool isTraining;
  String myAvatar = GameParty().player?.avatar ?? 'avatar0.png';
  String? opponentAvatar = GameParty().opponent?.avatar;

  late final yPosition = 200.0;

  SafeLandingsGame(this.isTraining);

  Function? onPlayerStartFall;

  void makeOpponentFall() {
    if (isTraining) return;
    playerOpponent.startFall();
  }

  @override
  Future<void> onLoad() async {
    await add(BackgroundComponent("choosegoodside/background_2sides.png"));
    //add(BackgroundComponent("background.jpg"));

    add(trapdoor = Trapdoor());

    add(landingPlatform = LandingPlatform());

    add(player = Player(
        onLand: () {
          countdownfinished = true;
          countdown.pause();
          if (countdown.getValue() < 1) {
            // display win message
            getParentWidget()?.setCurrentPlayerScore(10 + ((1-countdown.getValue()) * 10).round());
            if (isTraining) {
              overlays.add("winTraining");
            } else {
              overlays.add("waitingOpponent");
            }
          } else {
            // display lose message
            if(countdown.getValue() < 2) {getParentWidget()?.setCurrentPlayerScore(((2-countdown.getValue()) * 10).round());}
            else {getParentWidget()?.setCurrentPlayerScore(0);}
            if (isTraining) {
              overlays.add("lostTraining");
            } else {
              overlays.add("waitingOpponent");
            }
          }
        },
        avatar: myAvatar));
    add(ScreenHitbox());

    add(countdown = Countdown(onCountdownFinish: () {
      if(countdownfinished) return;
      countdownfinished = true;
      getParentWidget()?.setCurrentPlayerScore(0);
      if (isTraining) {
        overlays.add("lostTraining");
      } else {
        overlays.add("waitingOpponent");
      }
      try {
        remove(landingPlatform);
      } catch (e) {}
    }));

    add(startButton = StartButton(
      text: 'Open',
      style: TextStyle(color: Colors.white, fontSize: 24.0),
      color: Colors.blue,
      textColor: Colors.white,
      onTap: () {
        trapdoor.destroy();
        player.startFall();
        remove(startButton);
        if (!isTraining) {
          GameParty().sendToOpponent(jsonEncode(EventData(
              EventType.SAFE_LANDING.text,
              jsonEncode({
                'message': 'START_FALL',
              }))));
        }
      },
    ));

    player.position = Vector2(size.x / 2 / 2, yPosition+20);
    trapdoor.position = Vector2(player.x, yPosition + player.size.y);
    landingPlatform.position = Vector2(size.x / 2 / 2, size.y - 50);
    countdown.position =
        Vector2(landingPlatform.x + 60, landingPlatform.y + 25);

    if (!isTraining) {
      add(playerOpponent = Player(
          onLand: () {
            countdownOpponent.pause();
            if (countdownOpponent.isFinished) {
              // display win message
            } else {}
          },
          avatar: opponentAvatar ?? 'avatar0.png'));

      add(trapdoorOpponent = Trapdoor());

      add(landingPlatformOpponent = LandingPlatform());

      add(countdownOpponent = Countdown(onCountdownFinish: () {
        // display lose message
      }));

      playerOpponent.position = Vector2(size.x / 2 + size.x / 2 / 2, yPosition);

      trapdoorOpponent.position =
          Vector2(playerOpponent.x, yPosition + playerOpponent.size.y);

      landingPlatformOpponent.position =
          Vector2(size.x / 2 + size.x / 2 / 2, size.y - 50);

      countdownOpponent.position = Vector2(
          landingPlatformOpponent.x + 60, landingPlatformOpponent.y + 25);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onMessageFromClient(EventData message) {
    if (message.type == EventType.SAFE_LANDING.text) {
      var data = message.data;
      var dataToJson = jsonDecode(data);
      var dataMessage = dataToJson['message'];
      if (dataMessage == 'START_FALL') {
        // opponent started falling
        trapdoorOpponent.destroy();
        playerOpponent.startFall();
      }
    }
  }

  @override
  void onMessageFromServer(EventData message) {
    if (message.type == EventType.SAFE_LANDING.text) {
      var data = message.data;
      var dataToJson = jsonDecode(data);
      var dataMessage = dataToJson['message'];
      if (dataMessage == 'START_FALL') {
        // opponent started falling
        trapdoorOpponent.destroy();
        playerOpponent.startFall();
      }
    }
  }

  @override
  void onStartGame() {
    getParentWidget()!.playMusic("audios/safelanding.mp3");
  }
}

class SafeLandingsGameWidget extends FlameGamePage {
  SafeLandingsGameWidget({required super.key, required bool training})
      : super(
            bannerColor: const Color.fromRGBO(154, 216, 224, 0.8),
            training: training,
            gameInstance: SafeLandingsGame(training));

  @override
  GamePageState createState() => _SafeLandingsGameWidgetState();
}

class _SafeLandingsGameWidgetState extends FlameGamePageState {
  // ALL METHODS AVAILABLE IN THE GAME PAGE TEMPLATE ARE ALSO AVAIBLE IN FLAME GAME PAGE

  @override
  Map<String, Widget Function(BuildContext, dynamic)>? overlayWidgets() {
    return {
      'lostTraining': (context, data) => AlertDialog(
            title: const Text('Game Over'),
            content: const Text('You lost'),
            actions: [
              TextButton(
                  onPressed: () {
                    quitTraining();
                    widget.gameInstance?.overlays.remove('lostTraining');
                  },

                  child: const Text('OK'))
            ],

      ),
      'winTraining': (context, data) => AlertDialog(
        title: const Text('Bravo!'),
        content: const Text('You won!'),
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
