class RouteLocationModel {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final List<Waypoint> waypoints;

  RouteLocationModel({
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    this.waypoints = const [],
  });
}

class Waypoint {
  final double lat;
  final double lng;
  final String name;

  Waypoint({required this.lat, required this.lng, required this.name});
}
