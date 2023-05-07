import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/choose_good_side_instance.dart';

class Cloud extends SpriteComponent with HasGameRef<ChooseGoodSideGameInstance> {

  Vector2 startPosition;
  Sprite spriteCloud;

  Cloud(this.startPosition, this.spriteCloud) : super(size: Vector2(95, 55));

  @override
  Future<void> onLoad() async {
    sprite = spriteCloud;
    size = Vector2(95, 55);
    position = startPosition;
    anchor = Anchor.center;
  }

  void downPosition(double length){
    position.y -= length;
    if(position.y < -30) {
      position.y = gameRef.size.y+30;
    }
  }

}