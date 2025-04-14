import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vms_app/features/auth/data/models/auth_model.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthDatasource {
  factory AuthDatasource(Dio dio, {String baseUrl}) = _AuthDatasource;

  @POST('/auth/token')
  Future<AuthResponse> getTokenAndLogin(
    @Body() Map<String, dynamic> data
  );
}
