import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter OpenStreetMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Điểm trung tâm của bản đồ (Ví dụ: Hà Nội, Việt Nam)
  final LatLng _center = const LatLng(21.0285, 105.8542);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap với Flutter'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _center,
          zoom: 13.0,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          // Layer hiển thị bản đồ OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
            // Nên thêm attribution để tuân thủ quy định của OpenStreetMap
            additionalOptions: const {
              'attribution': '© OpenStreetMap contributors',
            },
          ),
          // Layer để hiển thị markers
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _center,
                builder: (ctx) => const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Xử lý khi nhấn nút (ví dụ: quay lại vị trí trung tâm)
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}