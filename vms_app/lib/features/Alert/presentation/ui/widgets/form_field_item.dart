import 'package:flutter/material.dart';
import 'package:vms_app/config/theme/app_theme.dart';

class FormFieldItem extends StatelessWidget {
  final String value;
  final IconData icon;
  final VoidCallback onEdit;

  const FormFieldItem({
    Key? key,
    required this.value,
    required this.icon,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
