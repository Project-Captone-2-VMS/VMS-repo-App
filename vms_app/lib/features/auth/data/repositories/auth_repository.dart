import 'package:vms_app/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:vms_app/features/auth/data/models/auth_model.dart';

class AuthRepository {
  final AuthDatasource authDatasource;

  AuthRepository(this.authDatasource);

  Future<Result> login(Map<String, dynamic> data) async {
    try {
      final response = await authDatasource.getTokenAndLogin(data);

      if (response.code == 1000) {
        return response.result;
      } else {
        throw ("Error Login with ${response.code}");
      }
    } catch (e) {
      throw ("Error Login with $e");
    }
  }

  Future<String> signUp(Map<String, dynamic> data) async {
    try {
      final response = await authDatasource.createAccount(data);

      if (response.response.statusCode == 200) {
        return 'SignUp Success';
      } else {
        throw ("Error Signup with ${response.response.statusCode}");
      }
    } catch (e) {
      throw ("Error SignUp with $e");
    }
  }
}
