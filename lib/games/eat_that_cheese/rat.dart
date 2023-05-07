import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'cheese.dart';
import 'game.dart';

class Rat extends SpriteComponent with HasGameRef<EatThatCheeseInstance>, CollisionCallbacks {
  @override
  final images = Images(prefix: 'assets/images/tilt_maze/');

  static const double _radius = 40;
  late Vector2 _velocity;
  static const double speed = 500;
  static const degree = pi / 180;

  Rat(this.onCheeseCollision) : super(size: Vector2.all(_radius * 2)) {
    _velocity = Vector2.zero();
    anchor = Anchor.center;
  }

  final Function onCheeseCollision;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('rat.png', images: images);
    add(CircleHitbox(radius: _radius));

    position = gameRef.size / 2;
  }

  void updateAcceleration(Vector2 acceleration) {
    _velocity = acceleration;
    position += _velocity;
    position.x = position.x.clamp(_radius, gameRef.size.x - _radius);
    position.y = position.y.clamp(_radius, gameRef.size.y - _radius);
  }

  @override
  void update(double dt) {
    super.update(dt);


  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Cheese) {
      onCheeseCollision();
      return;
    }

    final collisionPoint = intersectionPoints.first;

    // Horizontal collision
    if (collisionPoint.x <= _radius || collisionPoint.x >= gameRef.size.x - _radius) {
      _velocity.x = -_velocity.x * 0.5;
    }

    // Vertical collision
    if (collisionPoint.y <= _radius || collisionPoint.y >= gameRef.size.y - _radius) {
      _velocity.y = -_velocity.y * 0.5;
    }

  }
}