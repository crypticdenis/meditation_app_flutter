import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sound_settings.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing.dart';
// import 'package:meditation_app_flutter/common_definitions.dart';

class DurationSuggestions extends StatelessWidget {
  final List<int> suggestedDurations = [5, 10, 20];

  DurationSuggestions({Key? key}) : super(key: key);

  Widget _buildIconButton(
      BuildContext context, IconData iconData, Widget destination) {
    return IconButton(
      icon: Icon(iconData, color: Colors.white),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => destination)),
    );
  }

  Widget _buildDurationButton(BuildContext context, int? duration,
      {required Widget destination}) {
    final buttonText = duration != null ? '$duration min' : '+';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 105,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
          onPressed: () {
            // Update the selectedMinute with duration if not null, otherwise set to 0
            final selectedMinute = duration ?? 0; // Set to 0 if duration is null (i.e., '+' button pressed)
            Provider.of<MeditationTimeProvider>(context, listen: false).selectedMinute = selectedMinute;

            // Then navigate to the destination screen
            Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
          },
          child: Text(buttonText,
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }



  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
        child: Text(title,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildDurationsRow(BuildContext context,
      {required bool isMeditation}) {
    final Widget destinationScreen =
        isMeditation ? MeditationScreen() : BreathingScreen();
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: suggestedDurations.length + 1, // Including the "+" button
        itemBuilder: (context, index) {
          return index < suggestedDurations.length
              ? _buildDurationButton(context, suggestedDurations[index],
                  destination: destinationScreen)
              : _buildDurationButton(context, null,
                  destination: destinationScreen);
        },
      ),
    );
  }

  final List<Map<String, String>> sessionAssets = [
    {'image': 'assets/images/nature1.png', 'title': 'Relaxation', 'duration': '6 min'},
    {'image': 'assets/images/nature2.png', 'title': 'Deep Sleep', 'duration': '9 min'},
    {'image': 'assets/images/nature3.png', 'title': 'Anxiety Relief', 'duration': '5 min'},
  ];

  Widget _buildImageInfoRow() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: sessionAssets.length,
        itemBuilder: (context, index) {
          final session = sessionAssets[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                // Handle your onTap action here
              },
              child: Container(
                width: 240, // Set a fixed width for the container
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand, // Make the stack fill the container
                    children: [
                      Image.asset(
                        session['image']!,
                        fit: BoxFit.cover, // This ensures the image covers the whole area of the container
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5), // Semi-transparent black
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 30, // Adjust the position as needed
                        child: Text(
                          session['title']!,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8, // Adjust the position so it's just below the title
                        child: Text(
                          "${session['duration']} min", // Assuming 'duration' is a key in your session map
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(gradient: themeProvider.currentGradient),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildIconButton(context, Icons.music_note,
                                SoundSelectionScreen()),
                            _buildIconButton(
                                context, Icons.settings, ActualSettingsScreen()),
                          ],
                        ),
                      ),
                      _buildSectionHeader('Meditation Timer'),
                    ],
                  ),
                  _buildDurationsRow(context, isMeditation: true),
                  _buildSectionHeader('Guided Meditation'),
                  _buildImageInfoRow(),
                  _buildSectionHeader('Breathing Timer'),
                  _buildDurationsRow(context, isMeditation: false),
                  _buildSectionHeader('Guided Breathing'),
                  _buildImageInfoRow(),
                  SizedBox( height: 200),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
