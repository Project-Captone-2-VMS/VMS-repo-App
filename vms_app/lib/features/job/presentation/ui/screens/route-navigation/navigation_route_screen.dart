import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:flexible_polyline_dart/flutter_flexible_polyline.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/features/job/data/models/job_model.dart' as job_model;

class NavigationScreen extends StatefulWidget {
  final job_model.Route? jobDetail;

  const NavigationScreen({super.key, this.jobDetail});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;
  bool _isLoading = false;
  List<LatLng> _routePoints = [];

  // Current position marker
  Marker? _currentPositionMarker;

  // Movement simulation
  int _currentRouteIndex = 0;
  bool _isMoving = false;
  bool _hasArrived = false;
  Timer? _movementTimer;

  // List to store waypoint indices in _routePoints
  List<int> _waypointIndices = [];
  List<LatLng> _mainPoints = []; // Store start, waypoints, and end points

  @override
  void initState() {
    super.initState();
    if (widget.jobDetail != null) {
      _generateRoutePoints();
    }
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    super.dispose();
  }

  void _generateRoutePoints() {
    if (widget.jobDetail == null) return;

    _mainPoints = [];
    // Add start point
    _mainPoints.add(
      LatLng(widget.jobDetail!.startLat, widget.jobDetail!.startLng),
    );

    // Add waypoints
    for (var waypoint in widget.jobDetail!.waypoints) {
      _mainPoints.add(LatLng(waypoint.lat, waypoint.lng));
    }

    // Add end point
    _mainPoints.add(LatLng(widget.jobDetail!.endLat, widget.jobDetail!.endLng));

    // Generate intermediate points between each pair of points
    List<LatLng> detailedPoints = [];
    _waypointIndices = [0]; // Start point index

    int currentIndex = 0;
    for (int i = 0; i < _mainPoints.length - 1; i++) {
      var segmentPoints = _generateIntermediatePoints(
        _mainPoints[i],
        _mainPoints[i + 1],
        10,
      );
      detailedPoints.addAll(segmentPoints);
      currentIndex += segmentPoints.length;
      if (i < _mainPoints.length - 2) {
        _waypointIndices.add(currentIndex - 1); // Waypoint index
      }
    }
    _waypointIndices.add(detailedPoints.length - 1); // End point index

    // If polyline is available, decode it to get more accurate route points
    if (widget.jobDetail!.polyline != null &&
        widget.jobDetail!.polyline!.isNotEmpty) {
      _routePoints = _decodeHerePolyline(widget.jobDetail!.polyline!);
      if (_routePoints.isNotEmpty) {
        // Recalculate waypoint indices for polyline
        _waypointIndices = _calculateWaypointIndicesForPolyline(_mainPoints);
      } else {
        // Fallback to detailed points if polyline decoding fails
        _routePoints = detailedPoints;
      }
    } else {
      _routePoints = detailedPoints;
    }

    // Debug: Print waypoint indices and route points
    print('Waypoint Indices: $_waypointIndices');
    print('Route Points Length: ${_routePoints.length}');
    print('Main Points: $_mainPoints');

    setState(() {
      _routePoints = _routePoints;
    });
  }

  List<int> _calculateWaypointIndicesForPolyline(List<LatLng> mainPoints) {
    List<int> indices = [];
    const double distanceThreshold =
        100.0; // Increased to 100 meters for polyline
    for (var point in mainPoints) {
      int closestIndex = 0;
      double minDistance = double.infinity;
      for (int i = 0; i < _routePoints.length; i++) {
        double distance = const Distance().as(
          LengthUnit.Meter,
          point,
          _routePoints[i],
        );
        if (distance < minDistance) {
          minDistance = distance;
          closestIndex = i;
        }
      }
      if (minDistance <= distanceThreshold) {
        indices.add(closestIndex);
      } else {
        print(
          'Warning: No route point found within $distanceThreshold meters for point $point (minDistance: $minDistance)',
        );
      }
    }
    return indices;
  }

