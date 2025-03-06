import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/utils/map_constants.dart';

class MapService {
  MapController mapController = MapController();
  List<LatLng> routePoints = [initialLocation];

  List<Polyline> getPolylines() {
    return [
      Polyline(points: routePoints, strokeWidth: 4.0, color: Colors.blue),
    ];
  }

  List<Marker> getCurrentPositionMarker() {
    return routePoints.isNotEmpty
        ? [
          Marker(
            point: routePoints.last,
            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        ]
        : [];
  }

  // Tạo vị trí giả ngẫu nhiên
  void simulateMovement() {
    final random = Random();
    final lastPoint = routePoints.last;
    final angle = random.nextDouble() * 2 * pi;
    final newLat = lastPoint.latitude + 0.0001 * cos(angle);
    final newLon = lastPoint.longitude + 0.0001 * sin(angle);
    routePoints.add(LatLng(newLat, newLon));
    if (routePoints.length > 100) {
      routePoints.removeAt(0);
    }
    mapController.move(LatLng(newLat, newLon), mapController.camera.zoom);
  }

  void moveToLocation(LatLng location, {double zoom = 13.0}) {
    mapController.move(location, zoom);
  }

  void resetMap() {
    routePoints = [initialLocation];
    mapController.move(initialLocation, 13.0);
  }
}
