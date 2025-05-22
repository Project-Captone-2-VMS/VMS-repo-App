// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState()';
}


}

/// @nodoc
class $NotificationStateCopyWith<$Res>  {
$NotificationStateCopyWith(NotificationState _, $Res Function(NotificationState) __);
}


/// @nodoc


class NotificationStateInitial implements NotificationState {
  const NotificationStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.initial()';
}


}




/// @nodoc


class NotificationStateLoading implements NotificationState {
  const NotificationStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.loading()';
}


}




/// @nodoc


class NotificationStateSuccess implements NotificationState {
  const NotificationStateSuccess({required final  List<NotificationUserResponse> success}): _success = success;
  

 final  List<NotificationUserResponse> _success;
 List<NotificationUserResponse> get success {
  if (_success is EqualUnmodifiableListView) return _success;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_success);
}


/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationStateSuccessCopyWith<NotificationStateSuccess> get copyWith => _$NotificationStateSuccessCopyWithImpl<NotificationStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationStateSuccess&&const DeepCollectionEquality().equals(other._success, _success));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_success));

@override
String toString() {
  return 'NotificationState.success(success: $success)';
}


}

/// @nodoc
abstract mixin class $NotificationStateSuccessCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory $NotificationStateSuccessCopyWith(NotificationStateSuccess value, $Res Function(NotificationStateSuccess) _then) = _$NotificationStateSuccessCopyWithImpl;
@useResult
$Res call({
 List<NotificationUserResponse> success
});




}
/// @nodoc
class _$NotificationStateSuccessCopyWithImpl<$Res>
    implements $NotificationStateSuccessCopyWith<$Res> {
  _$NotificationStateSuccessCopyWithImpl(this._self, this._then);

  final NotificationStateSuccess _self;
  final $Res Function(NotificationStateSuccess) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? success = null,}) {
  return _then(NotificationStateSuccess(
success: null == success ? _self._success : success // ignore: cast_nullable_to_non_nullable
as List<NotificationUserResponse>,
  ));
}


}

/// @nodoc


class NotificationStateError implements NotificationState {
  const NotificationStateError({required this.message});
  

 final  String message;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationStateErrorCopyWith<NotificationStateError> get copyWith => _$NotificationStateErrorCopyWithImpl<NotificationStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NotificationStateErrorCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory $NotificationStateErrorCopyWith(NotificationStateError value, $Res Function(NotificationStateError) _then) = _$NotificationStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NotificationStateErrorCopyWithImpl<$Res>
    implements $NotificationStateErrorCopyWith<$Res> {
  _$NotificationStateErrorCopyWithImpl(this._self, this._then);

  final NotificationStateError _self;
  final $Res Function(NotificationStateError) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NotificationStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
