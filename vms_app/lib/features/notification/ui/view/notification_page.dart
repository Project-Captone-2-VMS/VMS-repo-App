import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/notification/notification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final bloc = sl<NotificationCubit>();
  final _logger = Logger();
  String? token;
  String? username;

  @override
  void initState() {
    super.initState();
    _getInformation();
  }

  Future<void> _getInformation() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    username = pref.getString('username');
    if (token == null || username == null) {
      _logger.e("Token or Username Null");
    } else {
      bloc.getNotify(username!, token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Notifications',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationStateError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is NotificationStateSuccess) {
              final notifications = state.success.reversed.toList();

              if (notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.grey,
                                size: 30,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Notifications',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'We\'ll let you know when there will be something to update you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  IconData icon;
                  Color iconColor;
                  switch (notification.notification?.type) {
                    case NotificationType.system:
                      icon = Icons.info_outline;
                      iconColor = Colors.green;
                      break;
                    case NotificationType.user:
                      icon = Icons.message_outlined;
                      iconColor = Colors.blue;
                      break;
                    case NotificationType.alert:
                      icon = Icons.warning_amber_outlined;
                      iconColor = Colors.red;
                      break;
                    case null:
                      icon = Icons.notifications_outlined;
                      iconColor = Colors.grey;
                      break;
                  }

                  final isRead = notification.notification?.read ?? false;
                  final title = notification.notification?.title ?? 'No title';
                  final content =
                      notification.notification?.content ?? 'No content';
                  final createdAt = notification.notification?.createdAt;
                  final time =
                      createdAt != null
                          ? DateFormat('HH:mm:ss dd/MM/yyyy').format(createdAt)
                          : '';

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isRead ? Colors.grey[100] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: iconColor.withOpacity(0.1),
                        child: Icon(icon, color: iconColor, size: 24),
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing:
                          !isRead
                              ? Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              )
                              : null,
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('No notifications available'));
          },
        ),
      ),
    );
  }
}
