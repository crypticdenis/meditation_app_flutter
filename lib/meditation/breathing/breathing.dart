import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/timer/time_picker.dart';
import 'package:meditation_app_flutter/timer/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/meditation/breathing/breathing_animation_widget.dart';
import 'package:meditation_app_flutter/timer/timer_and_picker_logic.dart';
import 'package:meditation_app_flutter/background_sounds/sound_settings.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/meditation/meditation_session_controller.dart';
import 'package:meditation_app_flutter/providers/breathing_rhythm_provider.dart';
import 'dart:async';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
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
        setState(() {
          _timerOperation = operation;
        });
      },
      onTimerComplete: () {
        print('Timer completed!');
      },
    );
    _resetInactivityTimer();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 7), () {
      setState(() {
        _isTimerVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final breathingSettingsProvider =
    Provider.of<BreathingSettingsProvider>(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isTimerVisible = true;
        });
        _resetInactivityTimer();
      },
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(gradient: themeProvider.currentGradient),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child:
                Align(
                  alignment: Alignment.center,
                  child: _timerOperation == TimerOperation.reset
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
                    isTimerVisible: false,
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    timerLogic.toggleTimerOperation(_timerOperation);

                    if (_timerOperation == TimerOperation.start) {
                      final newSession = MeditationSession(
                        duration: meditationTimeProvider.selectedMinute,
                        isBreathingExercise:
                        true, // Set this accordingly if you have the data.
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
              if (_timerOperation != TimerOperation.reset)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 300,
                        child: SinusoidalWaveWidget(
                          timerOperation: _timerOperation,
                          inhaleDuration: breathingSettingsProvider
                              .currentSettings.inhaleTime,
                          exhaleDuration: breathingSettingsProvider
                              .currentSettings.exhaleTime,
                        ),
                      ),
                    ),
                  ],
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
