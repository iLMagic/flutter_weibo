// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeEntity _$HomeEntityFromJson(Map<String, dynamic> json) {
  return HomeEntity(
    (json['statuses'] as List)
        ?.map((e) =>
            e == null ? null : StatusEntity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['total_number'] as int,
    json['max_id'] as int,
  );
}

Map<String, dynamic> _$HomeEntityToJson(HomeEntity instance) =>
    <String, dynamic>{
      'statuses': instance.statuses,
      'total_number': instance.total_number,
      'max_id': instance.max_id,
    };
