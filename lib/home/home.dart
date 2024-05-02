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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 45.0),
                    child: Row(
                      children: [
                        buildSectionHeader('Welcome Back!'),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Streak: $currentStreak ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
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
                      return Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!['quote']!,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                snapshot.data!['author']!,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                ),
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
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}',
                                style: const TextStyle(
                                    color:
                                        Colors.white)); // Error text in white
                          } else if (snapshot.hasData) {
                            final sessions = snapshot.data!;
                            // If you always want exactly 4 sessions:
                            sessions.sort((a, b) => a.duration.compareTo(
                                b.duration)); // Sort sessions by duration
                            List<MeditationSession> uniqueSessions = sessions
                                .take(4)
                                .toList(); // Take only the first 4 sessions

                            return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 15.0,
                                mainAxisSpacing: 15.0,
                                childAspectRatio:
                                    (2 / 1), // Aspect ratio for square items
                              ),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: uniqueSessions.length,
                              itemBuilder: (context, index) {
                                final session = uniqueSessions[index];
                                final Widget destinationScreen = session
                                        .isBreathingExercise
                                    ? const BreathingScreen()
                                    : const MeditationScreen(); // Destination screen based on session type
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white30,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text('${session.duration} min',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    subtitle: Text(
                                        session.isBreathingExercise
                                            ? 'Breathing Exercise'
                                            : 'Simple Meditation',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    leading: Icon(
                                      session.isBreathingExercise
                                          ? Icons.air
                                          : Icons.self_improvement,
                                      color: Colors.white,
                                    ),
                                    onTap: () {
                                      // Set the selected session duration in a provider before navigating
                                      Provider.of<MeditationTimeProvider>(
                                              context,
                                              listen: false)
                                          .selectedMinute = session.duration;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                destinationScreen),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text('No recent sessions found',
                                style: TextStyle(
                                    color: Colors.white)); // Text in white
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
