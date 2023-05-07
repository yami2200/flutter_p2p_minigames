import 'dart:convert';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter_p2p_minigames/network/EventData.dart';
import 'package:flutter_p2p_minigames/network/EventType.dart';
import 'package:flutter_p2p_minigames/utils/GameParty.dart';

enum PlayerState { waiting, goingRight, goingLeft, falling }

class Player extends SpriteComponent{
  PlayerState state = PlayerState.waiting;

  Vector2 velocity = Vector2.zero();
  static const double gravity = 500.0;
  String avatar = 'player.png';
  Vector2 startPosition;
  final double timeToMove = 0.4;
  final int heightToJump = 300;
  Vector2 force = Vector2.zero();
  bool onLeft = true;
  double angleForce = 0;
  final bool mainCharacter;
  final bool training;

  @override
  final images = Images(prefix: 'assets/avatars/');

  Player({
    required this.avatar,
    required this.startPosition,
    required this.mainCharacter,
    required this.training,
  }) : super(size: Vector2(90, 88));

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(avatar, images: images);
    size = Vector2(33, 33) * 3;
    position = startPosition;
    anchor = Anchor.center;
  }

  void switchSide(bool left){
    if(state==PlayerState.falling) return;
    if(state == PlayerState.waiting && left != onLeft){
      state = left ? PlayerState.goingLeft : PlayerState.goingRight;
      force = Vector2(0, (heightToJump/(timeToMove))*5.2);
      velocity = left ? Vector2(-280/timeToMove, -heightToJump/timeToMove) : Vector2(280/timeToMove, -heightToJump/timeToMove);
      onLeft = left;
      angleForce = left ? -6.28319/timeToMove : 6.28319/timeToMove;
      if(mainCharacter && !training){
        GameParty().connection!.sendMessageToClient(jsonEncode(EventData(EventType.SWAP_SIDE.text, left?"left":"right")));
        GameParty().connection!.sendMessageToServer(jsonEncode(EventData(EventType.SWAP_SIDE.text, left?"left":"right")));
      }
    }
  }

  void forceSwitch(bool left){
    if(state==PlayerState.falling) return;
    if(state == PlayerState.goingLeft){
      position.x = startPosition.x;
      position.y = startPosition.y;
    } else if(state == PlayerState.goingRight){
      position.x = startPosition.x + 280;
      position.y = startPosition.y;
    }
    state = PlayerState.waiting;
    switchSide(left);
  }

  bool isDead(pikeOnLeft){
    return (onLeft && pikeOnLeft) || (!onLeft && !pikeOnLeft);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(state != PlayerState.waiting){
      position += velocity * dt;
      velocity += force * dt;
      angle += angleForce * dt;
      if(position.y > startPosition.y){
        position.y = startPosition.y;
        if(onLeft) position.x = startPosition.x;
        else position.x = startPosition.x + 280;
        velocity = Vector2.zero();
        state = PlayerState.waiting;
        angle = 0;
      }
    }
  }

}