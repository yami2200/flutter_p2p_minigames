import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class BackgroundComponent extends SpriteComponent with HasGameRef<FlameGame> {
  final String backgroundImage;

  BackgroundComponent(this.backgroundImage) : super(size: Vector2.zero());

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(backgroundImage);
    fitSize(gameRef.size);
    position = Vector2.zero();
    centerImage();
  }

  void fitSize(Vector2 gameSize) {

    final image_x = sprite?.srcSize.x ?? 1;
    final image_y = sprite?.srcSize.y ?? 1;

    final screenAspectRatio = gameSize.x / gameSize.y;
    final imageAspectRatio = image_x / image_y;
    if (screenAspectRatio > imageAspectRatio) {
      size = Vector2(gameSize.x, gameSize.x / imageAspectRatio);
    } else {
      size = Vector2(gameSize.y * imageAspectRatio, gameSize.y);
    }
  }

  void centerImage() {
    final diff = gameRef.size - size;
    position = diff / 2;
  }
}
