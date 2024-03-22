import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/sound_provider.dart';
import 'custom_time_wheel.dart';
import 'sounds.dart';
import 'app_bar.dart';
import 'providers/theme_provider.dart';

class SoundSelectionScreen extends StatelessWidget {
  const SoundSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<BackgroundSoundProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Sound settings'),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Center(
          child: CustomTimeWheel(
            itemCount: BackgroundsSounds.names.length,
            selectedValue: soundProvider.currentSoundIndex,
            onSelectedItemChanged: (index) => soundProvider.setSound(index),
            mode: WheelMode.sounds,
            // Assuming WheelMode has a text option.
            colorNames: BackgroundsSounds.names, // Provide the list of gong names.
          ),
        ),
      ),
    );
  }
}