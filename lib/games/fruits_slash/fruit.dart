import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/games/fruits_slash/slash.dart';

import 'fruit_type.dart';

class Fruit extends SpriteComponent {
  Fruit(
    this.fruitType, {
    required this.velocity,
    required this.rotationSpeed,
    required Vector2 position,
  }) : super(size: Vector2(90, 90)) {
    this.position = position;
  }

  final FruitType fruitType;
  final Vector2 velocity;
  final double rotationSpeed;
  bool isSliced = false;

  @override
  final images = Images(prefix: 'assets/images/fruits_slash/');

  @override
  Future<void> onLoad() async {
    String fruitImage;
    switch (fruitType) {
      case FruitType.orange:
        fruitImage = 'fruit1.png';
        break;
      case FruitType.apple:
        fruitImage = 'fruit2.png';
        break;
      case FruitType.cherry:
        fruitImage = 'fruit3.png';
        break;
      case FruitType.grape:
        fruitImage = 'fruit4.png';
        break;
      case FruitType.pear:
        fruitImage = 'fruit5.png';
        break;
      case FruitType.greenApple:
        fruitImage = 'fruit6.png';
        break;
      case FruitType.mango:
        fruitImage = 'fruit7.png';
        break;
    }

    sprite = await Sprite.load(fruitImage, images: images);
    add(CircleHitbox());
  }

  void slice() {
    isSliced = true;
    // make it fall very fast
    velocity.y = 1000;
  }


  @override
  void update(double dt) {
    super.update(dt);
    angle += rotationSpeed * dt;
    velocity.y += 400 * dt;
    position += velocity * dt;
  }
}
