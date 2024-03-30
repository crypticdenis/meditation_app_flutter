import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/streak_provider.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation_preselect.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:meditation_app_flutter/appearance/color_settings.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sound_settings.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing_preselect.dart';
import 'package:meditation_app_flutter/home/week_rating_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:meditation_app_flutter/providers/sound_provider.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:meditation_app_flutter/meditation/monthly_ratings.dart';

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


  @override
  void initState() {
    super.initState();
    _ratingsProvider = Provider.of<RatingsProvider>(context, listen: false);
    _initFuture = _ratingsProvider.init();
    _streakProvider = Provider.of<StreakProvider>(context, listen: false);
    _initFuture = _streakProvider.init();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BackgroundSoundProvider>(context, listen: false)
          .initializeAndPlayLoop();
    });
  }

  final List<Widget> _widgetOptions = [
    HomeScreen(), // This is the actual home screen with the streak
    DurationSuggestions(), // Placeholder for the meditation screen
    BreathingPreselect(), // Placeholder for the breathing screen
    SettingsScreen(), // Placeholder for the settings screen
    // Add more screens here if necessary
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
          // Your initialization is complete, build your widget here
          return Scaffold(
            extendBody: true,
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.transparent,
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15),
                  child: GNav(
                    rippleColor: Colors.red,
                    hoverColor: Colors.red,
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: Colors.white12,
                    color: Colors.white,
                    tabs: [
                      GButton(
                        icon: Icons.home,
                        text: 'Home',
                        textColor: Colors.white,
                      ),
                      GButton(
                        icon: Icons.spa,
                        text: 'Meditation',
                        textColor: Colors.white,
                      ),
                      GButton(
                        icon: Icons.person,
                        text: 'Breathing',
                        textColor: Colors.white,
                      ),
                      GButton(
                        icon: Icons.book,
                        text: 'Learn',
                        textColor: Colors.white,
                      ),
                      // Add more GButton items here
                    ],
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          // Initialization in progress
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final streakProvider = Provider.of<StreakProvider>(context);
    final currentStreak = streakProvider.streak;


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              themeProvider.currentGradient, // Ensure themeProvider is defined
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.music_note, color: Colors.white),
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
                          icon: const Icon(Icons.settings, color: Colors.white),
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
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Current Streak: $currentStreak",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only( top: 15.0),
              child: Text(
                'Weekly Ratings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.center, // Customize alignment as needed
              child: WeekRatingWidget(),
            ),
            const Padding(
              padding: EdgeInsets.only( top: 15.0),
              child: Text(
                'Monthly Ratings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.center, // Customize alignment as needed
              child: MonthRatingWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
