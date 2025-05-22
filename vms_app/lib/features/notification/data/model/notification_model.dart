import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationUserResponse {
  final int? id;
  final User? user;
  final NotificationModel? notification;

  NotificationUserResponse({
    this.id,
    this.user,
    this.notification,
  });

  factory NotificationUserResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationUserResponseToJson(this);
}

@JsonSerializable()
class User {
  final int? id;
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? email;
  final String? phoneNumber;
  final bool? isDeleted;
  final List<Role>? roles;
  final Driver? driver;

  User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.password,
    this.email,
    this.phoneNumber,
    this.isDeleted,
    this.roles,
    this.driver,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Role {
  final String? name;
  final String? description;
  final List<dynamic>? permissions;

  Role({
    this.name,
    this.description,
    this.permissions,
  });

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable()
class Driver {
  final int? driverId;
  final String? firstName;
  final String? lastName;
  final String? licenseNumber;
  final String? workSchedule;
  final bool? status;
  final String? email;
  final String? phoneNumber;

  Driver({
    this.driverId,
    this.firstName,
    this.lastName,
    this.licenseNumber,
    this.workSchedule,
    this.status,
    this.email,
    this.phoneNumber,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);
  Map<String, dynamic> toJson() => _$DriverToJson(this);
}

enum NotificationType { user, system, alert }

@JsonSerializable()
class NotificationModel {
  final int? notificationId;
  final String? title;
  final String? content;

  @JsonKey(fromJson: _notificationTypeFromJson, toJson: _notificationTypeToJson)
  final NotificationType? type;

  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime? createdAt;

  final bool? read;

  NotificationModel({
    this.notificationId,
    this.title,
    this.content,
    this.type,
    this.createdAt,
    this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  static NotificationType? _notificationTypeFromJson(String? type) {
    switch (type?.toUpperCase()) {
      case 'USER':
        return NotificationType.user;
      case 'SYSTEM':
        return NotificationType.system;
      case 'ALERT':
        return NotificationType.alert;
      default:
        return null;
    }
  }

  static String? _notificationTypeToJson(NotificationType? type) =>
      type?.toString().split('.').last.toUpperCase();

  static DateTime? _dateTimeFromJson(String? date) =>
      date == null ? null : DateTime.tryParse(date);

  static String? _dateTimeToJson(DateTime? date) =>
      date?.toIso8601String();
}
