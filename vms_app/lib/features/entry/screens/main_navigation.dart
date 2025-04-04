import 'package:flutter/material.dart';
import 'package:vms_app/features/entry/widgets/bottom_navigation_widget.dart';
import 'package:vms_app/features/home/presentation/ui/screens/home_screen.dart';
import 'package:vms_app/features/wallet/presentation/ui/screens/wallet_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // Danh sách các screen
  final List<Widget> _screens = [
    TruckerHomeScreen(),
    WalletScreen(),
    // MapScreen(),
    // ProfileScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationWidget(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
