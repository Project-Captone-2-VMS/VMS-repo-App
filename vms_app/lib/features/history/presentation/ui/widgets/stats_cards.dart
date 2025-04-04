import 'package:flutter/material.dart';

class StatsCards extends StatelessWidget {
  final int lateTrips;
  final int completedTrips;
  final int totalTrips;

  const StatsCards({
    Key? key,
    required this.lateTrips,
    required this.completedTrips,
    required this.totalTrips,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Late',
                '$lateTrips trips',
                Colors.orange.shade400,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Total Done',
                '$completedTrips trips',
                Colors.green.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          'Total Trips',
          '$totalTrips trips',
          Colors.grey.shade700,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color valueColor) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