  List<LatLng> _generateIntermediatePoints(
    LatLng start,
    LatLng end,
    int numPoints,
  ) {
    List<LatLng> points = [start];

    double startLat = start.latitude;
    double startLng = start.longitude;
    double endLat = end.latitude;
    double endLng = end.longitude;

    for (int i = 1; i <= numPoints; i++) {
      double fraction = i / (numPoints + 1);
      double lat = startLat + (endLat - startLat) * fraction;
      double lng = startLng + (endLng - startLng) * fraction;

      points.add(LatLng(lat, lng));
    }

    points.add(end);
    return points;
  }

  List<LatLng> _decodeHerePolyline(String encodedPolyline) {
    try {
      final decoded = FlexiblePolyline.decode(encodedPolyline);
      return decoded.map((point) => LatLng(point.lat, point.lng)).toList();
    } catch (e) {
      print('Polyline Decoding Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Polyline Decoding Error: $e")));
      return [];
    }
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = min(_currentZoom + 1, 18);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = max(_currentZoom - 1, 3);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _startNavigation() {
    if (_isMoving || widget.jobDetail == null || _routePoints.isEmpty) return;

    setState(() {
      _isMoving = true;
      _hasArrived = false;
      _currentRouteIndex = 0;

      // Add current position marker at the start
      _updateCurrentPositionMarker(_routePoints[_currentRouteIndex]);
    });

    // Calculate time interval for movement simulation
    int intervalMs =
        90000 ~/ _routePoints.length; // 90 seconds for entire route

    _moveToNextPoint(intervalMs);
  }

  void _moveToNextPoint(int intervalMs) {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(Duration(milliseconds: intervalMs), (
      timer,
    ) {
      if (_currentRouteIndex < _routePoints.length - 1) {
        setState(() {
          _currentRouteIndex++;

          // Update current position marker
          _updateCurrentPositionMarker(_routePoints[_currentRouteIndex]);

          // Move map to follow the current position
          _mapController.move(_routePoints[_currentRouteIndex], _currentZoom);
        });

        // Debug: Print current index and check proximity to waypoints
        print('Current Route Index: $_currentRouteIndex');
        for (int i = 0; i < _mainPoints.length; i++) {
          double distance = const Distance().as(
            LengthUnit.Meter,
            _routePoints[_currentRouteIndex],
            _mainPoints[i],
          );
          print('Distance to ${_mainPoints[i]}: $distance meters');
        }

        // Check if current position is a waypoint
        if (_waypointIndices.contains(_currentRouteIndex)) {
          timer.cancel();
          int waypointIndex = _waypointIndices.indexOf(_currentRouteIndex);
          if (waypointIndex < _waypointIndices.length - 1) {
            // Show dialog for start and waypoints, but not for end
            _handleWaypointArrival(intervalMs, waypointIndex);
          } else {
            // Handle final destination
            setState(() {
              _isMoving = false;
              _hasArrived = true;
            });
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: const Text('Arrived!'),
                    content: const Text(
                      'You have reached your final destination.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
            );
          }
        }
      } else {
        // Reached destination
        timer.cancel();
        setState(() {
          _isMoving = false;
          _hasArrived = true;
        });

        // Show arrival dialog
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Arrived!'),
                content: const Text('You have reached your final destination.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    });
  }

  void _handleWaypointArrival(int intervalMs, int waypointIndex) async {
    // Determine waypoint name
    String waypointName =
        waypointIndex == 0 ? 'Starting Point' : 'warehouse ${waypointIndex}';

    print('Arrived at $waypointName at route index $_currentRouteIndex');

    // Show waypoint dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Arrived at $waypointName'),
            content: Text(
              'You have reached $waypointName. Please click confirm before continuing to move!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );

    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Continue navigation
    if (_currentRouteIndex < _routePoints.length - 1) {
      _moveToNextPoint(intervalMs);
    }
  }

  void _stopNavigation() {
    _movementTimer?.cancel();
    setState(() {
      _isMoving = false;
      _currentPositionMarker = null;
      _fitBounds();
    });
  }

  void _updateCurrentPositionMarker(LatLng position) {
    setState(() {
      _currentPositionMarker = Marker(
        width: 40.0,
        height: 40.0,
        point: position,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.circle, color: Colors.blue, size: 30.0),
        ),
      );
    });
  }

  void _fitBounds() {
    if (_routePoints.isEmpty) return;

    if (_mapController.mapEventStream != null) {
      final bounds = LatLngBounds.fromPoints(_routePoints);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBounds();
      });
    }
  }

  String formatTime(int timeInSeconds) {
    final hours = (timeInSeconds / 3600).floor();
    final minutes = ((timeInSeconds % 3600) / 60).round();

    if (hours > 0) {
      return minutes > 0 ? '$hours h $minutes min' : '$hours h';
    } else {
      return '$minutes min';
    }
  }

  String formatDistance(int distanceInMeters) {
    double distanceInKilometers = distanceInMeters / 1000.0;
    return '${distanceInKilometers.toStringAsFixed(2)} km';
  }

  double min(double a, double b) => a < b ? a : b;
  double max(double a, double b) => a > b ? a : b;

  @override
  Widget build(BuildContext context) {
    if (widget.jobDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Navigation'),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Center(
          child: Text(
            'No route data available',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation', style: AppTextStyles.appbarText),
        backgroundColor: AppTheme.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMapSection(widget.jobDetail!),
              const SizedBox(height: 16),
              _buildNavigationControls(),
              if (_hasArrived) _buildArrivedMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapSection(job_model.Route jobDetail) {
    Future<void> moveToCurrentLocation() async {
      try {
        double startLat = jobDetail.startLat;
        double startLng = jobDetail.startLng;

        _mapController.move(LatLng(startLat, startLng), _currentZoom);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error moving to location: $e")));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Map',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 480,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                      jobDetail.startLat,
                      jobDetail.startLng,
                    ),
                    initialZoom: _currentZoom,
                    onMapReady: () {
                      _fitBounds();
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                      userAgentPackageName: 'com.example.vms_app',
                    ),
                    MarkerLayer(
                      markers: [
                        // Start point marker
                        Marker(
                          width: 40.0,
                          height: 40.0,
                          point: LatLng(jobDetail.startLat, jobDetail.startLng),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                        // Waypoint markers
                        ...jobDetail.waypoints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final waypoint = entry.value;
                          return Marker(
                            width: 40.0,
                            height: 40.0,
                            point: LatLng(waypoint.lat, waypoint.lng),
                            child: Icon(
                              index == 0
                                  ? Icons.location_on
                                  : index == jobDetail.waypoints.length - 1
                                  ? Icons.flag
                                  : Icons.location_on,
                              color:
                                  index == 0
                                      ? Colors.red
                                      : index == jobDetail.waypoints.length - 1
                                      ? Colors.green
                                      : Colors.orange,
                              size: 40,
                            ),
                          );
                        }),
                        // End point marker
                        if (jobDetail.waypoints.isEmpty ||
                            (jobDetail.waypoints.last.lat != jobDetail.endLat ||
                                jobDetail.waypoints.last.lng !=
                                    jobDetail.endLng))
                          Marker(
                            width: 40.0,
                            height: 40.0,
                            point: LatLng(jobDetail.endLat, jobDetail.endLng),
                            child: const Icon(
                              Icons.flag,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                        // Current position marker
                        if (_currentPositionMarker != null)
                          _currentPositionMarker!,
                      ],
                    ),
                    if (_routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _routePoints,
                            strokeWidth: 5.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
            Positioned(
              right: 16,
              bottom: 16,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: 'zoom_in_fab',
                    mini: true,
                    backgroundColor: AppTheme.primaryColor,
                    onPressed: _zoomIn,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'zoom_out_fab',
                    mini: true,
                    backgroundColor: AppTheme.primaryColor,
                    onPressed: _zoomOut,
                    child: const Icon(Icons.remove, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton(
                    heroTag: 'location_fab',
                    mini: true,
                    backgroundColor: AppTheme.primaryColor,
                    onPressed: moveToCurrentLocation,
                    child: const Icon(Icons.my_location, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Navigation Controls',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                _hasArrived
                    ? "Arrived"
                    : "Estimated time: ${formatTime(widget.jobDetail!.totalTime)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                formatDistance(widget.jobDetail!.totalDistance),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isMoving ? _stopNavigation : _startNavigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isMoving
                    ? "Stop"
                    : (_hasArrived ? "Start New Route" : "Let's Go!"),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrivedMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Arrived",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "You have reached your destination",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
