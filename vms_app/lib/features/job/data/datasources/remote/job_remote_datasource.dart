import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vms_app/features/job/data/models/job_model.dart';

part 'job_remote_datasource.g.dart';

@RestApi()
abstract class JobDatasource {
  factory JobDatasource(Dio dio, {String baseUrl}) = _JobDatasource;

  @GET('/route/allRoute/{username}')
  Future<HttpResponse> getAllRoute(
    @Path('username') String username,
    @Header('Authorization') String bearerToken,
  );

  @GET('/route/{routeId}')
  Future<Route> getRoute(
    @Path('routeId') int routeId,
    @Header('Authorization') String bearerToken,
  );

  @PUT('/interconnections/timeEstimate/{interId}')
  Future<HttpResponse> updateTimeEstimate(
    @Path('interId') int interId,
    @Body() Map<String,dynamic> data,
    @Header('Authorization') String bearerToken,
  );
}
