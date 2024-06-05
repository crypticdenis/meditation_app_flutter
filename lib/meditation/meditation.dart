import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/timer/time_picker.dart';
import 'package:meditation_app_flutter/timer/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/timer/timer_and_picker_logic.dart';
import 'package:meditation_app_flutter/background_sounds/sound_settings.dart';
import 'meditation_session_controller.dart';
import 'dart:async';
import 'package:meditation_app_flutter/providers/streak_provider.dart';
import 'dart:ui';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late TimerLogic timerLogic;
  TimerOperation _timerOperation = TimerOperation.reset;
  bool _isTimerVisible = true;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    timerLogic = TimerLogic(
      context: context,
      onTimerOperationChange: (TimerOperation operation) {
        if (mounted) {
          setState(() {
            _timerOperation = operation;
          });
        }
      },
      onTimerComplete: () {
        print('Timer completed!');
        _handleTimerComplete();
        _showCongratulatoryPopup();
      },
    );
    _resetInactivityTimer();
  }

  void _showCongratulatoryPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Start a timer that will close the dialog after 5 seconds
        Future.delayed(Duration(seconds: 5), () {
          Navigator.of(context).pop();
        });

        return AlertDialog(
          title: Center(
            child: Text(
              '🧘🏿‍♂️ Congratulations! 🧘‍♀️',
              style: TextStyle(fontSize: 24), // Increased font size
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Minimize the height of the column
            children: [
              Center(
                child: Text(
                  'Take a moment to appreciate the time you’ve dedicated to your well-being.',
                  style: TextStyle(fontSize: 18), // Increased font size
                  textAlign: TextAlign.center, // Center the content text
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isTimerVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _handleTimerComplete() {
    final streakProvider = Provider.of<StreakProvider>(context, listen: false);
    streakProvider.incrementStreak();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    // Check if the provider is still loading the data
    if (meditationTimeProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Debugging: Print the selected duration
    print(
        "MeditationScreen build - Selected duration: ${meditationTimeProvider.selectedMinute}");

    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {
            _isTimerVisible = true;
          });
          _resetInactivityTimer();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(gradient: themeProvider.currentGradient),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: _timerOperation == TimerOperation.reset
                    ? TimePicker(
                        initialMinute: meditationTimeProvider.selectedMinute,
                        onTimeSelected: timerLogic.handleTimeSelected,
                      )
                    : TimerWidget(
                        minute: meditationTimeProvider.selectedMinute,
                        second: 0,
                        operation: _timerOperation,
                        onTimerComplete: () => timerLogic.resetTimer(),
                        isTimerVisible: _isTimerVisible,
                      ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    timerLogic.toggleTimerOperation(_timerOperation);
                    if (mounted) {
                      setState(() {
                        _isTimerVisible = true;
                      });
                      _resetInactivityTimer();
                    }

                    if (_timerOperation == TimerOperation.start) {
                      final newSession = MeditationSession(
                        duration: meditationTimeProvider.selectedMinute,
                        isBreathingExercise: false,
                      );
                      MeditationSessionManager().saveSession(newSession);
                    }
                  },
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
                child: AnimatedOpacity(
                  opacity: _isTimerVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.music_note, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SoundSelectionScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: AnimatedOpacity(
                  opacity: _isTimerVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 16),
                    child: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () {
                        showQuitSessionDialog(
                          context,
                          () {},
                          () {
                            timerLogic.cancelTimer();
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
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
