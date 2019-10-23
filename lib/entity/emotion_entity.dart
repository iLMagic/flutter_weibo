import 'package:json_annotation/json_annotation.dart';

part 'emotion_entity.g.dart';

@JsonSerializable()

class EmotionEntity {
  String phrase;
  String url;
  // String icon;

  EmotionEntity(this.phrase, this.url);
  factory EmotionEntity.fromJson(Map<String, dynamic> json) => _$EmotionEntityFromJson(json);
  Map<String, dynamic> toJson() => _$EmotionEntityToJson(this);
}
