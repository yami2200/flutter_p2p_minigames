import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class Passenger extends SpriteComponent{

  Vector2 startPosition;
  Sprite spriteTrain;
  static Sprite? passenger1;
  static Sprite? passenger2;
  static Sprite? nopassenger;

  Passenger(this.startPosition, this.spriteTrain) : super(size: Vector2(84, 121));

  @override
  Future<void> onLoad() async {
    sprite = spriteTrain;
    size = Vector2(84, 121);
    position = startPosition;
    anchor = Anchor.center;
  }

  void move(double speed){
    position.x -= speed;
  }

}