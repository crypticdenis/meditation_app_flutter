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
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: soundProvider.soundNames.length,
                    itemBuilder: (context, index) {
                      final soundName = soundProvider.soundNames[index];
                      final isSelected =
                          index == soundProvider.currentSoundIndex;
                      final imageUrl =
                          soundProvider.imageUrls[index]; // Get the image URL
                      return GestureDetector(
                        onTap: () => soundProvider.setSound(index),
                        child: Opacity(
                          opacity: isSelected ? 1.0 : 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      soundName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
