import 'package:app_flutter_map/markers/end_marker.dart';
import 'package:app_flutter_map/markers/start_marker.dart';
import 'package:flutter/material.dart';

class TestMarkerScreen extends StatelessWidget {
  const TestMarkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          width: 250,
          height: 150,
          child: CustomPaint(
            painter: EndMarkerPainter(
              destination: 'Mi Casa 23', 
              kilometers: 86
            ),
          ),
        ),
      ),
    );
  }
}