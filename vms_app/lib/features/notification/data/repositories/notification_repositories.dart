import 'package:vms_app/features/notification/notification.dart';

class NotificationRepositories {
  final NotificationDataSource notificationDataSource;
  NotificationRepositories(this.notificationDataSource);

  Future<List<NotificationUserResponse>> getNotify(String username, String token) async {
    try {
      final response = await notificationDataSource.getDriverById(
        username,
        'Bearer $token',
      );
      return response;
    } catch (e) {
      throw Exception('Error call Api for get notify by username: $e');
    }
  }
}
