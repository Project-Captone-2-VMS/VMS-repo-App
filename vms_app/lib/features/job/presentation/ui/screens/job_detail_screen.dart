import 'package:flexible_polyline_dart/flutter_flexible_polyline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/job/data/models/job_model.dart' as job_model;
import 'package:vms_app/features/job/presentation/cubit/job_cubit.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final bloc = sl<JobCubit>();

  int? routeId;
  String? token;
  final _logger = Logger();

  final MapController _mapController = MapController();

  double _currentZoom = 13.0;
  final double _maxZoom = 18.0;
  final double _minZoom = 1.0;
  List<LatLng> _routePoints = [];

  final bool _isLoading = false;

  @override
  void initState() {
    _getRoute();
    super.initState();
  }

  Future<void> _getRoute() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    routeId = GoRouterState.of(context).extra as int?;

    if (token == null) {
      _logger.e("Token Null");
    } else {
      bloc.getRouteByRouteId(routeId!, token!);
    }
  }

  String formatTime(String time) {
    try {
      final timeValue = double.parse(time).round();
      final hours = (timeValue / 3600).floor();
      final minutes = ((timeValue % 3600) / 60).round();

      if (hours > 0) {
        return minutes > 0 ? 'About ${hours}h ${minutes}m' : 'About ${hours}h';
      } else {
        return 'About ${minutes}m';
      }
    } catch (e) {
      return 'Time not available';
    }
  }

  String formatDistance(int distanceInMeters) {
    double distanceInKilometers = distanceInMeters / 1000.0;
    return '${distanceInKilometers.toStringAsFixed(2)} km';
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(_minZoom, _maxZoom);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(_minZoom, _maxZoom);
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  List<LatLng> _decodeHerePolyline(String encodedPolyline) {
    try {
      final decoded = FlexiblePolyline.decode(encodedPolyline);
      return decoded.map((point) => LatLng(point.lat, point.lng)).toList();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Polyline Decoding Error: $e")));
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: BlocBuilder<JobCubit, JobState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is JobStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobStateSuccessRoute) {
            final jobDetail = state.success;
            // Tính toán tuyến đường khi có dữ liệu
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_routePoints.isEmpty && !_isLoading) {
                setState(() {
                  _routePoints = _decodeHerePolyline(jobDetail.polyline!);
                });
              }
            });
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.grey[200],
                  elevation: 0,
                  pinned: false,
                  snap: true,
                  floating: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                  title: Text(
                    'Job Detail',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildDriverInfoCard(jobDetail.driver),
                  ),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 18)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildTruckInfoCard(jobDetail.vehicle),
                  ),
                ),
                SliverToBoxAdapter(child: const SizedBox(height: 20)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildMapSection(jobDetail),
                  ),
                ),

                SliverToBoxAdapter(child: const SizedBox(height: 16)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildRouteSection(
                      context,
                      jobDetail.waypoints,
                      jobDetail.interconnections,
                      jobDetail.routeId,
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: const SizedBox(height: 20)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverToBoxAdapter(
                    child: _buildActionButtons(jobDetail),
                  ),
                ),

                SliverToBoxAdapter(child: const SizedBox(height: 20)),
              ],
            );
          } else if (state is JobStateError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDriverInfoCard(job_model.Driver driver) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'These are the available truck',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/driver1.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${driver.firstName} ${driver.lastName}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        'License Number',
                        driver.licenseNumber ?? 'N/A',
                      ),
                      _buildInfoRow('Email', driver.email),
                      _buildInfoRow('Phone Number', driver.phoneNumber),
                      _buildInfoRow(
                        'Status',
                        driver.status ? 'Busy' : 'Available',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckInfoCard(job_model.Vehicle vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Truck Info',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTruckInfoRow('Type', vehicle.type),
                  _buildTruckInfoRow('License Plate', vehicle.licensePlate),
                  _buildTruckInfoRow('Capacity', vehicle.capacity.toString()),
                  _buildTruckInfoRow(
                    'Maintenance Schedule',
                    vehicle.maintenanceSchedule,
                  ),
                  _buildTruckInfoRow(
                    'Vehicle Status',
                    vehicle.status ? "Busy" : "Available",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/truck.png',
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckInfoRow(String label, String value) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
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
                              // Use different icons for start, end, and intermediate waypoints
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
                        // End point marker (optional, if not included in waypoints)
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

  Widget _buildRouteSection(
    BuildContext context,
    List<job_model.Waypoint> waypoint,
    List<job_model.Interconnection> interconnection,
    int routeId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Route',
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.push('/route-editor', extra: routeId);
                      },
                      label: Text(
                        'Edit Time Estimate',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[800],
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 94, 94, 94),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: List.generate(waypoint.length - 1, (index) {
                    final point1 = waypoint[index];
                    final point2 = waypoint[index + 1];
                    final inter = interconnection[index];

                    return _buildRoutePoint(
                      icon:
                          index == 0
                              ? Icons.location_on
                              : index == waypoint.length - 2
                              ? Icons.flag
                              : Icons.location_on,
                      iconColor:
                          index == 0
                              ? Colors.red
                              : index == waypoint.length - 2
                              ? Colors.green
                              : Colors.orange,
                      location:
                          'From ${point1.locationName} \n to ${point2.locationName}',
                      time: inter.timeWaypoint.toString(),
                      timeEstimate: inter.timeEstimate.toString(),
                      distance: inter.distance.toInt(),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoutePoint({
    required IconData icon,
    required Color iconColor,
    required String location,
    required String time,
    required String timeEstimate,
    required int distance,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 24),
              Container(width: 2, height: 30, color: Colors.grey[300]),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Time: ${formatTime(time)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Time Estimate: ${formatTime(timeEstimate)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(Icons.directions_car, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                formatDistance(distance),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(job_model.Route jobDetail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.push('/navigation-screen', extra: jobDetail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: () {
            print("Cancel pressed");
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF007AFF),
            side: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF007AFF),
            ),
          ),
        ),
      ],
    );
  }
}
