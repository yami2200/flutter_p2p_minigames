import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/games/fruits_slash/game.dart';

import 'fruit_type.dart';

class SlashedFruit extends SpriteComponent with HasGameRef<FruitsSlashInstance> {
  SlashedFruit(
      this.fruitType, {
        required this.velocity,
        required this.rotationSpeed,
        required Vector2 position,
        this.isRight = false,
      }) : super(size: Vector2(45, 90 )) {
    this.position = position;
  }

  final FruitType fruitType;
  final Vector2 velocity;
  final double rotationSpeed;
  final bool isRight;
  @override
  final images = Images(prefix: 'assets/images/fruits_slash/');

  @override
  Future<void> onLoad() async {
    String fruitImage;
    switch (fruitType) {
      case FruitType.orange:
        fruitImage = 'fruit_sliced1.png';
        break;
      case FruitType.apple:
        fruitImage = 'fruit_sliced2.png';
        break;
      case FruitType.cherry:
        fruitImage = 'fruit_sliced3.png';
        break;
      case FruitType.grape:
        fruitImage = 'fruit_sliced4.png';
        break;
      case FruitType.pear:
        fruitImage = 'fruit_sliced5.png';
        break;
      case FruitType.greenApple:
        fruitImage = 'fruit_sliced6.png';
        break;
      case FruitType.mango:
        fruitImage = 'fruit_sliced7.png';
        break;
    }

    sprite = await Sprite.load(fruitImage, images: images);
    // rotate the sprite 180 degrees if it's the right slice
    if (isRight) {
      angle = 3.14;
      // move the sprite to the left
      position.x += 90;
      // move the sprite up a bit
      position.y += 90;
    }
  }



  @override
  void update(double dt) {
    super.update(dt);
    angle += rotationSpeed * dt;
    velocity.y += 400 * dt;
    position += velocity * dt;

    // if the sprite is out of the screen, destroy it
    if (position.y > gameRef.size.y) {
      gameRef.remove(this);
    }
  }
}