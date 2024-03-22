import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/Sleep.dart';
import 'package:meditation_app_flutter/breathing.dart';
import 'home_screen_buttons.dart';
import 'meditation.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'gong_settings.dart';
import 'providers/streak_provider.dart'; // Import the streak provider

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<HomeScreenButton> menuItems = [
    const HomeScreenButton(title: 'Meditation', icon: Icons.spa),
    const HomeScreenButton(title: 'Breathing', icon: Icons.wb_sunny),
    const HomeScreenButton(title: 'Learn', icon: Icons.school),
    const HomeScreenButton(title: 'Sleep', icon: Icons.nightlight_round),
    const HomeScreenButton(title: 'Settings', icon: Icons.settings),
    const HomeScreenButton(title: 'Music', icon: Icons.music_note),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final streakProvider = Provider.of<StreakProvider>(context); // Access the streak provider
    final currentStreak = streakProvider.streak; // Get the current streak

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: SafeArea(
          // Move SafeArea to encompass everything
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align items to the start
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 24.0),
                // Padding for left alignment and lower position
                child: Text(
                  'Welcome Back, Denis!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // Make children stretch horizontally
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Current Streak: $currentStreak", // Display the current streak
                          style: TextStyle(color: Colors.white, fontSize: 24)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  children: menuItems
                      .map((button) => Card(
                    color: Colors.black.withOpacity(0.2),
                    margin: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () => _handleButtonTap(button.title),
                        // Example navigation
                        child: button),
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleButtonTap(String buttonTitle) {
    switch (buttonTitle) {
      case 'Meditation':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const MeditationScreen(), // Navigate to Meditation Screen
          ),
        );
        break;
    // Add other cases for different buttons here

      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const SettingsScreen(), // Navigate to Settings Screen
          ),
        );
        break;
      case 'Breathing':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const BreathingScreen(), // Navigate to Settings Screen
          ),
        );
        break;

      case 'Sleep':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const SleepScreen(), // Navigate to Settings Screen
          ),
        );
        break;
      case 'Music':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const GongSelectionScreen(), // Navigate to Settings Screen
          ),
        );
        break;
      default:
      // Handle if the title doesn't match a known screen
        break;
    }
  }
}

