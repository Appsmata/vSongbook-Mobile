part of 'UserRequest.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

UserRequest _$UserRequestFromJson(Map<String, dynamic> json) => new UserRequest(
    user: json['user'] == null ? null : new User.fromJson(json['user'] as Map<String, dynamic>));

abstract class _$UserRequestSerializerMixin {
  User get user;
  Map<String, dynamic> toJson() => <String, dynamic>{'user': user};
}
