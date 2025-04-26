import 'package:firebase_core/firebase_core.dart'; // Thêm import này
import 'package:flutter/material.dart';
import 'package:vms_app/bootstrap.dart';
import 'package:vms_app/di/injection_container.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await bootstrap(() async {
    await ProductionServiceLocator().setup();
    return const MyApp();
  });
}
