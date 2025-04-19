import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/features/profile/data/models/setting_item_model.dart';
import 'settings_item.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItemModel> settingItems = [
      SettingItemModel(
        icon: Icons.account_circle,
        iconColor: AppTheme.primaryColor,
        title: 'Account',
        onTap: () {
          context.push('/update-profile');
        },
      ),
      SettingItemModel(
        icon: Icons.notifications,
        iconColor: AppTheme.primaryColor,
        title: 'Notification',
        onTap: () {},
      ),
      SettingItemModel(
        icon: Icons.storage,
        iconColor: AppTheme.primaryColor,
        title: 'Data and storage',
        onTap: () {
          print('Tapped Data and storage');
        },
      ),
      SettingItemModel(
        icon: Icons.lock,
        iconColor: AppTheme.primaryColor,
        title: 'Privacy and security',
        onTap: () {},
      ),
      SettingItemModel(
        icon: Icons.info,
        iconColor: AppTheme.primaryColor,
        title: 'About',
        onTap: () {},
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settingItems.length,
      itemBuilder: (context, index) {
        return SettingsItem(item: settingItems[index]);
      },
    );
  }
}
