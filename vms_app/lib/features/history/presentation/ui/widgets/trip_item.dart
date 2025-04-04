import 'package:flutter/material.dart';
import 'package:vms_app/features/history/data/models/trip.dart';
import 'package:intl/intl.dart';

class TripItem extends StatelessWidget {
  final Trip trip;

  const TripItem({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d-M-yyyy');

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade50,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/truck.png',
                      width: 80,
                      height: 60,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              trip.route,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (trip.status == TripStatus.completed)
                              Text(
                                ' (${DateFormat('d-M-yyyy').format(trip.date)})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${trip.items} items  |  ${trip.points} point  |  ${trip.distance} km',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (trip.status == TripStatus.late)
                      Text(
                        dateFormat.format(trip.date),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 8),
                    _buildStatusButton(trip.status),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(TripStatus status) {
    switch (status) {
      case TripStatus.late:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Late',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
        );
      case TripStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'Complete',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
