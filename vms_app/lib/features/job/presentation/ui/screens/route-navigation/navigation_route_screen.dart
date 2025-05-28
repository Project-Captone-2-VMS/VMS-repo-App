import 'dart:async';
import 'dart:convert';

import 'package:flexible_polyline_dart/flutter_flexible_polyline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/features/job/data/models/job_model.dart' as job_model;
import 'package:vms_app/features/job/data/repositories/job_repository.dart';
import 'package:vms_app/features/location/domain/location_repository.dart';

class NavigationScreen extends StatefulWidget {
  final job_model.Route? jobDetail;
  final LocationRepository locationRepository;
  final JobRepository jobRepository;

  const NavigationScreen({
    super.key,
    this.jobDetail,
    required this.locationRepository,
    required this.jobRepository,
  });

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final MapController _mapController = MapController();
  double _currentZoom = 13.0;
  final bool _isLoading = false;
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
  List<LatLng> _mainPoints = []; // Store waypoints (start, waypoints, end)
  int _currentLegIndex = 0; // Current leg (segment between waypoints)

  String? token;
  String? username;

  final _logger = Logger();

  // WebSocket client
  StompClient? _stompClient;

  @override
  void initState() {
    super.initState();
    if (widget.jobDetail != null) {
      _generateRoutePoints();
      _connectWebSocket();
      _getInformation();
    }
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _stompClient?.deactivate();
    super.dispose();
  }

