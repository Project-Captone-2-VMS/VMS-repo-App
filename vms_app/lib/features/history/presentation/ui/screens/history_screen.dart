import 'package:flutter/material.dart';
import 'package:vms_app/features/history/data/models/trip.dart';
import '../widgets/date_selector.dart';
import '../widgets/stats_cards.dart';
import '../widgets/trip_chart.dart';
import '../widgets/trip_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<Trip> trips = [
      Trip(
        id: '1',
        route: 'Bắc - nam',
        items: 3,
        points: 2,
        distance: 1200,
        date: DateTime(2025, 3, 4),
        status: TripStatus.late,
      ),
      Trip(
        id: '2',
        route: 'Nam - Bắc', // Đã sửa để tránh trùng lặp
        items: 4,
        points: 1,
        distance: 1500,
        date: DateTime(2025, 3, 2),
        status: TripStatus.completed,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'History',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 8),

                    // Date selector
                    const DateSelector(
                      month: 3,
                      year: 2025,
                      startDay: 1,
                      endDay: 31,
                    ),

                    const SizedBox(height: 24),

                    // Stats cards
                    const StatsCards(
                      lateTrips: 20,
                      completedTrips: 20,
                      totalTrips: 40,
                    ),

                    const SizedBox(height: 24),

                    // Chart
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const TripChart(
                        latePercentage: 50,
                        completedPercentage: 50,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Trip items
                    ...trips
                        .map(
                          (trip) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TripItem(trip: trip),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
