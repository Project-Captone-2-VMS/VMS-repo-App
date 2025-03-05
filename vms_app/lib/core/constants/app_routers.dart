import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vms_app/presentation/screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [GoRoute(path: '/home', builder: (context, state) => HomeScreen())],
  );
}
