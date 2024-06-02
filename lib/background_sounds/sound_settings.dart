import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sound_provider.dart';
import '../providers/theme_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/Profile/sign_in.dart';

class SoundSelectionScreen extends StatelessWidget {
  const SoundSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Future<bool> _onWillPop(BuildContext context) async {
      final soundProvider =
          Provider.of<BackgroundSoundProvider>(context, listen: false);

      if (soundProvider.isRestrictedSoundPlayed &&
          !soundProvider.isAuthenticated) {
        final result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sign In Required'),
            content: Text('Sign in now to unlock this sound.'),
            actions: [
              TextButton(
                onPressed: () {
                  if (soundProvider.soundEnabled) {
                    soundProvider.toggleSoundEnabled();
                  }
                  soundProvider.stopPlayingRestrictedSound();
                  Navigator.of(context).pop(true); // Close the dialog
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SignInScreen(
                      onLoginSuccess: () {
                        final soundProvider =
                            Provider.of<BackgroundSoundProvider>(context,
                                listen: false);
                        if (!soundProvider.soundEnabled) {
                          soundProvider.toggleSoundEnabled();
                        }
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                    ),
                  );
                },
                child: Text('Sign In'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
        return result ?? false;
      } else {
        Navigator.of(context).pop();
        return true;
      }
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.currentGradient,
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _onWillPop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    buildSectionHeader('Soundscapes'),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Consumer<BackgroundSoundProvider>(
                        builder: (context, soundProvider, child) {
                          return Switch(
                            value: soundProvider.soundEnabled,
                            onChanged: (bool value) {
                              soundProvider.toggleSoundEnabled();
                            },
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    child: GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: Provider.of<BackgroundSoundProvider>(context)
                            .soundData
                            .length,
                        itemBuilder: (context, index) {
                          final soundProvider =
                              Provider.of<BackgroundSoundProvider>(context);
                          final sound = soundProvider.soundData[index];
                          final soundName = sound['name'];
                          final isSelected =
                              index == soundProvider.currentSoundIndex;
                          final imageUrl = soundProvider
                              .imageUrls[index]; // Use converted HTTP URL
                          final isRestricted = sound['restricted'];
                          final isAuthenticated = soundProvider.isAuthenticated;

                          return GestureDetector(
                            onTap: () => soundProvider.setSound(index),
                            child: Opacity(
                              opacity: isSelected ? 1.0 : 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ShaderMask(
                                        shaderCallback: (rect) {
                                          return LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black,
                                            ],
                                            stops: [
                                              0.5,
                                              1,
                                            ], // Adjust this line to start the fade higher
                                          ).createShader(rect);
                                        },
                                        blendMode: BlendMode.darken,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
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
                                    if (isRestricted && !isAuthenticated)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
