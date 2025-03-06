// lib/viewmodels/map_view_model.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:vms_app/services/map/map_service.dart';
import 'package:vms_app/services/map/search_service.dart';

class MapViewModel with ChangeNotifier {
  final MapService _mapService = MapService();
  final SearchService _searchService = SearchService();
  late Timer _simulationTimer;

  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  final FocusNode _searchFocusNode1 = FocusNode();
  final FocusNode _searchFocusNode2 = FocusNode();
  final GlobalKey _searchFieldKey1 = GlobalKey();
  final GlobalKey _searchFieldKey2 = GlobalKey();
  String? _searchError1;
  String? _searchError2;
  List<dynamic> _suggestions1 = [];
  List<dynamic> _suggestions2 = [];
  LatLng? _point1;
  LatLng? _point2;
  List<LatLng> _routePoints = []; // Đảm bảo danh sách không rỗng khi cần thiết

  MapViewModel() {
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(milliseconds: 500), (
      timer,
    ) {
      _mapService.simulateMovement();
      notifyListeners();
    });
  }

  Future<void> searchLocation1(String query) async {
    if (query.isEmpty) {
      _searchError1 = 'Please enter a location';
      notifyListeners();
      return;
    }

    _searchError1 = 'Searching...';
    notifyListeners();
    final location = await _searchService.searchLocation(query);
    if (location != null) {
      _searchError1 = null;
      _point1 = location;
      _mapService.moveToLocation(location);
      _mapService.routePoints = [location];
    } else {
      _searchError1 = 'Location not found';
    }
    _printCoordinatesIfBothSet();
    notifyListeners();
  }

  Future<void> searchLocation2(String query) async {
    if (query.isEmpty) {
      _searchError2 = 'Please enter a location';
      notifyListeners();
      return;
    }

    _searchError2 = 'Searching...';
    notifyListeners();
    final location = await _searchService.searchLocation(query);
    if (location != null) {
      _searchError2 = null;
      _point2 = location;
      _mapService.moveToLocation(location);
      _mapService.routePoints = [location];
    } else {
      _searchError2 = 'Location not found';
    }
    _printCoordinatesIfBothSet();
    notifyListeners();
  }

  Future<void> fetchSuggestions1(String query) async {
    if (query.isEmpty) {
      _suggestions1 = [];
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5',
        ),
        headers: {'User-Agent': 'vms_app/1.0 (laptrinhf8@gmail.com)'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        _suggestions1 = data;
      } else {
        _suggestions1 = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching suggestions1: $e');
      _suggestions1 = [];
      notifyListeners();
    }
  }

  Future<void> fetchSuggestions2(String query) async {
    if (query.isEmpty) {
      _suggestions2 = [];
      notifyListeners();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5',
        ),
        headers: {'User-Agent': 'vms_app/1.0 (laptrinhf8@gmail.com)'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        _suggestions2 = data;
      } else {
        _suggestions2 = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching suggestions2: $e');
      _suggestions2 = [];
      notifyListeners();
    }
  }

  void _printCoordinatesIfBothSet() {
    final location1Future = _searchService.searchLocation(
      _searchController1.text.trim(),
    );
    final location2Future = _searchService.searchLocation(
      _searchController2.text.trim(),
    );

    Future.wait([location1Future, location2Future]).then((locations) {
      final latLng1 = locations[0];
      final latLng2 = locations[1];
      if (latLng1 != null && latLng2 != null) {
        print(
          'Coordinates 1: Lat: ${latLng1.latitude}, Lon: ${latLng1.longitude}',
        );
        print(
          'Coordinates 2: Lat: ${latLng2.latitude}, Lon: ${latLng2.longitude}',
        );
        _routePoints = [latLng1, latLng2];
        notifyListeners();
      }
    });
  }

  void reset() {
    _mapService.resetMap();
    _point1 = null;
    _point2 = null;
    _routePoints = [];
    _searchController1.clear();
    _searchController2.clear();
    _searchError1 = null;
    _searchError2 = null;
    notifyListeners();
  }

  void zoomIn() {
    final currentZoom = _mapService.mapController.camera.zoom ?? 13.0;
    _mapService.mapController.moveAndRotate(
      _mapService.mapController.camera.center,
      (currentZoom + 1.0).toDouble(),
      0.0,
    );
    notifyListeners();
  }

  void zoomOut() {
    final currentZoom = _mapService.mapController.camera.zoom ?? 13.0;
    if (currentZoom > (_mapService.mapController.camera.minZoom ?? 10.0)) {
      _mapService.mapController.moveAndRotate(
        _mapService.mapController.camera.center,
        (currentZoom - 1.0).toDouble(),
        0.0,
      );
    }
    notifyListeners();
  }

  void selectSuggestion1(int index) {
    if (index >= 0 && index < _suggestions1.length) {
      final suggestion = _suggestions1[index];
      final lat = double.parse(suggestion['lat']);
      final lon = double.parse(suggestion['lon']);
      final location = LatLng(lat, lon);
      _mapService.moveToLocation(location);
      _mapService.routePoints = [location];
      _searchController1.text = suggestion['display_name'];
      _searchError1 = null;
      _point1 = location;
      _suggestions1 = [];
      _printCoordinatesIfBothSet();
      notifyListeners();
    }
  }

  void selectSuggestion2(int index) {
    if (index >= 0 && index < _suggestions2.length) {
      final suggestion = _suggestions2[index];
      final lat = double.parse(suggestion['lat']);
      final lon = double.parse(suggestion['lon']);
      final location = LatLng(lat, lon);
      _mapService.moveToLocation(location);
      _mapService.routePoints = [location];
      _searchController2.text = suggestion['display_name'];
      _searchError2 = null;
      _point2 = location;
      _suggestions2 = [];
      _printCoordinatesIfBothSet();
      notifyListeners();
    }
  }

  // Getters
  TextEditingController get searchController1 => _searchController1;
  TextEditingController get searchController2 => _searchController2;
  String? get searchError1 => _searchError1;
  String? get searchError2 => _searchError2;
  List<dynamic> get suggestions1 => _suggestions1;
  List<dynamic> get suggestions2 => _suggestions2;
  FocusNode get searchFocusNode1 => _searchFocusNode1;
  FocusNode get searchFocusNode2 => _searchFocusNode2;
  GlobalKey get searchFieldKey1 => _searchFieldKey1;
  GlobalKey get searchFieldKey2 => _searchFieldKey2;
  MapService get mapService => _mapService;
  List<LatLng> get routePoints => _routePoints;

  @override
  void dispose() {
    _simulationTimer.cancel();
    _searchController1.dispose();
    _searchController2.dispose();
    _searchFocusNode1.dispose();
    _searchFocusNode2.dispose();
    super.dispose();
  }
}
