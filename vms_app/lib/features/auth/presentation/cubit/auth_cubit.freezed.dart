// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// @nodoc


class AuthStateLoading implements AuthState {
  const AuthStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class AuthStateSuccess implements AuthState {
  const AuthStateSuccess({required this.loginSuccess});
  

 final  Result loginSuccess;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateSuccessCopyWith<AuthStateSuccess> get copyWith => _$AuthStateSuccessCopyWithImpl<AuthStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateSuccess&&(identical(other.loginSuccess, loginSuccess) || other.loginSuccess == loginSuccess));
}


@override
int get hashCode => Object.hash(runtimeType,loginSuccess);

@override
String toString() {
  return 'AuthState.success(loginSuccess: $loginSuccess)';
}


}

/// @nodoc
abstract mixin class $AuthStateSuccessCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthStateSuccessCopyWith(AuthStateSuccess value, $Res Function(AuthStateSuccess) _then) = _$AuthStateSuccessCopyWithImpl;
@useResult
$Res call({
 Result loginSuccess
});




}
/// @nodoc
class _$AuthStateSuccessCopyWithImpl<$Res>
    implements $AuthStateSuccessCopyWith<$Res> {
  _$AuthStateSuccessCopyWithImpl(this._self, this._then);

  final AuthStateSuccess _self;
  final $Res Function(AuthStateSuccess) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? loginSuccess = null,}) {
  return _then(AuthStateSuccess(
loginSuccess: null == loginSuccess ? _self.loginSuccess : loginSuccess // ignore: cast_nullable_to_non_nullable
as Result,
  ));
}


}

/// @nodoc


class AuthStateError implements AuthState {
  const AuthStateError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStateError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.error()';
}


}




// dart format on
