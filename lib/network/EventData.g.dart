// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EventData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventData _$EventDataFromJson(Map<String, dynamic> json) => EventData(
      $enumDecode(_$EventTypeEnumMap, json['type']),
      json['data'] as String,
    );

Map<String, dynamic> _$EventDataToJson(EventData instance) => <String, dynamic>{
      'type': _$EventTypeEnumMap[instance.type]!,
      'data': instance.data,
    };

const _$EventTypeEnumMap = {
  EventType.PLAYER_JOINED: 'PLAYER_JOINED',
};
