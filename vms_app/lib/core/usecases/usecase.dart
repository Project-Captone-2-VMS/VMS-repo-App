import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base usecase interface
/// [Type] is the return type of the usecase
/// [Params] is the parameters required by the usecase
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters class for usecases that don't require parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
