import 'package:flutter/material.dart';
import 'package:vms_app/config/theme/app_theme.dart';

import '../widgets/profile_header.dart';
import '../widgets/settings_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.appbarText),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.customRed),
            onPressed: () {
              // Logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(
              name: 'Darlene Steward',
              bio: 'Tin vào cảm xúc của bạn, hãy là một con người tốt',
              avatarUrl:
                  'https://static.vecteezy.com/system/resources/thumbnails/046/463/338/small/happy-young-man-celebrating-with-fists-raised-on-transparent-background-png.png',
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.grey[300]),
            const SettingsList(),
          ],
        ),
      ),
    );
  }
}
