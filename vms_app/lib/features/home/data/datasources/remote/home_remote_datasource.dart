import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vms_app/features/home/data/models/home_model.dart';

part 'home_remote_datasource.g.dart';

@RestApi()
abstract class HomeDatasource {
  factory HomeDatasource(Dio dio, {String baseUrl}) = _HomeDatasource;

  @GET('/user/myInfo')
  Future<HomeResponse> getInformation(@Header('Authorization') String bearerToken);

}
