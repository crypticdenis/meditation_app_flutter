import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/custom_app_bar.dart';
import 'package:meditation_app_flutter/timer_feature/time_picker.dart';
import 'package:meditation_app_flutter/timer_feature/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing_animation_widget.dart';
import 'package:meditation_app_flutter/timer_feature/timer_and_picker_logic.dart';
import 'package:meditation_app_flutter/background_sounds_feature/sound_settings.dart';
import 'package:meditation_app_flutter/actual_settings_screen.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({Key? key}) : super(key: key);

  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  final double _opacity = 1.0;
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
          gradient: themeProvider.currentGradient,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Visibility(
                      visible: _timerOperation != TimerOperation.reset,
                      // Only show when the timer is not in reset state
                      child: TimerWidget(
                        minute: meditationTimeProvider.selectedMinute,
                        second: 0,
                        operation: _timerOperation,
                        onTimerComplete: () => timerLogic.resetTimer(),
                        displayMode: settingsProvider.progressBarEnabled
                            ? (settingsProvider.timerEnabled
                                ? TimerDisplayMode.both
                                : TimerDisplayMode.progressBar)
                            : (settingsProvider.timerEnabled
                                ? TimerDisplayMode.timer
                                : TimerDisplayMode.none),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: _timerOperation == TimerOperation.reset
                        ? TimePicker(
                            initialMinute:
                                meditationTimeProvider.selectedMinute,
                            onTimeSelected: timerLogic.handleTimeSelected,
                          )
                        : Container(), // Hide TimePicker when not in reset state
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () => timerLogic.toggleTimerOperation(_timerOperation),
                child: Image.asset(
                  _timerOperation == TimerOperation.pause ||
                          _timerOperation == TimerOperation.reset
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
                padding: const EdgeInsets.only(top: 50, right: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  // Added to ensure the buttons stay together
                  children: [
                    IconButton(
                      icon: Icon(Icons.music_note, color: Colors.white),
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
                      icon: Icon(Icons.settings, color: Colors.white),
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
            if (_timerOperation != TimerOperation.reset)
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                    height: 300,
                    child:
                        SinusoidalWaveWidget(timerOperation: _timerOperation)),
              ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 50, right: 15),
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red, // Close icon
                  onPressed: () {
                    // Show confirmation dialog
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
                                // Perform your logic here, e.g., cancel the timer
                                // Assuming `timerLogic.cancelTimer()` is your method to cancel the timer
                                timerLogic.cancelTimer();
                                // Then pop the current screen off the navigation stack
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
