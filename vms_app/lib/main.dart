import 'package:flutter/material.dart';
import 'package:vms_app/presentation/screens/map/map_test_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OSM Test App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MapTestScreen(),
    );
  }
}
