import 'package:json_annotation/json_annotation.dart';

part 'GameInfo.g.dart';

@JsonSerializable()
class GameInfo{
  String name;
  String description;
  String path;

  GameInfo(this.name, this.description, this.path);

  factory GameInfo.fromJson(Map<String, dynamic> json) => _$GameInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GameInfoToJson(this);
}