part of 'UserRequest.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

UserRequest _$UserRequestFromJson(Map<String, dynamic> json) => UserRequest(
    user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>));

abstract class _$UserRequestSerializerMixin {
  User get user;
  Map<String, dynamic> toJson() => <String, dynamic>{'user': user};
}
