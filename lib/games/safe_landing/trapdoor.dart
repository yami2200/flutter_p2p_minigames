import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';

class Trapdoor extends SpriteComponent with HasGameRef<SafeLandingsGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('platform.png');
    size = Vector2(40, 20) * 3;
    // position = Vector2(gameRef.size.x / 2 - size.x / 2, 20 + 32*7);
  }

  void destroy() {
    gameRef.remove(this);
  }
}