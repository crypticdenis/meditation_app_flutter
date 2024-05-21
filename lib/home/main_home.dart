import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'package:meditation_app_flutter/providers/breathing_rhythm_provider.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/streak_provider.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation_preselect.dart';
import 'package:meditation_app_flutter/providers/sound_provider.dart';
import 'home.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:meditation_app_flutter/providers/gong_provider.dart';
import 'package:meditation_app_flutter/Profile/ProfileScreen.dart'; // Correct import path
import 'package:meditation_app_flutter/learn/learn.dart';

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
  late BreathingSettingsProvider _breathprovider;
  User? _user;

  @override
  void initState() {
    super.initState();
    _breathprovider = Provider.of<BreathingSettingsProvider>(context, listen: false);
    _initFuture = _breathprovider.init();
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
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  final List<Widget> _widgetOptions = [
    HomeScreen(),
    DurationSuggestions(),
    Profile(), // Reference the Profile screen directly
    Learn(),
    ActualSettingsScreen(),
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
            bottomNavigationBar: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return BottomNavigationBar(
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
                      icon: Icon(Icons.person),
                      label: 'Profile',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      label: 'Learn',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white30,
                  backgroundColor: themeProvider.currentGradient.colors.last,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0,
                  onTap: _onItemTapped,
                );
              },
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
