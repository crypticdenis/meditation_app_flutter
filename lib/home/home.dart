import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/streak_provider.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/background_sounds/sound_settings.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/meditation/meditation_session_controller.dart';
import 'package:meditation_app_flutter/meditation/breathing/breathing.dart';
import 'package:meditation_app_flutter/meditation/meditation.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/Profile/ProfileScreen.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                            icon: const Icon(Icons.music_note, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SoundSelectionScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Row(
                      children: [
                        buildSectionHeader('Welcome Back!'),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FutureBuilder<Map<String, String>>(
                  future: getRandomQuote(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      String quote = snapshot.data!['quote']!;
                      String author = snapshot.data!['author']!;
                      return Container(
                        padding: const EdgeInsets.only(top: 15, left: 15.0, right: 15),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quote,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    author,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white70,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.ios_share, color: Colors.white),
                                    onPressed: () {
                                      Share.share('$quote - $author');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Text('No quote available');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Quickstart Session',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 2,
                      ),
                      child: FutureBuilder<List<MeditationSession>>(
                        future: MeditationSessionManager().getDiverseSessions(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white));
                          } else if (snapshot.hasData) {
                            final sessions = snapshot.data!;
                            sessions.sort((a, b) => a.duration.compareTo(b.duration));
                            List<MeditationSession> uniqueSessions = sessions.take(4).toList();

                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio: (2 / 1),
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: uniqueSessions.length,
                              itemBuilder: (context, index) {
                                final session = uniqueSessions[index];
                                final Widget destinationScreen = session.isBreathingExercise
                                    ? const BreathingScreen()
                                    : const MeditationScreen();
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text('${session.duration} min', style: const TextStyle(color: Colors.white)),
                                    subtitle: Text(
                                      session.isBreathingExercise ? 'Breathing Exercise' : 'Simple Meditation',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    leading: Icon(
                                      session.isBreathingExercise ? Icons.air : Icons.self_improvement,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      Provider.of<MeditationTimeProvider>(context, listen: false).selectedMinute = session.duration;
                                      print(Provider.of<MeditationTimeProvider>(context, listen: false).selectedMinute);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => destinationScreen),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text('No recent sessions found', style: TextStyle(color: Colors.white));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

