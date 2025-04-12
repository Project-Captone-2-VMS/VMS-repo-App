import 'package:flutter/material.dart';
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
      ),
      SettingItemModel(
        icon: Icons.menu_book,
        iconColor: AppTheme.primaryColor,
        title: 'Addresses Book',
      ),
      SettingItemModel(
        icon: Icons.refresh,
        iconColor: AppTheme.primaryColor,
        title: 'Status',
      ),
      SettingItemModel(
        icon: Icons.notifications,
        iconColor: AppTheme.primaryColor,
        title: 'Notification',
      ),
      SettingItemModel(
        icon: Icons.chat_bubble,
        iconColor: AppTheme.primaryColor,
        title: 'Chat settings',
      ),
      SettingItemModel(
        icon: Icons.storage,
        iconColor: AppTheme.primaryColor,
        title: 'Data and storage',
      ),
      SettingItemModel(
        icon: Icons.lock,
        iconColor: AppTheme.primaryColor,
        title: 'Privacy and security',
      ),
      SettingItemModel(
        icon: Icons.info,
        iconColor: AppTheme.primaryColor,
        title: 'About',
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
