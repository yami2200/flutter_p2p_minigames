import 'dart:developer';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class FaceWheelComp extends SpriteComponent with HasGameRef<FlameGame>{

  double deltaCounter = 0.0;
  double currentMaxDelta = 0.1;
  int indexAsset = 0;
  final WheelStep step;
  final Vector2 startPosition;
  final Vector2 initSize;
  String faceID = "";
  bool running = false;

  FaceWheelComp(this.step, this.startPosition, this.initSize) : super(size: Vector2(330, 330));

  @override
  Future<void> onLoad() async {
    sprite = step.getAsset(indexAsset);
    size = initSize;
    position = startPosition; //Vector2(gameRef.size.x / 2 - size.x / 2, 190)
  }

  void start(){
    running = true;
  }

  int stop(){
    running = false;
    return indexAsset;
  }

  void select(int index){
    indexAsset = index;
    changeFace();
    running = false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if(!running){
      return;
    }
    deltaCounter += dt;
    if(deltaCounter > step.getDeltaSpeed()){
      deltaCounter = 0.0;
      indexAsset++;
      if(indexAsset >= step.getMaxIndex()){
        indexAsset = 0;
      }
      changeFace();
    }
  }

  void changeFace() async {
    sprite = step.getAsset(indexAsset);
  }

}

class WheelStep {
  final double deltaSpeed;
  List<Sprite> assets;
  final int maxIndex;

  WheelStep._(this.deltaSpeed, this.assets, this.maxIndex);

  static Future<WheelStep> create(double deltaSpeed, String assetPath, int maxIndex) async {
    List<Sprite> assets = await _loadAssets(assetPath, maxIndex);
    return WheelStep._(deltaSpeed, assets, maxIndex);
  }

  static Future<List<Sprite>> _loadAssets(String path, int maxIndex) async {
    List<Sprite> assets = [];
    for (int i = 1; i <= maxIndex; i++) {
      assets.add(await Sprite.load('${path}$i.png'));
    }
    return assets;
  }

  void loadAssets(String path) async{
    for(int i = 1; i <= maxIndex; i++){
      assets.add(await Sprite.load('${path}$i.png'));
    }
  }

  Sprite getAsset(int index){
    return assets[index];
  }

  int getMaxIndex(){
    return maxIndex;
  }

  double getDeltaSpeed(){
    return deltaSpeed;
  }

}