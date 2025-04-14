import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:vms_app/features/auth/data/models/auth_model.dart';
import 'package:vms_app/features/auth/data/repositories/auth_repository.dart';

part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepository) : super(const AuthState.initial());

  static final log = Logger('AuthCubit');

  final AuthRepository authRepository;

  Future<void> signin(Map<String, dynamic> data) async {
    emit(const AuthState.loading());
    try {
      final loginRepos = await authRepository.login(data);
      emit(AuthState.success(loginSuccess: loginRepos));
    } catch (error) {
      log.severe('Error while trying to load AuthCubit', error);
      emit(const AuthState.error());
    }
  }
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;

  const factory AuthState.loading() = AuthStateLoading;

  const factory AuthState.success({required Result loginSuccess}) =
      AuthStateSuccess;

  const factory AuthState.error() = AuthStateError;
}
