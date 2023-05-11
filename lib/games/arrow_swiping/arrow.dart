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
  double sizeY = 0.0;
  Function()? onLeaveScreen;
  bool waitEnd = false;

  Arrow(this.direction, {required Vector2 position, required this.speed})
      : super(size: Vector2.all(100), position: position) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('${direction.toString().split('.').last}.png', images: images);
    add(RectangleHitbox());
  }

  void addLeaveScreenEventListener(Function() onLeaveScreenE, double sizeScreenY) {
    sizeY = sizeScreenY;
    onLeaveScreen = onLeaveScreenE;
    waitEnd = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    y += speed * dt;
    if (waitEnd && y > sizeY) {
      onLeaveScreen!();
      waitEnd = false;
    }
  }
}
