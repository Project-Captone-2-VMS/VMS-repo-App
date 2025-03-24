import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// Import widgets
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/menu_cards_widget.dart';
import '../widgets/welcome_section_widget.dart';

class TruckerHomeScreen extends StatefulWidget {
  const TruckerHomeScreen({super.key});

  @override
  State<TruckerHomeScreen> createState() => _TruckerHomeScreenState();
}

class _TruckerHomeScreenState extends State<TruckerHomeScreen> {
  String _currentAddress = "Fetching location...";
  bool _isLoading = true;
  int _selectedIndex = 0;
  bool _locationError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = false;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = "Dehradun, India";
          _errorMessage =
              "Location services are disabled. Please enable location services.";
          _locationError = true;
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = "Dehradun, India";
            _errorMessage = "Location permissions denied.";
            _locationError = true;
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress = "Dehradun, India";
          _errorMessage = "Location permissions permanently denied.";
          _locationError = true;
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException("Location request timed out.");
        },
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        setState(() {
          _currentAddress = place.street ?? "Unknown street";
          _isLoading = false;
          _locationError = false;
        });
      } else {
        setState(() {
          _currentAddress = "Location unknown";
          _errorMessage = "Could not determine location name.";
          _locationError = true;
          _isLoading = false;
        });
      }
    } on TimeoutException {
      setState(() {
        _currentAddress = "Location unknown";
        _errorMessage = "Location request timed out.";
        _locationError = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Location unknown";
        _errorMessage =
            "Error: ${e.toString().substring(0, Math.min(e.toString().length, 100))}";
        _locationError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              currentAddress: _currentAddress,
              isLoading: _isLoading,
              locationError: _locationError,
              errorMessage: _errorMessage,
              onRetry: _getCurrentLocation,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    WelcomeSectionWidget(
                      driverName: 'Trucker Hoang Lanh',
                      driverId: '12345',
                    ),
                    Transform.translate(
                      offset: Offset(0, -50),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: const MenuCardsWidget(),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            BottomNavigationWidget(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
