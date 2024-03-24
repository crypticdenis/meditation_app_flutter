import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/sleep/sleep.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing.dart';
import '../home/home_screen_buttons.dart';
import '../meditation/meditation.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../appearance/color_settings.dart';
import '../gong_feature/gong_settings.dart';
import '../providers/streak_provider.dart';
import '../providers/sound_provider.dart';
import '../background_sounds_feature/sound_settings.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';

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
    const HomeScreenButton(title: 'Backgrounds', icon: Icons.palette),
    const HomeScreenButton(title: 'Gongs', icon: Icons.rice_bowl),
    const HomeScreenButton(title: 'Soundscape', icon: Icons.headphones),
    const HomeScreenButton(title: 'Settings', icon: Icons.settings),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BackgroundSoundProvider>(context, listen: false)
          .initializeAndPlayLoop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final streakProvider = Provider.of<StreakProvider>(context);
    final currentStreak = streakProvider.streak;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 24.0),
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Current Streak: $currentStreak",
                          style: const TextStyle(color: Colors.white, fontSize: 24)),
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
            builder: (context) => const MeditationScreen(),
          ),
        );
        break;

      case 'Backgrounds':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SettingsScreen(),
          ),
        );
        break;
      case 'Breathing':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BreathingScreen(),
          ),
        );
        break;
      case 'Gongs':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GongSelectionScreen(),
          ),
        );
        break;
      case 'Soundscape':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SoundSelectionScreen(),
          ),
        );
        break;
      case 'Settings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ActualSettingsScreen(),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    Provider.of<BackgroundSoundProvider>(context, listen: false).stop();
    super.dispose();
  }
}
