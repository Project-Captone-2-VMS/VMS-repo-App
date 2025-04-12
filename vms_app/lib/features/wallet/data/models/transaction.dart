import 'package:flutter/material.dart';

class Transaction {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int amount;
  final String time;

  Transaction({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
  });
}
