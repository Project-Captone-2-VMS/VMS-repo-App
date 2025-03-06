// lib/screens/map_test_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:vms_app/core/utils/map_constants.dart';
import 'package:vms_app/presentation/viewmodels/map/map_view_model.dart';

class MapTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Consumer<MapViewModel>(
        builder: (context, viewModel, child) {
          OverlayEntry? _overlayEntry1;
          OverlayEntry? _overlayEntry2;

          // Hiển thị gợi ý cho thanh tìm kiếm 1
          void showSuggestions1() {
            _overlayEntry1?.remove();
            _overlayEntry1 = null;

            if (viewModel.suggestions1.isNotEmpty) {
              final RenderBox? renderBox =
                  viewModel.searchFieldKey1.currentContext?.findRenderObject()
                      as RenderBox?;
              if (renderBox == null) return;

              final Offset offset = renderBox.localToGlobal(Offset.zero);
              final Size size = renderBox.size;

              _overlayEntry1 = OverlayEntry(
                builder:
                    (context) => Positioned(
                      left: offset.dx,
                      top: offset.dy + size.height + 5,
                      width: size.width,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.suggestions1.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  viewModel.suggestions1[index]['display_name'],
                                ),
                                onTap: () {
                                  viewModel.selectSuggestion1(index);
                                  _overlayEntry1?.remove();
                                  _overlayEntry1 = null;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
              );

              Overlay.of(context).insert(_overlayEntry1!);
            }
          }

          // Hiển thị gợi ý cho thanh tìm kiếm 2
          void showSuggestions2() {
            _overlayEntry2?.remove();
            _overlayEntry2 = null;

            if (viewModel.suggestions2.isNotEmpty) {
              final RenderBox? renderBox =
                  viewModel.searchFieldKey2.currentContext?.findRenderObject()
                      as RenderBox?;
              if (renderBox == null) return;

              final Offset offset = renderBox.localToGlobal(Offset.zero);
              final Size size = renderBox.size;

              _overlayEntry2 = OverlayEntry(
                builder:
                    (context) => Positioned(
                      left: offset.dx,
                      top: offset.dy + size.height + 5,
                      width: size.width,
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.suggestions2.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  viewModel.suggestions2[index]['display_name'],
                                ),
                                onTap: () {
                                  viewModel.selectSuggestion2(index);
                                  _overlayEntry2?.remove();
                                  _overlayEntry2 = null;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
              );

              Overlay.of(context).insert(_overlayEntry2!);
            }
          }

          // Ẩn gợi ý khi mất focus
          viewModel.searchFocusNode1.addListener(() {
            if (!viewModel.searchFocusNode1.hasFocus) {
              _overlayEntry1?.remove();
              _overlayEntry1 = null;
            }
          });

          viewModel.searchFocusNode2.addListener(() {
            if (!viewModel.searchFocusNode2.hasFocus) {
              _overlayEntry2?.remove();
              _overlayEntry2 = null;
            }
          });

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'OSM Interactive Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 1, 38, 75),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.3),
              leading: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () {},
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: viewModel.searchFieldKey1,
                              controller: viewModel.searchController1,
                              focusNode: viewModel.searchFocusNode1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Search location 1 (e.g., Hanoi, Vietnam)',
                                hintStyle: TextStyle(color: Colors.white70),
                                errorText: viewModel.searchError1,
                                filled: true,
                                fillColor: Colors.black54,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 33, 150, 243),
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                suffixIcon: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        () => viewModel.searchLocation1(
                                          viewModel.searchController1.text,
                                        ),
                                  ),
                                ),
                              ),
                              onChanged:
                                  (value) => viewModel
                                      .fetchSuggestions1(value)
                                      .then((_) {
                                        if (viewModel.suggestions1.isNotEmpty)
                                          showSuggestions1();
                                      }),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: viewModel.searchFieldKey2,
                              controller: viewModel.searchController2,
                              focusNode: viewModel.searchFocusNode2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Search location 2 (e.g., Da Nang, Vietnam)',
                                hintStyle: TextStyle(color: Colors.white70),
                                errorText: viewModel.searchError2,
                                filled: true,
                                fillColor: Colors.black54,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade600,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 33, 150, 243),
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                suffixIcon: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        () => viewModel.searchLocation2(
                                          viewModel.searchController2.text,
                                        ),
                                  ),
                                ),
                              ),
                              onChanged:
                                  (value) => viewModel
                                      .fetchSuggestions2(value)
                                      .then((_) {
                                        if (viewModel.suggestions2.isNotEmpty)
                                          showSuggestions2();
                                      }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FlutterMap(
                    mapController: viewModel.mapService.mapController,
                    options: MapOptions(
                      initialCenter: initialLocation,
                      initialZoom: 13.0,
                      minZoom: 10.0,
                      maxZoom: 18.0,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      // Chỉ vẽ Polyline khi routePoints không rỗng
                      if (viewModel.routePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: viewModel.routePoints,
                              strokeWidth: 4.0,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      // Chỉ hiển thị Marker khi routePoints có dữ liệu
                      MarkerLayer(
                        markers: [
                          if (viewModel.routePoints.isNotEmpty)
                            Marker(
                              point: viewModel.routePoints[0],
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          if (viewModel.routePoints.length > 1)
                            Marker(
                              point: viewModel.routePoints[1],
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: viewModel.reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.red,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.refresh, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: viewModel.zoomIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              shadowColor: Colors.greenAccent,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.zoom_in, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Zoom In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: viewModel.zoomOut,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blueAccent,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.zoom_out, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Zoom Out',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
