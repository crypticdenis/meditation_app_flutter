import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation.dart'; // Adjust the import path based on your project structure
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sound_settings.dart';

class DurationSuggestions extends StatelessWidget {
  final List<int> suggestedDurations = [
    5,
    10,
    20,
  ]; // Example durations in minutes

  DurationSuggestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60, left: 15, bottom: 15),
                    child: Text(
                      'Meditation Timer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 80,
              // Adjust the height to fit your design for the scrollable list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedDurations.length + 1,
                // +1 for the "+" button
                itemBuilder: (BuildContext context, int index) {
                  if (index == suggestedDurations.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 100, // Match the width of other buttons
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          onPressed: () {
                            // Navigate to the TimeSelectionScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MeditationScreen(),
                              ),
                            );
                          },
                          child: Icon(Icons.add,
                              color: Colors
                                  .black), // "+" icon, adjust color as necessary
                        ),
                      ),
                    );
                  } else {
                    // Regular duration button
                    int duration = suggestedDurations[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: 100, // Explicit width for consistency
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    16.0), // Maintain vertical padding for height
                          ),
                          onPressed: () {
                            Provider.of<MeditationTimeProvider>(context,
                                    listen: false)
                                .selectedMinute = duration;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MeditationScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '$duration min',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors
                                    .white), // Adjust text size and color as necessary
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
                  child: Text(
                    'Guided Sessions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
