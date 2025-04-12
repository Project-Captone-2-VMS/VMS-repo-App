import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vms_app/features/home/presentation/ui/widgets/send_alert_widget.dart';

// Import widgets
import '../widgets/menu_cards_widget.dart';

class TruckerHomeScreen extends StatefulWidget {
  const TruckerHomeScreen({super.key});

  @override
  State<TruckerHomeScreen> createState() => _TruckerHomeScreenState();
}

class _TruckerHomeScreenState extends State<TruckerHomeScreen> {
  String _currentAddress = "Fetching location...";
  bool _isLoading = true;
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
          _currentAddress = place.street ?? "Dehradun, India";
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              // snap: true,
              floating: false,
              pinned: true,
              expandedHeight: 270,
              backgroundColor: AppTheme.primaryColor,
              title: Row(
                children: [
                  const Icon(
                    Icons.menu_open_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Current Address',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _isLoading ? "Fetching..." : _currentAddress,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 30,
                        ),
                        if (_locationError)
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 22),
                            onPressed: _getCurrentLocation,
                            tooltip: 'Retry',
                            padding: const EdgeInsets.all(4),
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/trucks_background.png',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'WELCOME',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Trucker Hoang Lanh',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Trucker ID: EXAPRO652',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total Truck Number: 20',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () {
                              context.push('/notification');
                            },
                            child: const Icon(
                              Icons.notifications,
                              color: Color.fromARGB(255, 249, 146, 43),
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                MenuCardsWidget(),
                // const SizedBox(height: 1000),
              ]),
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Center(child: SendAlertWidget()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
