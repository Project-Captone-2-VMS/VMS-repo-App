// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  code: (json['code'] as num).toInt(),
  result: Result.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{'code': instance.code, 'result': instance.result};

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
  token: json['token'] as String,
  authenticated: json['authenticated'] as bool,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
  'token': instance.token,
  'authenticated': instance.authenticated,
  'roles': instance.roles,
};
