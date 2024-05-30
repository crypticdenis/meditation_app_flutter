import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/timer/time_picker.dart';
import 'package:meditation_app_flutter/timer/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/timer/timer_and_picker_logic.dart';
import 'package:meditation_app_flutter/background_sounds/sound_settings.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/meditation/meditation_session_controller.dart';
import 'package:meditation_app_flutter/providers/breathing_rhythm_provider.dart';
import 'dart:async';
import 'dart:math' as math;
import 'SegmentedCirclePainter.dart';
import 'breathin_phase_widget.dart';

class BoxedBreathingScreen extends StatefulWidget {
  const BoxedBreathingScreen({Key? key}) : super(key: key);

  @override
  _BoxedBreathingScreenState createState() => _BoxedBreathingScreenState();
}

class _BoxedBreathingScreenState extends State<BoxedBreathingScreen>
    with SingleTickerProviderStateMixin {
  late TimerLogic timerLogic;
  TimerOperation _timerOperation = TimerOperation.reset;
  bool _isTimerVisible = true;
  Timer? _inactivityTimer;

  late AnimationController _controller;
  late Animation<double> _animation;
  late String currentPhase;

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

    int duration = 4;
    int totalDuration = duration * 4;

    _controller = AnimationController(
      duration: Duration(seconds: totalDuration),
      vsync: this,
    )..repeat();

    _animation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller)
          ..addListener(() {
            setState(() {
              _updateCurrentPhase();
            });
          });

    _handleTimerOperation(_timerOperation);
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 7), () {
      setState(() {
        _isTimerVisible = false;
      });
    });
  }

  void _updateCurrentPhase() {
    double progress = _animation.value / (2 * math.pi);
    int duration = 4;
    int totalDuration = duration * 4;

    double inhaleEnd = duration / totalDuration;
    double holdEnd = (duration * 2) / totalDuration;
    double exhaleEnd = (duration * 3) / totalDuration;

    if (progress < inhaleEnd) {
      currentPhase = 'inhale';
    } else if (progress < holdEnd) {
      currentPhase = 'hold1';
    } else if (progress < exhaleEnd) {
      currentPhase = 'exhale';
    } else {
      currentPhase = 'hold2';
    }
  }

  void _handleTimerOperation(TimerOperation operation) {
    if (operation == TimerOperation.pause) {
      _controller.stop();
    } else if (operation == TimerOperation.start ||
        operation == TimerOperation.reset) {
      _controller.repeat(reverse: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    final screenSize = MediaQuery.of(context).size;
    final widgetSize = screenSize.width * 0.8; // Adjust size as needed

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
                        isTimerVisible: false,
                      ),
              ),
              Align(
                alignment: Alignment.center,
                child: _timerOperation != TimerOperation.reset
                    ? SizedBox(
                        width: widgetSize,
                        height: widgetSize,
                        child: SegmentedCircleWidget(
                          timerOperation: _timerOperation,
                        ),
                      )
                    : Container(),
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
                        isBreathingExercise: true,
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
                    padding: const EdgeInsets.only(top: 50, left: 16),
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

class SegmentedCircleWidget extends StatefulWidget {
  final TimerOperation timerOperation;

  const SegmentedCircleWidget({
    super.key,
    required this.timerOperation,
  });

  @override
  _SegmentedCircleWidgetState createState() => _SegmentedCircleWidgetState();
}

class _SegmentedCircleWidgetState extends State<SegmentedCircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String currentPhase;

  @override
  void initState() {
    super.initState();
    int inhaleDuration = 4;
    int holdDuration = 4;
    int exhaleDuration = 4;
    int totalDuration =
        inhaleDuration + holdDuration + exhaleDuration + holdDuration;

    _controller = AnimationController(
      duration: Duration(seconds: totalDuration),
      vsync: this,
    )..repeat();

    _animation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller)
          ..addListener(() {
            setState(() {
              _updateCurrentPhase();
            });
          });

    _handleTimerOperation(widget.timerOperation);
  }

  void _updateCurrentPhase() {
    double progress = _animation.value / (2 * math.pi);
    int inhaleDuration = 4;
    int holdDuration = 4;
    int exhaleDuration = 4;
    int totalDuration =
        inhaleDuration + holdDuration + exhaleDuration + holdDuration;

    double inhaleEnd = inhaleDuration / totalDuration;
    double holdAfterInhaleEnd = (inhaleDuration + holdDuration) / totalDuration;
    double exhaleEnd =
        (inhaleDuration + holdDuration + exhaleDuration) / totalDuration;

    if (progress < inhaleEnd) {
      currentPhase = 'inhale';
    } else if (progress < holdAfterInhaleEnd) {
      currentPhase = 'hold';
    } else if (progress < exhaleEnd) {
      currentPhase = 'exhale';
    } else {
      currentPhase = 'hold';
    }
  }

  @override
  void didUpdateWidget(covariant SegmentedCircleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timerOperation != oldWidget.timerOperation) {
      _handleTimerOperation(widget.timerOperation);
    }
  }

  void _handleTimerOperation(TimerOperation operation) {
    if (operation == TimerOperation.pause) {
      _controller.stop();
    } else if (operation == TimerOperation.start ||
        operation == TimerOperation.reset) {
      _controller.repeat(reverse: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20),
        CustomPaint(
          painter: SegmentedCirclePainter(
            phase: _animation.value,
            inhaleDuration: 4,
            // Hardcoded inhale duration
            holdAfterInhaleDuration: 4,
            // Hardcoded hold duration
            exhaleDuration: 4,
            // Hardcoded exhale duration
            holdAfterExhaleDuration: 4, // Hardcoded hold duration after exhale
          ),
          child: Container(width: double.infinity, height: 200),
        ),
        SizedBox(height: 40),
        BreathingPhaseWidget(currentPhase: currentPhase),
      ],
    );
  }
}
