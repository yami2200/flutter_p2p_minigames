import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../safe_landing/game.dart';
import 'landing_platform.dart';

enum PlayerState { waiting, falling, flying, landed }


class Player extends SpriteComponent
    with HasGameRef<SafeLandingsGame>, CollisionCallbacks {

  Player({
    required this.onLand,
}) : super(size: Vector2(90, 88));

  late PlayerState state = PlayerState.waiting;

  late final Vector2 velocity = Vector2.zero();
  static const double gravity = 500.0;

  final Function onLand;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    sprite = await Sprite.load('player.png');
    size = Vector2(33, 32)*3;
    position = Vector2(gameRef.size.x / 2 - size.x / 2, 20);

    add(CircleHitbox());
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
      state = PlayerState.landed;
      velocity.x = 0;
      velocity.y = 0;
      position.y = other.position.y - size.y;
      onLand();
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