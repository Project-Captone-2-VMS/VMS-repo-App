import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TripChart extends StatelessWidget {
  final double latePercentage;
  final double completedPercentage;

  const TripChart({
    Key? key,
    required this.latePercentage,
    required this.completedPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.shade50,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: [
              PieChartSectionData(
                value: completedPercentage,
                color: Colors.green,
                title: '${completedPercentage.toInt()}%',
                radius: 80,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              PieChartSectionData(
                value: latePercentage,
                color: Colors.yellow,
                title: '${latePercentage.toInt()}%',
                radius: 80,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
