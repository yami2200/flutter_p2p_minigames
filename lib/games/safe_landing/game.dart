
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'landing_platform.dart';
import 'trapdoor.dart';
import 'player.dart';

class SafeLandingsGame extends FlameGame with HasTappables, HasCollisionDetection {

  late final Player player;


  @override
  Future<void> onLoad() async {
    add(player = Player());
    add(Trapdoor());
    add(LandingPlatform());
    add(ScreenHitbox());
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