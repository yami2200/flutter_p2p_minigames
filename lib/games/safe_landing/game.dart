import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_minigames/games/safe_landing/start_button.dart';
import 'Countdown.dart';
import 'background_image.dart';
import 'landing_platform.dart';
import 'trapdoor.dart';
import 'player.dart';

class SafeLandingsGame extends FlameGame with HasCollisionDetection {

  late final Player player;
  late final Countdown countdown;

  late final Trapdoor trapdoor;
  late final LandingPlatform landingPlatform;
  late final StartButton startButton;


  @override
  Future<void> onLoad() async {
    add(BackgroundComponent());
    add(player = Player(onLand: () {
      countdown.pause();
      if (countdown.isFinished) {
        // display win message


      } else {

      }
    }));
    add(trapdoor = Trapdoor());
    add(landingPlatform = LandingPlatform());
    add(ScreenHitbox());

    add(countdown = Countdown());
    add(startButton = StartButton(
      text: 'Open',
      style: TextStyle(color: Colors.white, fontSize: 24.0),
      color: Colors.blue,
      textColor: Colors.white,
      onTap: () {
        trapdoor.destroy();
        player.startFall();
        this.remove(startButton);
      },
    ));

  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

// export game as a widget

class SafeLandingsGameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SafeLandingsGame(),
    );
  }
}