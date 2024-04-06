import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/background_sounds/sound_settings.dart';
import 'package:meditation_app_flutter/meditation/breathing/breathing.dart';
import 'package:meditation_app_flutter/common_definitions.dart';

class DurationSuggestions extends StatelessWidget {
  final List<int> suggestedDurations = [5, 10, 20];

  DurationSuggestions({super.key});

  Widget _buildIconButton(
      BuildContext context, IconData iconData, Widget destination) {
    return IconButton(
      icon: Icon(iconData, color: Colors.white),
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => destination)),
    );
  }

  Widget _buildDurationsGrid(BuildContext context,
      {required bool isMeditation}) {
    final Widget destinationScreen =
        isMeditation ? const MeditationScreen() : const BreathingScreen();

    int crossAxisCount = 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: const EdgeInsets.all(15.0),
      childAspectRatio: 2 / 1,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(suggestedDurations.length + 1, (index) {
        return _buildDurationButton(
          context,
          index < suggestedDurations.length ? suggestedDurations[index] : null,
          destination: destinationScreen,
          iconData: isMeditation ? Icons.self_improvement : Icons.air,
          isMeditation: isMeditation, // Pass the isMeditation parameter
        );
      }),
    );
  }

  Widget _buildDurationButton(BuildContext context, int? duration,
      {required Widget destination,
      required bool isMeditation,
      IconData? iconData}) {
    final buttonText = duration != null ? '$duration min' : '+';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white30,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            final selectedMinute = duration ?? 0;
            Provider.of<MeditationTimeProvider>(context, listen: false)
                .selectedMinute = selectedMinute;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => destination));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // To keep the icon and text close together
            children: [
              if (iconData != null)
                Icon(iconData, color: Colors.white, size: 24.0), // The icon
              Text(buttonText,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
              if (duration != null)
                Text(
                  isMeditation ? 'Simple Meditation' : 'Breathing Exercise',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeProvider.currentGradient),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 50.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildIconButton(context, Icons.music_note,
                              const SoundSelectionScreen()),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45),
                    child: buildSectionHeader('Practice'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionHeader('Meditation Timer'),
                    _buildDurationsGrid(context, isMeditation: true),
                    buildSectionHeader('Breathing Timer'),
                    _buildDurationsGrid(context, isMeditation: false),
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
