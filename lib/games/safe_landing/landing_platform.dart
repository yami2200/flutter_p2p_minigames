import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/games/safe_landing/game.dart';

class LandingPlatform extends SpriteComponent with HasGameRef<SafeLandingsGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('platformlong.png');
    size = Vector2(32, 16) * 3;
    // position = Vector2(gameRef.size.x / 2 - size.x / 2, gameRef.size.y - size.y - 25);
    add(CircleHitbox());
  }
}