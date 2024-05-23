import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../custom_app_bar.dart';
import '../providers/theme_provider.dart';
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
                alignment: Alignment.center,
                children: [
                  buildSectionHeader('Soundscapes'),
                  Align(
                    alignment: Alignment.centerRight,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: soundProvider.soundNames.length,
                    itemBuilder: (context, index) {
                      final soundName = soundProvider.soundNames[index];
                      final isSelected = index == soundProvider.currentSoundIndex;
                      return GestureDetector(
                        onTap: () => soundProvider.setSound(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blueAccent : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              soundName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
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
