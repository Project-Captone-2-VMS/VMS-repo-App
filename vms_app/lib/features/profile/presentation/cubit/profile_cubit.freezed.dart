// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState()';
}


}

/// @nodoc
class $ProfileStateCopyWith<$Res>  {
$ProfileStateCopyWith(ProfileState _, $Res Function(ProfileState) __);
}


/// @nodoc


class ProfileStateInitial implements ProfileState {
  const ProfileStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.initial()';
}


}




/// @nodoc


class ProfileStateLoading implements ProfileState {
  const ProfileStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileState.loading()';
}


}




/// @nodoc


class ProfileStateSuccess implements ProfileState {
  const ProfileStateSuccess({required this.data});
  

 final  dynamic data;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateSuccessCopyWith<ProfileStateSuccess> get copyWith => _$ProfileStateSuccessCopyWithImpl<ProfileStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileStateSuccess&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ProfileState.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $ProfileStateSuccessCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileStateSuccessCopyWith(ProfileStateSuccess value, $Res Function(ProfileStateSuccess) _then) = _$ProfileStateSuccessCopyWithImpl;
@useResult
$Res call({
 dynamic data
});




}
/// @nodoc
class _$ProfileStateSuccessCopyWithImpl<$Res>
    implements $ProfileStateSuccessCopyWith<$Res> {
  _$ProfileStateSuccessCopyWithImpl(this._self, this._then);

  final ProfileStateSuccess _self;
  final $Res Function(ProfileStateSuccess) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(ProfileStateSuccess(
data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

/// @nodoc


class ProfileStateError implements ProfileState {
  const ProfileStateError({required this.message});
  

 final  String message;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateErrorCopyWith<ProfileStateError> get copyWith => _$ProfileStateErrorCopyWithImpl<ProfileStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProfileState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProfileStateErrorCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $ProfileStateErrorCopyWith(ProfileStateError value, $Res Function(ProfileStateError) _then) = _$ProfileStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProfileStateErrorCopyWithImpl<$Res>
    implements $ProfileStateErrorCopyWith<$Res> {
  _$ProfileStateErrorCopyWithImpl(this._self, this._then);

  final ProfileStateError _self;
  final $Res Function(ProfileStateError) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProfileStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
