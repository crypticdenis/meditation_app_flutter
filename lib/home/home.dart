import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/analytics/analytics_home.dart';
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
import '../analytics/monthly_ratings.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import '../analytics/yearly_rating.dart';

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

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
                  icon: Icon(Icons.spa),
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

    print(streakProvider.streak);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              themeProvider.currentGradient,

        ),
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
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Current Streak: $currentStreak",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Ratings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            ToggleButtons(
              borderColor: Colors.transparent,
              borderWidth: 2,
              selectedBorderColor: Colors.transparent,
              selectedColor: Colors.white,
              color: Colors.white30,
              fillColor: Colors.white12,
              borderRadius: BorderRadius.circular(20),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('W'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('M'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('Y'),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  if (index == 0) {
                    _selectedPeriod = SelectedPeriod.week;
                  } else if (index == 1) {
                    _selectedPeriod = SelectedPeriod.month;
                  } else {
                    _selectedPeriod = SelectedPeriod.year;
                  }
                });
              },
              isSelected: [
                _selectedPeriod == SelectedPeriod.week,
                _selectedPeriod == SelectedPeriod.month,
                _selectedPeriod == SelectedPeriod.year,
              ],
            ),

            // Fixed conditional rendering
            SizedBox(
              child: _selectedPeriod == SelectedPeriod.week
                  ? WeekRatingWidget()
                  : (_selectedPeriod == SelectedPeriod.month
                      ? MonthRatingWidget()
                      : YearRatingWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
