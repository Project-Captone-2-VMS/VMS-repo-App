// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// @nodoc


class HomeStateInitial implements HomeState {
  const HomeStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.initial()';
}


}




/// @nodoc


class HomeStateLoading implements HomeState {
  const HomeStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.loading()';
}


}




/// @nodoc


class HomeStateSuccess implements HomeState {
  const HomeStateSuccess({required this.success});
  

 final  Result success;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateSuccessCopyWith<HomeStateSuccess> get copyWith => _$HomeStateSuccessCopyWithImpl<HomeStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStateSuccess&&(identical(other.success, success) || other.success == success));
}


@override
int get hashCode => Object.hash(runtimeType,success);

@override
String toString() {
  return 'HomeState.success(success: $success)';
}


}

/// @nodoc
abstract mixin class $HomeStateSuccessCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeStateSuccessCopyWith(HomeStateSuccess value, $Res Function(HomeStateSuccess) _then) = _$HomeStateSuccessCopyWithImpl;
@useResult
$Res call({
 Result success
});




}
/// @nodoc
class _$HomeStateSuccessCopyWithImpl<$Res>
    implements $HomeStateSuccessCopyWith<$Res> {
  _$HomeStateSuccessCopyWithImpl(this._self, this._then);

  final HomeStateSuccess _self;
  final $Res Function(HomeStateSuccess) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? success = null,}) {
  return _then(HomeStateSuccess(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as Result,
  ));
}


}

/// @nodoc


class HomeStateError implements HomeState {
  const HomeStateError({required this.message});
  

 final  String message;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateErrorCopyWith<HomeStateError> get copyWith => _$HomeStateErrorCopyWithImpl<HomeStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'HomeState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $HomeStateErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeStateErrorCopyWith(HomeStateError value, $Res Function(HomeStateError) _then) = _$HomeStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$HomeStateErrorCopyWithImpl<$Res>
    implements $HomeStateErrorCopyWith<$Res> {
  _$HomeStateErrorCopyWithImpl(this._self, this._then);

  final HomeStateError _self;
  final $Res Function(HomeStateError) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(HomeStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
