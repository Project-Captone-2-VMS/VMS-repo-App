import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OSMMap extends StatefulWidget {
  @override
  _OSMMapState createState() => _OSMMapState();
}

class _OSMMapState extends State<OSMMap> with TickerProviderStateMixin {
  final LatLng start = LatLng(10.7769, 106.6823);
  final LatLng end = LatLng(10.7753, 106.7009);
  late final AnimatedMapController _animatedMapController;
  late Future<Map<String, dynamic>> _routeFuture;

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this);
    _routeFuture = _fetchRoute();
  }

  /// Fetch route from OSRM API
  Future<Map<String, dynamic>> _fetchRoute() async {
    final url =
        "https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List coordinates = data['routes'][0]['geometry']['coordinates'];
        final double distance = data['routes'][0]['distance'] / 1000;

        return {
          'routePoints':
              coordinates
                  .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                  .toList(),
          'distance': distance,
        };
      } else {
        throw Exception("Failed to fetch route");
      }
    } catch (e) {
      print("Error fetching route: $e");
      return {'routePoints': [], 'distance': 0.0};
    }
  }

  void _moveTo(LatLng point) {
    _animatedMapController.animateTo(dest: point, zoom: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OSM Routing with Effects")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _routeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading route"));
          }

          final List<LatLng> routePoints = snapshot.data?['routePoints'] ?? [];
          final double distance = snapshot.data?['distance'] ?? 0.0;

          return FlutterMap(
            mapController: _animatedMapController.mapController,
            options: MapOptions(initialCenter: start, initialZoom: 13),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      color: Colors.blue,
                      strokeWidth: 4,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: start,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _moveTo(start),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                  Marker(
                    point: end,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () => _moveTo(end),
                      child: Icon(Icons.flag, color: Colors.green, size: 40),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _routeFuture = _fetchRoute();
          });
        },
        child: Icon(Icons.refresh),
      ),
      bottomNavigationBar: FutureBuilder<Map<String, dynamic>>(
        future: _routeFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || (snapshot.data?['distance'] == 0.0)) {
            return SizedBox.shrink();
          }

          return Container(
            padding: EdgeInsets.all(10),
            color: Colors.black87,
            child: Text(
              "Khoảng cách: ${snapshot.data!['distance'].toStringAsFixed(2)} km",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
