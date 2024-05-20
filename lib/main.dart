import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/providers/breathing_rhythm_provider.dart';
import 'home/main_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/timer_provider.dart';
import 'providers/gong_provider.dart';
import 'providers/meditation_time_provider.dart';
import 'providers/streak_provider.dart';
import 'providers/sound_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/ratings_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // Commented out

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BackgroundSoundProvider()),
        ChangeNotifierProvider(create: (context) => RatingsProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ScrollWheelIndexProvider()),
        ChangeNotifierProvider(
            create: (context) => BreathingSettingsProvider()),
        ChangeNotifierProvider(create: (context) => StreakProvider()),
        ChangeNotifierProvider(create: (context) => GongProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MeditationTimeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
