import 'package:vms_app/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:vms_app/features/home/data/models/home_model.dart';

class HomeRepository {
  final HomeDatasource homeDatasource;

  HomeRepository(this.homeDatasource);

  Future<Result> getInformation(String bearerToken) async {
    try {
      final response = await homeDatasource.getInformation(
        'Bearer $bearerToken',
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
