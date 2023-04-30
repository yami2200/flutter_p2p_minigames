import 'package:json_annotation/json_annotation.dart';

part 'PlayerInfo.g.dart';

@JsonSerializable()
class PlayerInfo {
  String username;
  String tag;
  String avatar;

  PlayerInfo(this.username, this.tag, this.avatar);

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => _$PlayerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}