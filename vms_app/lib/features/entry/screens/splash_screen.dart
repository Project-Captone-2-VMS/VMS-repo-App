import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vms_app/config/theme/app_theme.dart';
import 'package:vms_app/di/injection_container.dart';
import 'package:vms_app/features/auth/presentation/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _authCubit = sl<AuthCubit>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('token');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (refreshToken != null && rememberMe) {
      await _authCubit.getRefresh({'token': refreshToken});
    } else {
      Timer(const Duration(milliseconds: 1500), () {
        if (mounted) {
          context.go('/sign-in');
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: BlocListener<AuthCubit, AuthState>(
        bloc: _authCubit,
        listener: (context, state) {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state is AuthStateSuccess) {
                context.go('/home', extra: state.loginSuccess.token);
              } else {
                context.go('/sign-in');
              }
            });
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CustomPaint(
                          painter: CircleProgressPainter(
                            animation: _controller,
                            color: AppTheme.primaryColor,
                            backgroundColor: const Color.fromARGB(
                              255,
                              242,
                              242,
                              242,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const Image(
                          image: AssetImage('assets/images/logo_truck.png'),
                        ),
                      ),
                      const Positioned(
                        bottom: 25,
                        child: Text(
                          'VMS',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final Color backgroundColor;

  CircleProgressPainter({
    required this.animation,
    required this.color,
    required this.backgroundColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final backgroundPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 15.0;

    canvas.drawCircle(center, radius, backgroundPaint);
    final progressPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 15.0
          ..strokeCap = StrokeCap.round;

    final progressAngle = 2 * math.pi * animation.value;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return animation != oldDelegate.animation ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
