// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationUserResponse _$NotificationUserResponseFromJson(
  Map<String, dynamic> json,
) => NotificationUserResponse(
  id: (json['id'] as num?)?.toInt(),
  user:
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
  notification:
      json['notification'] == null
          ? null
          : NotificationModel.fromJson(
            json['notification'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$NotificationUserResponseToJson(
  NotificationUserResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'user': instance.user,
  'notification': instance.notification,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  username: json['username'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  password: json['password'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
  driver:
      json['driver'] == null
          ? null
          : Driver.fromJson(json['driver'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'password': instance.password,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'isDeleted': instance.isDeleted,
  'roles': instance.roles,
  'driver': instance.driver,
};

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  name: json['name'] as String?,
  description: json['description'] as String?,
  permissions: json['permissions'] as List<dynamic>?,
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'permissions': instance.permissions,
};

Driver _$DriverFromJson(Map<String, dynamic> json) => Driver(
  driverId: (json['driverId'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  licenseNumber: json['licenseNumber'] as String?,
  workSchedule: json['workSchedule'] as String?,
  status: json['status'] as bool?,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$DriverToJson(Driver instance) => <String, dynamic>{
  'driverId': instance.driverId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'licenseNumber': instance.licenseNumber,
  'workSchedule': instance.workSchedule,
  'status': instance.status,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
};

NotificationModel _$NotificationModelFromJson(
  Map<String, dynamic> json,
) => NotificationModel(
  notificationId: (json['notificationId'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  type: NotificationModel._notificationTypeFromJson(json['type'] as String?),
  createdAt: NotificationModel._dateTimeFromJson(json['createdAt'] as String?),
  read: json['read'] as bool?,
);

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'notificationId': instance.notificationId,
      'title': instance.title,
      'content': instance.content,
      'type': NotificationModel._notificationTypeToJson(instance.type),
      'createdAt': NotificationModel._dateTimeToJson(instance.createdAt),
      'read': instance.read,
    };
