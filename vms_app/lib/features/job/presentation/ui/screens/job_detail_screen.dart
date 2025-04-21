import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:vms_app/config/theme/app_theme.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
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
            sliver: SliverToBoxAdapter(child: _buildDriverInfoCard()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 18)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(child: _buildTruckInfoCard()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(child: _buildMapSection()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(child: _buildRouteSection(context)),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverToBoxAdapter(child: _buildActionButtons()),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildDriverInfoCard() {
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
                        'Name',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow('Task', 'Chemical Delivery'),
                      _buildInfoRow('Departed', '20 Feb, 05:00 PM'),
                      _buildInfoRow(
                        'Current Location',
                        '123 Main Street, Anytown, ND 845103',
                      ),
                      _buildInfoRow('Trip Cost', 'Rs 10000'),
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

  Widget _buildTruckInfoCard() {
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

            // Thông tin xe
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTruckInfoRow('Vehicle Number', 'XXXXXXXXX'),
                  _buildTruckInfoRow('Owner Name', 'ZZZZZZZZZ'),
                  _buildTruckInfoRow('Registering authority', 'Bhopal city'),
                  _buildTruckInfoRow('Vehicle Type', 'Tipper Trucks'),
                  _buildTruckInfoRow('Fuel Type', 'Petrol'),
                  _buildTruckInfoRow('Emission Norm', 'BHARAT STAGE 6'),
                  _buildTruckInfoRow('Vehicle Age', '2years & 5 months'),
                  _buildTruckInfoRow('Vehicle Status', 'ACTIVE'),
                ],
              ),
            ),

            const SizedBox(height: 16), // Khoảng cách giữa thông tin và ảnh
            // Ảnh xe tải (theo chiều dọc)
            Center(
              child: Image.asset(
                'assets/images/truck.png',
                width: 350,
                // height: 120,
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

  Widget _buildMapSection() {
    final MapController mapController = MapController();

    // Hàm lấy vị trí hiện tại
    Future<void> _moveToCurrentLocation() async {
      try {
        // Kiểm tra và yêu cầu quyền truy cập vị trí
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return; // Không có quyền, thoát
          }
        }
        if (permission == LocationPermission.deniedForever) {
          return; // Quyền bị từ chối vĩnh viễn
        }

        // Lấy vị trí hiện tại
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Di chuyển map tới vị trí hiện tại
        mapController.move(
          LatLng(position.latitude, position.longitude),
          13.0, // Zoom level
        );
      } catch (e) {
        print('Error getting location: $e');
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
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(40.7128, -74.0060),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.location_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(40.7128, -74.0060),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Nút Zoom và Vị trí hiện tại
            Positioned(
              right: 10,
              bottom: 10,
              child: Column(
                children: [
                  // Nút Zoom In
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      final currentZoom = mapController.camera.zoom;
                      mapController.move(
                        mapController.camera.center,
                        currentZoom + 1,
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 8),
                  // Nút Zoom Out
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      final currentZoom = mapController.camera.zoom;
                      mapController.move(
                        mapController.camera.center,
                        currentZoom - 1,
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(height: 8),
                  // Nút di chuyển tới vị trí hiện tại
                  FloatingActionButton(
                    mini: true,
                    onPressed: _moveToCurrentLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteSection(BuildContext context) {
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
                        context.push('/route-editor');
                      },
                      label: Text(
                        'Edit',
                        style: AppTextStyles.body.copyWith(
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
                  children: [
                    _buildRoutePoint(
                      icon: Icons.circle_outlined,
                      iconColor: Colors.black,
                      location: 'Warrington, PA 76102',
                      time: 'Jun 22 10:00 AM EST',
                      showLine: true,
                    ),
                    _buildRoutePoint(
                      icon: Icons.location_on_outlined,
                      iconColor: Colors.black,
                      location: 'Marcus Hook, PA 19061',
                      time: 'Jun 23 11:30 AM EST',
                      showLine: true,
                    ),
                    _buildRoutePoint(
                      icon: Icons.location_on,
                      iconColor: Colors.red,
                      location: 'Midland, TX 79705',
                      time: 'Jun 24 2:30 PM EST',
                      showLine: false,
                      showDistance: true,
                      distance: '1,784 mi',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Received 50 min ago',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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
    required bool showLine,
    bool showDistance = false,
    String distance = '',
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          child: Column(
            children: [
              Icon(icon, color: iconColor, size: 24),
              if (showLine)
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
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDistance)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  distance,
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các nút
      children: [
        // Nút "Let's Go"
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Xử lý khi nhấn "Let's Go"
              print("Let's Go pressed");
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF), // Màu xanh dương iOS
              foregroundColor: Colors.white, // Màu chữ và hiệu ứng khi nhấn
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Bo góc
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ), // Khoảng cách bên trong nút
            ),
            child: const Text(
              "Let's Go",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600, // Chữ đậm
              ),
            ),
          ),
        ),
        const SizedBox(width: 16), // Khoảng cách giữa hai nút
        // Nút "Cancel"
        OutlinedButton(
          onPressed: () {
            // Xử lý khi nhấn "Cancel"
            print("Cancel pressed");
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF007AFF), // Màu chữ và viền
            side: const BorderSide(
              color: Color(0xFF007AFF), // Viền xanh dương
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bo góc
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 20,
            ), // Khoảng cách bên trong nút
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Chữ đậm
              color: Color(0xFF007AFF), // Màu chữ xanh dương
            ),
          ),
        ),
      ],
    );
  }
}
