import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../custom_time_wheel.dart';
import 'sounds.dart';
import '../custom_app_bar.dart';
import '../providers/theme_provider.dart';

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
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Soundscape enabled',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Switch(
                    value: soundProvider.soundEnabled,
                    onChanged: (bool value) {
                      soundProvider.toggleSoundEnabled();
                    },
                    activeColor: Colors.black,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: CustomTimeWheel(
                  itemCount: BackgroundsSounds.names.length,
                  selectedValue: soundProvider.currentSoundIndex,
                  onSelectedItemChanged: (index) =>
                      soundProvider.setSound(index),
                  mode: WheelMode.sounds,
                  colorNames: BackgroundsSounds.names,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
