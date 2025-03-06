import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class SearchService {
  static const String nominatimBaseUrl =
      'https://nominatim.openstreetmap.org/search';

  Future<LatLng?> searchLocation(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$nominatimBaseUrl?q=$query&format=json&addressdetails=1&limit=1',
        ),
        headers: {'User-Agent': 'vms_app/1.0 (your-email@example.com)'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
      return null;
    } catch (e) {
      print('Error searching location: $e');
      return null;
    }
  }

  Future<String?> getAddressFromLatLng(LatLng position) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=${position.latitude}&lon=${position.longitude}&format=json',
        ),
        headers: {'User-Agent': 'vms_app/1.0 (your-email@example.com)'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting address: $e');
      return null;
    }
  }
}
