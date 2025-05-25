import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/features/home/home.dart';

import '../../../../../di/injection_container.dart';
import '../widgets/profile_header.dart';
import '../widgets/settings_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final bloc = sl<HomeCubit>();
  final _logger = Logger();
  String? token;
  String fullName = '';
  Result? dataRes;

  @override
  void initState() {
    super.initState();
    _getInformation();
  }

  Future<void> _getInformation() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    if (token == null) {
      _logger.e("Token Null");
    } else {
      bloc.getInformation(token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile', style: AppTextStyles.appbarText),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.customRed),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          final data = {'token': token};
                          bloc.logout(data);
                        },
                        child: const Text(
                          'Yes,I am sure',
                          style: TextStyle(color: AppTheme.customRed),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocListener<HomeCubit, HomeState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is HomeStateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error with get information')),
              );
            } else if (state is HomeStateLogoutSuccess) {
              SharedPreferences.getInstance().then((pref) {
                pref.remove('token');
                pref.remove('username');
              });
              context.go('/sign-in');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            }
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is HomeStateSuccess) {
                final data = state.success;
                SharedPreferences.getInstance().then((pref) {
                  pref.setString('username', data.username);
                });
                fullName = "${data.lastName} ${data.firstName}";
                dataRes = data;
              }
              return Column(
                children: [
                  ProfileHeader(
                    name: fullName,
                    bio: 'Tin vào cảm xúc của bạn, hãy là một con người tốt',
                    avatarUrl:
                        'https://static.vecteezy.com/system/resources/thumbnails/046/463/338/small/happy-young-man-celebrating-with-fists-raised-on-transparent-background-png.png',
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.grey[300]),
                  SettingsList(data: dataRes),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