  Future<void> _getInformation() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    username = pref.getString('username');
  }

  void _connectWebSocket() {
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/ws',
        onConnect: (_) {
          _logger.i("WebSocket Connected");
        },
        onWebSocketError: (dynamic error) {
          _logger.e("WebSocket Error: $error");
        },
        onDisconnect: (_) {
          _logger.i("WebSocket Disconnected");
        },
      ),
    );

    _stompClient?.activate();
  }

  void _sendNotification(Map<String, dynamic> formSend) {
    if (_stompClient != null && _stompClient!.isActive) {
      _stompClient!.send(
        destination: '/app/chat/admin123',
        body: jsonEncode(formSend),
      );
      print('Notification Sent: $formSend');
    } else {
      print('WebSocket not connected');
    }
  }

  void _generateRoutePoints() {
    if (widget.jobDetail == null || widget.jobDetail!.waypoints.isEmpty) return;

    _mainPoints =
        widget.jobDetail!.waypoints
            .map((waypoint) => LatLng(waypoint.lat, waypoint.lng))
            .toList();

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
    const double distanceThreshold = 100.0;
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

  Future<double> _promptForVelocity(int legIndex) async {
    TextEditingController velocityController = TextEditingController();
    String? errorText;

    double? velocity = await showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter the speed for leg ${legIndex + 1}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Velocity (km/h)'),
                  TextField(
                    controller: velocityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter velocity',
                      errorText: errorText,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop(null); // Cancel -> will set default later
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final input = double.tryParse(velocityController.text);
                    if (input != null && input >= 30 && input <= 90) {
                      Navigator.of(context).pop(input); // Valid
                    } else {
                      setState(() {
                        errorText = 'Velocity must be between 30 and 90 km/h';
                      });
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    if (velocity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No valid velocity entered. Defaulting to 50 km/h'),
        ),
      );
      velocity = 50.0; // default if Cancel pressed or dialog returns null
    }

    return velocity;
  }

  void _startNavigation() {
    if (_isMoving || widget.jobDetail == null || _routePoints.isEmpty) return;

    setState(() {
      _isMoving = true;
      _currentLegIndex = 0;
      _currentRouteIndex = 0;
      _hasArrived = false;
      _updateCurrentPositionMarker(_routePoints[_currentRouteIndex]);
    });

    _moveToNextLeg();
  }

  Future<void> _moveToNextLeg() async {
    if (_currentLegIndex >= _mainPoints.length - 1) {
      // Reached final destination
      setState(() {
        _isMoving = false;
        _hasArrived = true;
      });
      await _sendLocationToFirebase(_routePoints[_currentRouteIndex]);
      await widget.jobRepository.updateRouteAndShipment(
        widget.jobDetail!.routeId,
        token!,
      );

      // Send completion notification
      _sendNotification({
        'title': 'You have a new notification about successful delivery',
        'content':
            'The vehicle with license plate number ${widget.jobDetail!.vehicle.licensePlate} driven by driver ${widget.jobDetail!.driver.firstName} ${widget.jobDetail!.driver.lastName} completed the shipment',
        'type': 'USER',
      });

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('DONE'),
              content: const Text('You have reached your final destination.'),
              actions: [
                TextButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    // Get segment points for the current leg
    int startIndex = _waypointIndices[_currentLegIndex];
    int endIndex = _waypointIndices[_currentLegIndex + 1];
    List<LatLng> segmentPoints = _routePoints.sublist(startIndex, endIndex + 1);

    // Calculate distance
    double distance =
        widget.jobDetail!.interconnections[_currentLegIndex].distance;
    double distanceKm = distance / 1000.0;

    // Prompt for velocity
    double velocity = await _promptForVelocity(_currentLegIndex) ?? 50.0;

    // Calculate actual time (seconds)
    int actualTime = ((distanceKm / velocity) * 3600).ceil();

    // Adjust step interval based on velocity (faster velocity = smaller interval)
    int totalSteps = segmentPoints.length;
    int intervalMs = (actualTime * 1000 / totalSteps).round();
    // Scale interval inversely with velocity for faster movement
    int adjustedIntervalMs = (intervalMs / (velocity / 50.0)).round().clamp(
      50,
      500,
    ); // Limit between 50ms and 500ms

    if (widget.jobDetail?.interconnections != null &&
        widget.jobDetail!.interconnections.isNotEmpty) {
      _logger.i(widget.jobDetail!.interconnections[_currentLegIndex]);

      int interconnectionId =
          widget
              .jobDetail!
              .interconnections[_currentLegIndex]
              .interconnectionId;
      double timeEstimate =
          widget.jobDetail!.interconnections[_currentLegIndex].timeEstimate;

      final formDataTimeActual = {"timeActual": actualTime};

      await widget.jobRepository.updateTimeActual(
        interconnectionId,
        formDataTimeActual,
        token!,
      );

      // Send notification based on time comparison
      double timeSuccessful = timeEstimate - actualTime;
      double timePercent = (actualTime / timeEstimate) * 100;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text(
                _currentLegIndex == 0
                    ? 'The leg 1'
                    : 'Start the leg ${_currentLegIndex + 1}',
              ),
              content: const Text('Starting the leg. Press OK to continue.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      if (timePercent > 100) {
        _sendNotification({
          'title': 'You have a new warning',
          'content':
              'The vehicle with license plate number ${widget.jobDetail!.vehicle.licensePlate} driven by driver ${widget.jobDetail!.driver.firstName} ${widget.jobDetail!.driver.lastName} exceeded the estimated time ${formatTime(-timeSuccessful)}',
          'type': 'ALERT',
        });
      } else if (70 < timePercent && timePercent < 100) {
        _sendNotification({
          'title': 'You have a new notification',
          'content':
              'The vehicle with license plate ${widget.jobDetail!.vehicle.licensePlate} driven by driver ${widget.jobDetail!.driver.firstName} ${widget.jobDetail!.driver.lastName} arrived ${formatTime(timeSuccessful)} earlier than the expected time',
          'type': 'SYSTEM',
        });
      } else {
        _sendNotification({
          'title': 'You have a new notification',
          'content':
              'The vehicle with license plate ${widget.jobDetail!.vehicle.licensePlate} driven by driver ${widget.jobDetail!.driver.firstName} ${widget.jobDetail!.driver.lastName} arrived on time',
          'type': 'SYSTEM',
        });
      }
    }

    // Show dialog for start of leg

    // Timer for sending location to Firebase every 10 seconds
    Timer? firebaseTimer;
    firebaseTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!_isMoving || _currentRouteIndex >= _routePoints.length) {
        timer.cancel();
        return;
      }
      await _sendLocationToFirebase(_routePoints[_currentRouteIndex]);
    });

    // Simulate movement for the leg
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(
      Duration(milliseconds: adjustedIntervalMs),
      (timer) async {
        if (_currentRouteIndex < endIndex) {
          setState(() {
            _currentRouteIndex++;
            _updateCurrentPositionMarker(_routePoints[_currentRouteIndex]);
            _mapController.move(_routePoints[_currentRouteIndex], _currentZoom);
          });

          // Debug
          print('Current Route Index: $_currentRouteIndex');
          for (int i = 0; i < _mainPoints.length; i++) {
            double distance = const Distance().as(
              LengthUnit.Meter,
              _routePoints[_currentRouteIndex],
              _mainPoints[i],
            );
            print('Distance to ${_mainPoints[i]}: $distance meters');
          }

          if (_waypointIndices.contains(_currentRouteIndex) &&
              _currentRouteIndex == endIndex) {
            timer.cancel();
            firebaseTimer?.cancel();
            _handleWaypointArrival(adjustedIntervalMs);
          }
        } else {
          timer.cancel();
          firebaseTimer?.cancel();
          _handleWaypointArrival(adjustedIntervalMs);
        }
      },
    );
  }

  Future<void> _handleWaypointArrival(int intervalMs) async {
    if (_currentLegIndex >= _mainPoints.length - 1) return;

    String waypointName =
        _currentLegIndex == 0
            ? 'Starting Point'
            : 'Warehouse ${_currentLegIndex + 1}';

    print('Arrived at $waypointName at route index $_currentRouteIndex');

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text('Arrived at $waypointName'),
            content: Text(
              'You have reached $waypointName. Please click confirm before continuing!',
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

    // Move to next leg
    setState(() {
      _currentLegIndex++;
    });
    _moveToNextLeg();
  }

  void _stopNavigation() {
    _movementTimer?.cancel();
    setState(() {
      _isMoving = false;
    });
    if (_currentRouteIndex < _routePoints.length) {
      _sendLocationToFirebase(_routePoints[_currentRouteIndex]);
      _sendNotification({
        'title': 'Navigation Stopped',
        'content':
            'The vehicle with license plate number ${widget.jobDetail!.vehicle.licensePlate} driven by driver ${widget.jobDetail!.driver.firstName} ${widget.jobDetail!.driver.lastName} has stopped navigation at position ${_routePoints[_currentRouteIndex]}',
        'type': 'SYSTEM',
      });
    }
  }

  void _continueNavigation() {
    if (_isMoving || widget.jobDetail == null || _routePoints.isEmpty) return;

    setState(() {
      _isMoving = true;
    });

    // Resume from the current leg
    _moveToNextLeg();
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

    final bounds = LatLngBounds.fromPoints(_routePoints);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50.0)),
    );
  }

  String formatTime(double timeInSeconds) {
    final hours = (timeInSeconds / 3600).floor();
    final minutes = ((timeInSeconds % 3600) / 60).round();
    return hours > 0 ? '$hours h $minutes min' : '$minutes min';
  }

  String formatDistance(int distanceInMeters) {
    double distanceInKilometers = distanceInMeters / 1000.0;
    return '${distanceInKilometers.toStringAsFixed(2)} km';
  }

  double min(double a, double b) => a < b ? a : b;
  double max(double a, double b) => a > b ? a : b;

  Future<void> _sendLocationToFirebase(LatLng position) async {
    try {
      await widget.locationRepository.updateLocationToFirebase(
        widget.jobDetail!.routeId,
        position.latitude,
        position.longitude,
      );
      print('Location sent to Firebase: $position');
    } catch (e) {
      print('Error sending location to Firebase: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending location: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jobDetail == null || widget.jobDetail!.waypoints.isEmpty) {
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
        double startLat = _mainPoints.first.latitude;
        double startLng = _mainPoints.first.longitude;

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
                    initialCenter:
                        _mainPoints.isNotEmpty
                            ? _mainPoints.first
                            : LatLng(0, 0),
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
                        ..._mainPoints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final point = entry.value;
                          return Marker(
                            width: 40.0,
                            height: 40.0,
                            point: point,
                            child: Icon(
                              index == 0
                                  ? Icons.location_on
                                  : index == _mainPoints.length - 1
                                  ? Icons.flag
                                  : Icons.location_on,
                              color:
                                  index == 0
                                      ? Colors.red
                                      : index == _mainPoints.length - 1
                                      ? Colors.green
                                      : Colors.orange,
                              size: 40,
                            ),
                          );
                        }),
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
                    : "Estimated time: ${formatTime(widget.jobDetail!.totalTime.toDouble())}",
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
          Row(
            children: [
              Expanded(
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
              if (!_isMoving && !_hasArrived) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _continueNavigation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
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
