import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
    
  /// 用户昵称
  String screen_name;

  /// 用户头像地址（中图），50×50像素
  String profile_image_url;


  UserEntity(this.screen_name, this.profile_image_url,);
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
