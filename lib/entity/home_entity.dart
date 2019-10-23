import 'package:flutter_weibo/entity/status_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_entity.g.dart';

@JsonSerializable()

class HomeEntity {
  List<StatusEntity> statuses;
  int total_number;
  int max_id;
  HomeEntity(this.statuses, this.total_number, this.max_id);
  factory HomeEntity.fromJson(Map<String, dynamic> json) => _$HomeEntityFromJson(json);
  Map<String, dynamic> toJson() => _$HomeEntityToJson(this);
}
