// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusEntity _$StatusEntityFromJson(Map<String, dynamic> json) {
  return StatusEntity(
    json['text'] as String,
    (json['pic_urls'] as List)?.map((e) => e as Map<String, dynamic>)?.toList(),
    json['id'] as int,
    json['user'] == null
        ? null
        : UserEntity.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StatusEntityToJson(StatusEntity instance) =>
    <String, dynamic>{
      'text': instance.text,
      'id': instance.id,
      'pic_urls': instance.pic_urls,
      'user': instance.user,
    };
