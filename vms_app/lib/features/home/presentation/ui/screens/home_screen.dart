import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:vms_app/features/home/presentation/ui/widgets/send_alert_widget.dart';

import '../widgets/menu_cards_widget.dart';

class Notification {
  final String type;
  final String title;
  final String content;

  Notification({
    required this.type,
    required this.title,
    required this.content,
  });
}

class TruckerHomeScreen extends StatefulWidget {
  const TruckerHomeScreen({super.key});

  @override
  State<TruckerHomeScreen> createState() => _TruckerHomeScreenState();
}

class _TruckerHomeScreenState extends State<TruckerHomeScreen> {
  final bloc = sl<HomeCubit>();
  final _logger = Logger();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int notificationCount = 0;
  List<Notification> notifications = [];
  String? token;
  String? fullName;
  String? username;
  StompClient? stompClient;

  String _currentAddress = "Fetching location...";
  bool _isLoading = true;
  bool _locationError = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _getCurrentLocation();
    _getInformation().then((_) => _connectWebSocket());
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
      },
    );

    if (Theme.of(context).platform == TargetPlatform.android) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _showNotification(
    String type,
    String title,
    String content,
  ) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'vms_channel_id',
          'VMS Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      notifications.length,
      title,
      content,
      platformChannelSpecifics,
      payload: type,
    );
  }

  Future<void> _getInformation() async {
    final pref = await SharedPreferences.getInstance();
    token = pref.getString('token');
    username = pref.getString('username');
    if (token == null) {
      _logger.e("Token Null");
    } else {
      bloc.getInformation(token!);
    }
  }

  void _connectWebSocket() {
    if (username == null) {
      _logger.e("Username Null, cannot connect WebSocket");
      Fluttertoast.showToast(
        msg: "Cannot connect to notifications: Username not found",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/ws',
        onConnect: _onConnected,
        onWebSocketError: (dynamic error) {
          _logger.e("WebSocket Error: $error");
          Fluttertoast.showToast(
            msg: "WebSocket connection failed",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        },
        onDisconnect: (_) {
          _logger.i("WebSocket Disconnected");
        },
      ),
    );

    stompClient?.activate();
  }

  void _onConnected(StompFrame frame) {
    stompClient?.subscribe(
      destination: "/user/$username/notifications",
      callback: (frame) {
        if (frame.body != null) {
          try {
            final notification = json.decode(frame.body!);
            final type = notification['type'] as String? ?? 'UNKNOWN';
            final title =
                notification['title'] as String? ?? 'Bạn có thông báo mới!';
            final content =
                notification['content'] as String? ?? 'No content provided';
            setState(() {
              notifications.add(
                Notification(type: type, title: title, content: content),
              );
              notificationCount = notifications.length;
            });
            _showNotification(type, title, content);
            if (type == 'SYSTEM') {
              Fluttertoast.showToast(
                msg: title,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            } else if (type == 'USER') {
              Fluttertoast.showToast(
                msg: "Bạn có tin nhắn mới!",
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              );
            } else if (type == 'ALERT') {
              Fluttertoast.showToast(
                msg: "Cảnh báo: $title",
                backgroundColor: Colors.red,
                textColor: Colors.yellow,
              );
            }
          } catch (e) {
            _logger.e("Error parsing notification: $e");
            Fluttertoast.showToast(
              msg: "Invalid notification format",
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        }
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = false;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = "Dehradun, India";
          _errorMessage =
              "Location services are disabled. Please enable location services.";
          _locationError = true;
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = "Dehradun, India";
            _errorMessage = "Location permissions denied.";
            _locationError = true;
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress = "Dehradun, India";
          _errorMessage = "Location permissions permanently denied.";
          _locationError = true;
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 15),
      ).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException("Location request timed out.");
        },
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = place.street ?? "Dehradun, India";
          _isLoading = false;
          _locationError = false;
        });
      } else {
        setState(() {
          _currentAddress = "Location unknown";
          _errorMessage = "Could not determine location name.";
          _locationError = true;
          _isLoading = false;
        });
      }
    } on TimeoutException {
      setState(() {
        _currentAddress = "Location unknown";
        _errorMessage = "Location request timed out.";
        _locationError = true;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<HomeCubit, HomeState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is HomeStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error with get information')),
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
                setState(() {
                  username = data.username;
                });
              });
              fullName = "${data.lastName} ${data.firstName}";
            }
            return Scaffold(
              body: SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      floating: false,
                      pinned: true,
                      expandedHeight: 270,
                      backgroundColor: AppTheme.primaryColor,
                      title: Row(
                        children: [
                          const Icon(
                            Icons.menu_open_sharp,
                            color: Colors.white,
                            size: 30,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Current Address',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _isLoading
                                          ? "Fetching..."
                                          : _currentAddress,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 30,
                                ),
                                if (_locationError)
                                  IconButton(
                                    icon: const Icon(Icons.refresh, size: 22),
                                    onPressed: _getCurrentLocation,
                                    tooltip: 'Retry',
                                    padding: const EdgeInsets.all(4),
                                    color: Colors.white,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/trucks_background.png',
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'WELCOME',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Trucker $fullName',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        notificationCount = 0;
                                        notifications.clear();
                                      });
                                      context.push('/notification');
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Icon(
                                          Icons.notifications,
                                          color: Color.fromARGB(
                                            255,
                                            249,
                                            146,
                                            43,
                                          ),
                                          size: 25,
                                        ),
                                        if (notificationCount > 0)
                                          Positioned(
                                            right: -5,
                                            top: -5,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$notificationCount',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([MenuCardsWidget()]),
                    ),
                    SliverFillRemaining(
                      child: SingleChildScrollView(
                        child: Center(child: SendAlertWidget()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
