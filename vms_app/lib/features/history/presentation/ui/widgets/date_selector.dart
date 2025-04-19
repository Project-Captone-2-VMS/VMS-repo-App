import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final int month;
  final int year;
  final int startDay;
  final int endDay;

  const DateSelector({
    Key? key,
    required this.month,
    required this.year,
    required this.startDay,
    required this.endDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.grey),
            onPressed: () {},
          ),
          Expanded(
            child: Center(
              child: Text(
                '$month-$year (0$startDay/$month-$endDay/$month)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
