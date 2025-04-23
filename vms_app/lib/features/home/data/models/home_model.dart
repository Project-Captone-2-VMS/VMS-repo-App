import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeResponse {
  final int code;
  final Result result;

  HomeResponse({required this.code, required this.result});

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}

@JsonSerializable()
class Result {
  final String id;
  final String username;
  final String password;
  final String? dob;
  final List<Role> roles;
  final String firstName;
  final String lastName;

  Result({
    required this.id,
    required this.username,
    required this.password,
    this.dob,
    required this.roles,
    required this.firstName,
    required this.lastName,
    
  });

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Role {
  final String name;
  final String description;
  final List<dynamic> permissions;

  Role({
    required this.name,
    required this.description,
    required this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
