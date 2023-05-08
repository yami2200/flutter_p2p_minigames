import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum ArrowDirection {
  up,
  down,
  left,
  right,
}

class Arrow extends SpriteComponent {
  @override
  final images = Images(prefix: 'assets/images/arrow_swiping/');

  ArrowDirection direction;
  double speed;

  Arrow(this.direction, {required Vector2 position, required this.speed})
      : super(size: Vector2.all(100), position: position) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('${direction.toString().split('.').last}.png', images: images);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
  }
}
