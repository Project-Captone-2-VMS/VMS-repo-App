import 'package:flutter/material.dart';

class SettingItemModel {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback? onTap;

  SettingItemModel({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.onTap,
  });
}
