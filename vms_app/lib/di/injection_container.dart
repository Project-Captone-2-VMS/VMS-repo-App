import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  // Register external dependencies here

  // Core
  // Register core dependencies here

  // Features
  // Register feature-specific dependencies here

  // Initialize any async dependencies
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('Dependency injection initialized');
}
