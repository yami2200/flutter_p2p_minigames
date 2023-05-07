import 'package:flame/components.dart';

class Platform extends SpriteComponent {

  Vector2 startPosition;
  Vector2 initSize;
  Sprite? spritePike;
  Sprite? spriteEmpty;


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
  }

  void hide(){
    sprite = null;
  }

  void show(){
    sprite = spriteEmpty;
  }

}