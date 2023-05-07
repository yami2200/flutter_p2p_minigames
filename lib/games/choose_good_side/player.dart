import 'package:flame/cache.dart';
import 'package:flame/components.dart';

enum PlayerState { waiting, goingRight, goingLeft }

class Player extends SpriteComponent{
  PlayerState state = PlayerState.waiting;

  Vector2 velocity = Vector2.zero();
  static const double gravity = 500.0;
  String avatar = 'player.png';
  Vector2 startPosition;

  @override
  final images = Images(prefix: 'assets/avatars/');

  Player({
    required this.avatar,
    required this.startPosition,
  }) : super(size: Vector2(90, 88));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(avatar, images: images);
    size = Vector2(33, 33) * 3;
    position = startPosition;
  }

}