import 'package:flutter/material.dart';
import 'home/home.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyArYkJDXLe559FpwXl0HoL-7sUFwSN1Vc4",
      appId: "1:268853907281:android:51508d9d003b6d93a9cd70",
      messagingSenderId: "268853907281",
      projectId: "meditation-6f139",
      storageBucket: "meditation-6f139.appspot.com",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BackgroundSoundProvider()),
        ChangeNotifierProvider(create: (context) => RatingsProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        ChangeNotifierProvider(create: (context) => ScrollWheelIndexProvider()),
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
