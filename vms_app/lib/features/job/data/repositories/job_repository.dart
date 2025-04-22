import 'package:vms_app/features/job/data/datasources/remote/job_remote_datasource.dart';
import 'package:vms_app/features/job/data/models/job_model.dart';

class JobRepository {
  final JobDatasource jobDatasource;

  JobRepository(this.jobDatasource);

  Future<List<Route>> getRouteByUserName(String username, String token) async {
    try {
      final response = await jobDatasource.getAllRoute(
        username,
        'Bearer $token',
      );
      if (response.response.statusCode == 200) {
        final List<dynamic> rawData = response.response.data;
        final List<Route> routeList =
            rawData
                .map((item) => Route.fromJson(item as Map<String, dynamic>))
                .toList();
        return routeList;
      } else {
        throw Exception(
          "Error response API get all route: ${response.response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error getting all routes: $e");
    }
  }

  Future<Route> getRouteByRouteId(int routeId, String token) async {
    try {
      final response = await jobDatasource.getRoute(routeId, 'Bearer $token');

      return response;
    } catch (e) {
      throw ("Error get route $e");
    }
  }

  Future<void> updateTimeEstimate(
    int interId,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final response = await jobDatasource.updateTimeEstimate(
        interId,
        data,
        'Bearer $token',
      );

      if (response.response.statusCode == 200) {
        return response.response.data;
      }
    } catch (e) {
      throw ("Error get route $e");
    }
  }
}
