import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderWidget extends StatelessWidget {
  final String currentAddress;
  final bool isLoading;
  final bool locationError;
  final String errorMessage;
  final VoidCallback onRetry;

  const HeaderWidget({
    super.key,
    required this.currentAddress,
    required this.isLoading,
    required this.locationError,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trucker Home',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isLoading ? "Fetching location..." : currentAddress,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (locationError)
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 18),
                      onPressed: onRetry,
                      tooltip: 'Retry',
                      padding: const EdgeInsets.all(4),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (locationError)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: Colors.amber.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.amber[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
