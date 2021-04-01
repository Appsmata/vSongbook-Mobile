import 'User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserRequest.g.dart';

@JsonSerializable()
class UserRequest extends Object with _$UserRequestSerializerMixin {
  User user;

  UserRequest({this.user});

  factory UserRequest.fromJson(Map<String, dynamic> json) => _$UserRequestFromJson(json);
}
