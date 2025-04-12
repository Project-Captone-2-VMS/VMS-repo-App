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
        title: const Text('Profile', style: AppTextStyles.appbarText),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              name: 'Darlene Steward',
              bio: 'Trust your feelings , be a good human beings',
              avatarUrl:
                  'https://static.vecteezy.com/system/resources/thumbnails/046/463/338/small/happy-young-man-celebrating-with-fists-raised-on-transparent-background-png.png',
            ),
            SizedBox(height: 16),
            SettingsList(),
          ],
        ),
      ),
    );
  }
}
