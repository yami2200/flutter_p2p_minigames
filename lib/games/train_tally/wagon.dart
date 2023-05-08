import "dart:math";

import 'dart:developer' as dev;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_p2p_minigames/games/train_tally/passenger.dart';

class Wagon extends SpriteComponent{

  Vector2 startPosition;
  Sprite spriteTrain;
  List<Passenger> passengers = [];
  String schema = "";
  List<Vector2> positionsPassengers = [Vector2(-275, -225), Vector2(-195, -225), Vector2(-15, -235), Vector2(85, -240), Vector2(180, -245)];
  Function? onQuitScreen;
  bool quit = false;
  int nbPassengers = 0;

  Wagon(this.startPosition, this.spriteTrain, {this.onQuitScreen}) : super(size: Vector2(721, 400));

  @override
  Future<void> onLoad() async {
    sprite = spriteTrain;
    size = Vector2(721, 400);
    position = startPosition;
    anchor = Anchor.bottomCenter;
  }

  void move(double speed){
    position.x -= speed;
    passengers.forEach((element) {
      element.move(speed);
    });
    if(!quit && position.x < -721){
      quit = true;
      if(onQuitScreen != null){
        onQuitScreen!();
      }
    }
  }

  void generatePassengers(){
    for(int i = 0; i<5;i++){
      addOnePassenger(Random().nextBool(), i);
    }
  }

  void addOnePassenger(bool isPassenger, int index){
    if(isPassenger){
      passengers.add(Passenger(startPosition+positionsPassengers[index], Random().nextBool() ? Passenger.passenger1! : Passenger.passenger2!));
      schema += "1";
      nbPassengers++;
    } else {
      passengers.add(Passenger(startPosition+positionsPassengers[index], Passenger.nopassenger!));
      schema += "0";
    }
  }

  int getNbPassengers(){
    return nbPassengers;
  }

  List<Passenger> getPassengers(){
    return passengers;
  }

  void addPassengers(String schema){
    for(int i = 0; i<5;i++){
      addOnePassenger(schema[i]=="1", i);
    }
    this.schema = schema;
  }

  String getSchema() {
    return schema;
  }

}