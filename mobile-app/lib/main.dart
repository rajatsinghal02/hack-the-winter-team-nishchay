import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart'; // Import the screen

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final savedPilotId = prefs.getString('user_pilot_id');

  runApp(RovApp(savedPilotId: savedPilotId));
}

class RovApp extends StatelessWidget {
  final String? savedPilotId;

  const RovApp({super.key, this.savedPilotId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROV Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(
          0xFF050916,
        ), // Dark Blue/Black background
        brightness: Brightness.dark,
        fontFamily: 'Arial',
      ),
      home: savedPilotId != null
          ? MainScreen(pilotId: savedPilotId!)
          : const OnboardingScreen(),
    );
  }
}
