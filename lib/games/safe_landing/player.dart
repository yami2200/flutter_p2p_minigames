import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../safe_landing/game.dart';
import 'landing_platform.dart';

enum PlayerState { waiting, falling, flying, landed }


class Player extends SpriteComponent
    with HasGameRef<SafeLandingsGame>, CollisionCallbacks {

  Player() : super(size: Vector2(90, 88));

  late PlayerState state = PlayerState.waiting;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    sprite = await Sprite.load('player.png');
    size = Vector2(33, 32)*3;
    position = Vector2(0, 0);

    add(CircleHitbox());
  }

  void startFall() {
    state = PlayerState.falling;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);


    if (other is LandingPlatform) {
      state = PlayerState.landed;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (state != PlayerState.falling && state != PlayerState.flying) {
      return;
    }
    position += Vector2(0, 200 * dt);

  }

}