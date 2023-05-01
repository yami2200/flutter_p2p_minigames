import 'package:json_annotation/json_annotation.dart';

import 'EventType.dart';
part 'EventData.g.dart';

@JsonSerializable()
class EventData {
  String type;
  String data;

  EventData(this.type, this.data);

  factory EventData.fromJson(Map<String, dynamic> json) => _$EventDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}