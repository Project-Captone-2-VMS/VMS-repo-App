import 'package:vms_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:vms_app/features/auth/data/models/auth_model.dart';

class AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepository(this.authDatasource);

  Future<Result> login(String username, String password) async {
    try {
      final response = await authDatasource.getTokenAndLogin(
        username,
        password,
      );

      if (response.code == 1000) {
        return response.result;
      } else {
        throw ("Error Login with ${response.code}");
      }
    } catch (e) {
      throw ("Error Login with $e");
    }
  }
}
