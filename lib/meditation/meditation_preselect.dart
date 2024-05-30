import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/meditation/meditation.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/background_sounds/sound_settings.dart';
import 'package:meditation_app_flutter/meditation/breathing/breathing.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'breathing/4_7_8.dart';
import 'breathing/box_breathing.dart'; // Import the BoxedBreathingScreen

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

  Widget _buildHorizontalScroll(BuildContext context, bool isMeditation) {
    final Widget destinationScreen =
        isMeditation ? const MeditationScreen() : const BreathingScreen();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: List.generate(suggestedDurations.length + 1, (index) {
          return _buildDurationButton(
            context,
            index < suggestedDurations.length
                ? suggestedDurations[index]
                : null,
            destination: destinationScreen,
            iconData: isMeditation ? Icons.self_improvement : Icons.air,
            isMeditation: isMeditation,
          );
        }),
      ),
    );
  }

  Widget _buildDurationButton(BuildContext context, int? duration,
      {required Widget destination,
        required bool isMeditation,
        IconData? iconData}) {
    final buttonText = duration != null ? '$duration min' : '+';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: 160, // Set this to your desired size
        height: 160, // Set this to your desired size
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
            print('Selected duration: $selectedMinute'); // Debug log
            Provider.of<MeditationTimeProvider>(context, listen: false)
                .selectedMinute = selectedMinute;
            print('Provider duration: ${Provider.of<MeditationTimeProvider>(context, listen: false).selectedMinute}'); // Debug log
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => destination));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconData != null)
                Icon(iconData, color: Colors.white, size: 40.0),
              Text(buttonText,
                  style: const TextStyle(fontSize: 25, color: Colors.white)),
              if (duration != null)
                Text(
                  isMeditation ? 'Simple Meditation' : 'Breathing Exercise',
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 7.5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            backgroundColor: themeProvider.currentGradient.colors.first,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Practice',
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/zenbowl.png', // Path to the image asset
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black12, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  decoration: BoxDecoration(
                    gradient: themeProvider.currentGradient,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSectionHeader('Meditation Timer'),
                        _buildHorizontalScroll(context, true),
                        buildSectionHeader('Breathing Timer'),
                        _buildHorizontalScroll(context, false),
                        buildSectionHeader('Other Exercises'),
                        _buildOtherExercisesButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherExercisesButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildSpecificExerciseButton(
          context,
          '4-7-8 Exercise',
          Icons.fitness_center,
          const fourseveneigthScreen(),
        ),
        _buildSpecificExerciseButton(
          context,
          'Boxed Breathing',
          Icons.crop_square,
          const BoxedBreathingScreen(),
        ),
      ],
    );
  }

  Widget _buildSpecificExerciseButton(
      BuildContext context, String text, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        width: 160, // Set this to your desired size
        height: 160, // Set this to your desired size
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white30,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 40.0),
              Text(
                text,
                style: const TextStyle(fontSize: 25, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
