import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/analytics/analytics_home.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/streak_provider.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation_preselect.dart';
import 'package:meditation_app_flutter/appearance/color_settings.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sound_settings.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing_preselect.dart';
import 'package:meditation_app_flutter/analytics/week_rating_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:meditation_app_flutter/providers/sound_provider.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/gong_provider.dart';
import 'package:meditation_app_flutter/meditation/meditation_session.dart';
import 'package:meditation_app_flutter/meditation/meditation_session_controller.dart';
import 'package:meditation_app_flutter/meditation/meditation.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late Future<void> _initFuture;
  late StreakProvider _streakProvider;
  late RatingsProvider _ratingsProvider;
  late ThemeProvider _themeProvider;
  late BackgroundSoundProvider _backgroundSoundProvider;
  late GongProvider _gongProvider;
  late SettingsProvider _settingsProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _ratingsProvider = Provider.of<RatingsProvider>(context, listen: false);
    _initFuture = _ratingsProvider.init();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _streakProvider = Provider.of<StreakProvider>(context, listen: false);
    _initFuture = _streakProvider.init();
    _backgroundSoundProvider =
        Provider.of<BackgroundSoundProvider>(context, listen: false);
    _initFuture = _backgroundSoundProvider.init();
    _gongProvider = Provider.of<GongProvider>(context, listen: false);
    _initFuture = _gongProvider.init();
  }

  final List<Widget> _widgetOptions = [
    HomeScreen(),
    DurationSuggestions(),
    AnalyticsScreen(),
    AnalyticsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Initialization is complete
          return Scaffold(
            extendBody: true,
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.self_improvement),
                  label: 'Meditation',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Learn',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Analytics',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white30,
              backgroundColor: Colors.black12,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: _onItemTapped,
            ),
          );
        } else {
          // Initialization in progress
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SelectedPeriod _selectedPeriod = SelectedPeriod.week;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final streakProvider = Provider.of<StreakProvider>(context);
    final currentStreak = streakProvider.streak;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: SizedBox(
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, right: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.music_note,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SoundSelectionScreen(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.settings, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ActualSettingsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 60.0),
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
                ],
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Current Streak: $currentStreak",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 5, left: 15), // Add space to the left
                    child: Text(
                      'Quickstart Session',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 100,
                ),
                child: FutureBuilder<List<MeditationSession>>(
                  future: MeditationSessionManager().loadSessions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white)); // Error text in white
                    } else if (snapshot.hasData) {
                      final sessions = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal, // Make it scroll horizontally
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          return Container(
                            width: 150,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0), // Space between items
                            decoration: BoxDecoration(
                              color: Colors.white24, // Background color for individual item
                              borderRadius: BorderRadius.circular(10), // Rounded corners for individual item
                            ),
                            child: ListTile(
                              title: Text('${session.duration} min',
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                  session.isBreathingExercise ? 'Breathing Exercise' : 'Simple Meditation',
                                  style: const TextStyle(color: Colors.white)),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, // Increase vertical padding to make the tile higher
                                horizontal: 16.0,
                              ),
                              leading: Icon(
                                session.isBreathingExercise ? Icons.air : Icons.self_improvement,
                                color: Colors.white, // Icon color
                              ),
                              onTap: () {
                                Provider.of<MeditationTimeProvider>(context, listen: false)
                                    .selectedMinute = session.duration;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MeditationScreen(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text('No recent sessions found',
                          style: TextStyle(color: Colors.white)); // Text in white
                    }
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
