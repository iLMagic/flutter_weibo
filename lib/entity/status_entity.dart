import 'package:json_annotation/json_annotation.dart';
import 'user_entity.dart';

part 'status_entity.g.dart';

@JsonSerializable()
class StatusEntity {
  /// 微博正文
  String text;
  /// 微博id
  int id;
  /// 图片数组
  List<Map<String, dynamic>> pic_urls;
  
  /// 用户信息
  UserEntity user;

  StatusEntity(this.text, this.pic_urls, this.id, this.user);
  factory StatusEntity.fromJson(Map<String, dynamic> json) =>
      _$StatusEntityFromJson(json);
  Map<String, dynamic> toJson() => _$StatusEntityToJson(this);
}
