import 'package:flutter/material.dart';

void main() {
  runApp(const TheorieZoneApp());
}

class TheorieZoneApp extends StatelessWidget {
  const TheorieZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TheorieZone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('TheorieZone App - Placeholder')),
      ),
    );
  }
}
