import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'time_filter.dart';

class SpendFrequencyChart extends StatefulWidget {
  const SpendFrequencyChart({super.key});

  @override
  State<SpendFrequencyChart> createState() => _SpendFrequencyChartState();
}

class _SpendFrequencyChartState extends State<SpendFrequencyChart> {
  String selectedFilter = 'Today';
  final List<String> filters = ['Today', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spend Frequency',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1),
                    FlSpot(1, 1.5),
                    FlSpot(2, 1.2),
                    FlSpot(3, 2.1),
                    FlSpot(4, 2.5),
                    FlSpot(5, 1.8),
                    FlSpot(6, 2.2),
                    FlSpot(7, 2.5),
                  ],
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.1),
                  ),
                ),
              ],
              lineTouchData: const LineTouchData(enabled: false),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:
              filters
                  .map(
                    (filter) => TimeFilter(
                      title: filter,
                      isSelected: selectedFilter == filter,
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
