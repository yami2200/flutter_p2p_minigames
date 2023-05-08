import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/games/arrow_swiping/arrow.dart';


class BlackBox extends SpriteComponent with CollisionCallbacks {
  @override
  final images = Images(prefix: 'assets/images/arrow_swiping/');

  late RectangleComponent overlay;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('black_box.png', images: images);
    add(RectangleHitbox(isSolid: true));

    add(overlay = RectangleComponent(size: size, anchor: Anchor.topLeft, paint: Paint()..color = const Color(0x514ED724)));

    overlay.opacity = 0;
  }

  Function onArrowCollision = (Arrow arrow) {};
  Function onArrowCollisionEnd = (Arrow arrow) {};

  double overlayTimer = 0;


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Arrow) {
      onArrowCollision(other);
      return;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (overlayTimer > 0) {
      overlayTimer -= dt;
      if (overlayTimer <= 0) {
        overlay.opacity = 0;
      }
    }

  }

  @override
  void showOverlay() {
    overlay.opacity = 0.40;
    overlayTimer = 0.5;
  }



  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is Arrow) {
      onArrowCollisionEnd(other);
      return;
    }

  }


  BlackBox({required Vector2 position, required this.onArrowCollision, required this.onArrowCollisionEnd}) : super(size: Vector2.all(200), position: position) {
    anchor = Anchor.center;
  }

}