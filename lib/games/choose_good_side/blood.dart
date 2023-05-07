import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/games/choose_good_side/choose_good_side_instance.dart';

class Blood extends SpriteComponent with HasGameRef<ChooseGoodSideGameInstance> {

  Vector2 startPositionLeft;
  Vector2 startPositionRight;

  Blood(this.startPositionLeft, this.startPositionRight) : super(size: Vector2(95, 55));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('choosegoodside/bloodspash.png');
    size = Vector2(300, 300);
    position = Vector2(0, -200);
    anchor = Anchor.center;
  }

  void show(bool left){
    if(left) position = startPositionLeft;
    else position = startPositionRight;
    Future.delayed(const Duration(milliseconds: 1500), () {
      position = Vector2(0, -200);
    });
  }

}