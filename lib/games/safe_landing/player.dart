import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../safe_landing/game.dart';
import 'landing_platform.dart';

enum PlayerState { waiting, falling, flying, landed }

class Player extends SpriteComponent
    with HasGameRef<SafeLandingsGame>, CollisionCallbacks {
  Player({
    required this.onLand,
    required this.avatar,
  }) : super(size: Vector2(90, 88));

  late PlayerState state = PlayerState.waiting;

  late final Vector2 velocity = Vector2.zero();
  static const double gravity = 500.0;

  final Function onLand;

  String avatar = 'player.png';

  @override
  final images = Images(prefix: 'assets/avatars/');

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(avatar, images: images);
    size = Vector2(33, 32) * 3;
    add(RectangleHitbox());
  }

  void startFall() {
    state = PlayerState.falling;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is LandingPlatform) {
      if (state == PlayerState.falling) {
        state = PlayerState.landed;
        velocity.x = 0;
        velocity.y = 0;
        position.y = other.position.y - size.y+18;
        onLand();
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state != PlayerState.falling && state != PlayerState.flying) {
      return;
    }
    velocity.y += gravity * dt;
    position += velocity * dt;
  }
}
