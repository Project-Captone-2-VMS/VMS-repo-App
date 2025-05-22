import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/features/auth/data/models/auth_model.dart';
import 'package:vms_app/features/auth/data/repositories/auth_repository.dart';

part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepository) : super(const AuthState.initial()) {
    _checkSavedToken(); // Kiểm tra token khi khởi tạo
  }

  static final log = Logger('AuthCubit');
  final AuthRepository authRepository;

  // Kiểm tra token đã lưu khi khởi tạo
  Future<void> _checkSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (token != null && rememberMe) {
      await getRefresh({'token': token});
    }
  }

  Future<void> signin(Map<String, dynamic> data) async {
    emit(const AuthState.loading());
    try {
      final loginRepos = await authRepository.login(data);
      // Lưu token khi đăng nhập thành công
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginRepos.token);
      emit(AuthState.success(loginSuccess: loginRepos));
    } catch (e) {
      log.severe('Error while trying to sign in', e);
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> signup(Map<String, dynamic> data) async {
    emit(const AuthState.loading());
    try {
      final signUpRepo = await authRepository.signUp(data);
      emit(AuthState.successSignUp(success: signUpRepo));
    } catch (e) {
      log.severe('Error while trying to sign up', e);
      emit(AuthState.error(message: e.toString()));
    }
  }

  Future<void> getRefresh(Map<String, dynamic> data) async {
    emit(const AuthState.loading());
    try {
      final newToken = await authRepository.GetRefreshToken(data);
      // Lưu token mới
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', newToken);
      // Emit AuthState.success để tái sử dụng logic trong SignInScreen
      emit(
        AuthState.success(
          loginSuccess: Result(
            token: newToken,
            authenticated: true,
            roles: ['user'],
          ),
        ),
      );
    } catch (e) {
      log.severe('Error while trying to refresh token', e);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('rememberMe');
      emit(AuthState.error(message: 'Failed to refresh token: $e'));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('token');
    await prefs.remove('rememberMe');
    emit(const AuthState.initial());
  }
}

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.success({required Result loginSuccess}) =
      AuthStateSuccess;
  const factory AuthState.successSignUp({required String success}) =
      AuthStateSuccessSignUp;
  const factory AuthState.error({required String message}) = AuthStateError;
}
