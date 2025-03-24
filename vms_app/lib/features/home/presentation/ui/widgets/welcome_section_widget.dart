import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeSectionWidget extends StatelessWidget {
  final String driverName;
  final String driverId;

  const WelcomeSectionWidget({
    super.key,
    required this.driverName,
    required this.driverId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image takes up the whole screen (phone screen size)
        Container(
          width: double.infinity,
          height: 250,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/trucks_background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WELCOME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                driverName,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Truck Driver ID: $driverId',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 70,
          left: 20,
          child: Container(
            child: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 249, 146, 43),
              size: 25,
            ),
          ),
        ),
      ],
    );
  }
}
