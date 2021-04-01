// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserResponse.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
    result: json['result'] as String,
    message: json['message'] as String,
    user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>));

abstract class _$UserResponseSerializerMixin {
  String get result;

  String get message;

  User get user;

  Map<String, dynamic> toJson() => <String, dynamic>{'result': result, 'message': message, 'user': user};
}
