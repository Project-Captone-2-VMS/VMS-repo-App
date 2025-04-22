// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
  code: (json['code'] as num).toInt(),
  result: Result.fromJson(json['result'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{'code': instance.code, 'result': instance.result};

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
  id: json['id'] as String,
  username: json['username'] as String,
  password: json['password'] as String,
  dob: json['dob'] as String?,
  roles:
      (json['roles'] as List<dynamic>)
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
);

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'password': instance.password,
  'dob': instance.dob,
  'roles': instance.roles,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
};

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  name: json['name'] as String,
  description: json['description'] as String,
  permissions: json['permissions'] as List<dynamic>,
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'permissions': instance.permissions,
};
