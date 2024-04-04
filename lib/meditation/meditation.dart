import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/timer_feature/time_picker.dart';
import 'package:meditation_app_flutter/timer_feature/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/timer_feature/timer_and_picker_logic.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sound_settings.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'meditation_preselect.dart';
import 'meditation_session.dart';
import 'meditation_session_controller.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late TimerLogic timerLogic;
  TimerOperation _timerOperation = TimerOperation.reset;

  @override
  void initState() {
    super.initState();
    timerLogic = TimerLogic(
      context: context,
      onTimerOperationChange: (TimerOperation operation) {
        setState(() {
          _timerOperation = operation;
        });
      },
      onTimerComplete: () {
        print('Timer completed!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient:
              themeProvider.currentGradient, // Ensure themeProvider is defined
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _timerOperation == TimerOperation.reset
                        ? TimePicker(
                            initialMinute:
                                meditationTimeProvider.selectedMinute,
                            onTimeSelected: timerLogic.handleTimeSelected,
                          )
                        : TimerWidget(
                            minute: meditationTimeProvider.selectedMinute,
                            second: 0,
                            operation: _timerOperation,
                            onTimerComplete: () => timerLogic.resetTimer(),
                            // The display mode is dynamically adjusted based on settings
                            displayMode: settingsProvider.progressBarEnabled
                                ? (settingsProvider.timerEnabled
                                    ? TimerDisplayMode.both
                                    : TimerDisplayMode.progressBar)
                                : (settingsProvider.timerEnabled
                                    ? TimerDisplayMode.timer
                                    : TimerDisplayMode.none),
                          ),
                  ],
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  // Toggle the timer operation, which would start the timer.
                  timerLogic.toggleTimerOperation(_timerOperation);

                  // Check if we're starting the timer and not pausing or stopping it.
                  if (_timerOperation == TimerOperation.start) {
                    // Create a new meditation session object with the selected time and type.
                    final newSession = MeditationSession(
                      duration: meditationTimeProvider.selectedMinute,
                      isBreathingExercise: false, // Set this accordingly if you have the data.
                    );

                    // Save the session using the session manager.
                    MeditationSessionManager().saveSession(newSession);
                  }
                },
                child: Image.asset(
                  _timerOperation == TimerOperation.pause || _timerOperation == TimerOperation.reset
                      ? 'assets/icons/play.png'
                      : 'assets/icons/pause.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),

            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.music_note, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SoundSelectionScreen(),
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
                            builder: (context) => const ActualSettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 16),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red, // Close icon
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Quit Session?'),
                          actions: <Widget>[
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () {
                                timerLogic.cancelTimer();
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pop(); // Navigate back
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
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
