import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = screenWidth / 4; // 4 items
    double LineWidth = 60; // Độ rộng của gạch

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < 4; i++)
                _buildNavItem(i, _getIcon(i), _getLabel(i)),
            ],
          ),
        ),

        // Gạch di chuyển chính giữa icon
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          left: selectedIndex * itemWidth + (itemWidth / 2 - LineWidth / 2),
          bottom: 58, // Giữ gạch ngay trên icon
          child: Container(
            width: LineWidth,
            height: 2,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? Colors.deepOrange : Colors.grey;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              top: isSelected ? 0 : 8,
            ), // Đẩy icon lên khi chọn
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: isSelected ? 30 : 24),
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0, // Hiện chữ khi chọn
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    label,
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.wallet;
      case 2:
        return Icons.location_on;
      case 3:
        return Icons.person;
      default:
        return Icons.help;
    }
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Wallet';
      case 2:
        return 'Map';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }
}
