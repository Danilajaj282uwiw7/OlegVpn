import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const OlegVPNApp());
}

class OlegVPNApp extends StatelessWidget {
  const OlegVPNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OlegVPN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
      ),
      home: const HomeScreen(),
    );
  }
}
