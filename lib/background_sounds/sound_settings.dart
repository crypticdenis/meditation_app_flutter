import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../custom_time_wheel.dart';
import 'sounds.dart';
import '../custom_app_bar.dart';
import '../providers/theme_provider.dart';
import '../providers/gong_provider.dart';
import 'package:meditation_app_flutter/gong/gongs.dart';
import 'package:meditation_app_flutter/common_definitions.dart';

class SoundSelectionScreen extends StatelessWidget {
  const SoundSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<BackgroundSoundProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: '',
        showSettingsButton: false,
        showSoundSettingsButton: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                alignment: Alignment.center, // Ensures the text is centered
                children: [
                  buildSectionHeader('Soundscapes'),
                  Align(
                    alignment: Alignment.centerRight, // Aligns the switch to the right
                    child: Switch(
                      value: soundProvider.soundEnabled,
                      onChanged: (bool value) {
                        soundProvider.toggleSoundEnabled();
                      },
                      activeColor: Colors.black,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(20), // Rounded edges
                  ),
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 30),
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
            ),
          ],
        ),
      ),
    );
  }
}
