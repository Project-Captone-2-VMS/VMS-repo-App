import 'package:equatable/equatable.dart';

/// Base failure class for the application
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure({required String message}) : super(message: message);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({required String message}) : super(message: message);
}
