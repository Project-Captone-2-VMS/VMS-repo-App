import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthResponse {
  final int code;
  final Result result;

  AuthResponse({required this.code, required this.result});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class Result {
  final String token;
  final bool authenticated;
  @JsonKey(name: 'roles')
  final List<String> roles;

  Result({
    required this.token,
    required this.authenticated,
    required this.roles,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}
