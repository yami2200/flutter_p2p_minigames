import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'game.dart';

class Cheese extends SpriteComponent
    with HasGameRef<EatThatCheeseInstance>, CollisionCallbacks {
  @override
  final images = Images(prefix: 'assets/images/tilt_maze/');

  Cheese({
    required Vector2 position,
  }) : super(size: Vector2.all(50), position: position);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('cheese.png', images: images);
    add(CircleHitbox());
  }
}
