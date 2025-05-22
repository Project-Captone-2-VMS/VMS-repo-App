import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_data_source.g.dart';

@RestApi()
abstract class ProfileDataSource {
  factory ProfileDataSource(Dio dio, {String baseUrl}) = _ProfileDataSource;

  @GET('/driver/userId/{driverId}')
  Future<HttpResponse> getDriverById(
    @Path('driverId') String driverId,
    @Header('Authorization') String bearerToken,
  );

  @PUT('/driver/update/{driverId}')
  Future<HttpResponse> updateDriverById(
    @Path('driverId') String driverId,
    @Body() Map<String, dynamic> data,
    @Header('Authorization') String bearerToken,
  );
}
