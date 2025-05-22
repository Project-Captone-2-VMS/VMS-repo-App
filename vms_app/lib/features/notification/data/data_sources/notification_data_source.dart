import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vms_app/features/notification/notification.dart';

part 'notification_data_source.g.dart';

@RestApi()
abstract class NotificationDataSource {
  factory NotificationDataSource(Dio dio, {String baseUrl}) = _NotificationDataSource;

  @GET('/notifications/{username}')
  Future<List<NotificationUserResponse>>  getDriverById(
    @Path('username') String username,
    @Header('Authorization') String bearerToken,
  );

}
