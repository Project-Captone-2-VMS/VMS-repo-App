import '../data_sources/profile_data_source.dart';

class ProfileRepositories {
  final ProfileDataSource profileDataSource;

  ProfileRepositories(this.profileDataSource);

  Future<dynamic> getDriverById(String driverId, String token) async {
    try {
      final response = await profileDataSource.getDriverById(
        driverId,
        'Bearer $token',
      );

      if (response.response.statusCode == 200) {
        return response.response.data;
      } else {
        throw Exception(
          "Error response API get Driver By DriverId: ${response.response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error response API get Driver By DriverId: $e");
    }
  }

  Future<String> updateDriver(
    String driverId,
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final response = await profileDataSource.updateDriverById(
        driverId,
        data,
        'Bearer $token',
      );

      if (response.response.statusCode == 200) {
        return "Update Success";
      } else {
        throw Exception(
          "Error response API update Driver By DriverId :${response.response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error response API update Driver By DriverId :$e");
    }
  }
}
