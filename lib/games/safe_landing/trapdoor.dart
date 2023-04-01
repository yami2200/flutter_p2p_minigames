import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Trapdoor extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('platformlong.png');
    size = Vector2(32, 16) * 3;
    position = Vector2(0, 32*3);
  }
}