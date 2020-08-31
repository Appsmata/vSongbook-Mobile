import 'package:vsongbook/models/callbacks/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserResponse.g.dart';

@JsonSerializable()
class UserResponse extends Object with _$UserResponseSerializerMixin {
  String result;
  String message;
  User user;

  UserResponse({this.result, this.message, this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}
