// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionEntity _$EmotionEntityFromJson(Map<String, dynamic> json) {
  return EmotionEntity(
    json['phrase'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$EmotionEntityToJson(EmotionEntity instance) =>
    <String, dynamic>{
      'phrase': instance.phrase,
      'url': instance.url,
    };
