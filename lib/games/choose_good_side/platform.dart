import 'package:flame/components.dart';

class Platform extends SpriteComponent {

  Vector2 startPosition;
  Vector2 initSize;
  Sprite? spritePike;
  Sprite? spriteEmpty;
  bool piky = false;


  Platform(this.startPosition, this.initSize) : super(size: Vector2(970, 700));

  @override
  Future<void> onLoad() async {
    spritePike = await Sprite.load('choosegoodside/Platform_pikes.png');
    spriteEmpty = await Sprite.load('choosegoodside/Platform.png');
    sprite = spriteEmpty;
    size = initSize;
    position = startPosition;
  }

  void setPike(bool pike){
    if(pike) sprite = spritePike;
    else sprite = spriteEmpty;
    piky = pike;
  }

  void hide(){
    position.y = 2500;
  }

  bool isPiky(){
    return piky;
  }

  void show(){
    sprite = spriteEmpty;
  }

  bool goUp(length){
    position.y -= length;
    if(position.y < startPosition.y) {
      position.y = startPosition.y;
      return true;
    }
    return false;
  }

}