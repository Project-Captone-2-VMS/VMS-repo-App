// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobState()';
}


}

/// @nodoc
class $JobStateCopyWith<$Res>  {
$JobStateCopyWith(JobState _, $Res Function(JobState) __);
}


/// @nodoc


class JobStateInitial implements JobState {
  const JobStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobState.initial()';
}


}




/// @nodoc


class JobStateLoading implements JobState {
  const JobStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JobState.loading()';
}


}




/// @nodoc


class JobStateSuccess implements JobState {
  const JobStateSuccess({required final  List<Route> success}): _success = success;
  

 final  List<Route> _success;
 List<Route> get success {
  if (_success is EqualUnmodifiableListView) return _success;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_success);
}


/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobStateSuccessCopyWith<JobStateSuccess> get copyWith => _$JobStateSuccessCopyWithImpl<JobStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobStateSuccess&&const DeepCollectionEquality().equals(other._success, _success));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_success));

@override
String toString() {
  return 'JobState.success(success: $success)';
}


}

/// @nodoc
abstract mixin class $JobStateSuccessCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory $JobStateSuccessCopyWith(JobStateSuccess value, $Res Function(JobStateSuccess) _then) = _$JobStateSuccessCopyWithImpl;
@useResult
$Res call({
 List<Route> success
});




}
/// @nodoc
class _$JobStateSuccessCopyWithImpl<$Res>
    implements $JobStateSuccessCopyWith<$Res> {
  _$JobStateSuccessCopyWithImpl(this._self, this._then);

  final JobStateSuccess _self;
  final $Res Function(JobStateSuccess) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? success = null,}) {
  return _then(JobStateSuccess(
success: null == success ? _self._success : success // ignore: cast_nullable_to_non_nullable
as List<Route>,
  ));
}


}

/// @nodoc


class JobStateSuccessRoute implements JobState {
  const JobStateSuccessRoute({required this.success});
  

 final  Route success;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobStateSuccessRouteCopyWith<JobStateSuccessRoute> get copyWith => _$JobStateSuccessRouteCopyWithImpl<JobStateSuccessRoute>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobStateSuccessRoute&&(identical(other.success, success) || other.success == success));
}


@override
int get hashCode => Object.hash(runtimeType,success);

@override
String toString() {
  return 'JobState.successRoute(success: $success)';
}


}

/// @nodoc
abstract mixin class $JobStateSuccessRouteCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory $JobStateSuccessRouteCopyWith(JobStateSuccessRoute value, $Res Function(JobStateSuccessRoute) _then) = _$JobStateSuccessRouteCopyWithImpl;
@useResult
$Res call({
 Route success
});




}
/// @nodoc
class _$JobStateSuccessRouteCopyWithImpl<$Res>
    implements $JobStateSuccessRouteCopyWith<$Res> {
  _$JobStateSuccessRouteCopyWithImpl(this._self, this._then);

  final JobStateSuccessRoute _self;
  final $Res Function(JobStateSuccessRoute) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? success = null,}) {
  return _then(JobStateSuccessRoute(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as Route,
  ));
}


}

/// @nodoc


class JobStateError implements JobState {
  const JobStateError({required this.message});
  

 final  String message;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobStateErrorCopyWith<JobStateError> get copyWith => _$JobStateErrorCopyWithImpl<JobStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JobState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $JobStateErrorCopyWith<$Res> implements $JobStateCopyWith<$Res> {
  factory $JobStateErrorCopyWith(JobStateError value, $Res Function(JobStateError) _then) = _$JobStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$JobStateErrorCopyWithImpl<$Res>
    implements $JobStateErrorCopyWith<$Res> {
  _$JobStateErrorCopyWithImpl(this._self, this._then);

  final JobStateError _self;
  final $Res Function(JobStateError) _then;

/// Create a copy of JobState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(JobStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
