import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'breathin_phase_widget.dart';
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

// Define your BoxedBreathingScreen
class BoxedBreathingScreen extends StatefulWidget {
  const BoxedBreathingScreen({Key? key}) : super(key: key);

  @override
  _BoxedBreathingScreenState createState() => _BoxedBreathingScreenState();
}

class _BoxedBreathingScreenState extends State<BoxedBreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String currentPhase;
  Timer? _inactivityTimer;
  bool _isTimerVisible = true;

  @override
  void initState() {
    super.initState();
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

    _resetInactivityTimer();
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
    _controller.dispose();
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomPaint(
                      painter: SegmentedSquarePainter(
                        phase: _animation.value,
                        inhaleDuration: 4,
                        holdDuration: 4,
                        exhaleDuration: 4,
                        secondHoldDuration: 4,
                      ),
                      child: Container(width: double.infinity, height: 200),
                    ),
                    SizedBox(height: 100),
                    BreathingPhaseWidget(currentPhase: currentPhase),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: AnimatedOpacity(
                  opacity: _isTimerVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 15),
                    child: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
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

class SegmentedSquarePainter extends CustomPainter {
  final double phase;
  final int inhaleDuration;
  final int holdDuration;
  final int exhaleDuration;
  final int secondHoldDuration;

  SegmentedSquarePainter({
    required this.phase,
    required this.inhaleDuration,
    required this.holdDuration,
    required this.exhaleDuration,
    required this.secondHoldDuration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double side = size.width < size.height ? size.width : size.height;
    double segmentLength =
        side / 4; // Assuming 4 phases (inhale, hold, exhale, hold)
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    Path path = Path();

    int totalDuration =
        inhaleDuration + holdDuration + exhaleDuration + secondHoldDuration;
    double progress = phase / (2 * math.pi);

    if (progress <= 0.25) {
      // Inhale (top side)
      double length = progress / 0.25 * segmentLength;
      path.moveTo(0, 0);
      path.lineTo(length, 0);
    } else if (progress <= 0.5) {
      // Hold (right side)
      double length = (progress - 0.25) / 0.25 * segmentLength;
      path.moveTo(segmentLength, 0);
      path.lineTo(segmentLength, length);
    } else if (progress <= 0.75) {
      // Exhale (bottom side)
      double length = (progress - 0.5) / 0.25 * segmentLength;
      path.moveTo(segmentLength, segmentLength);
      path.lineTo(segmentLength - length, segmentLength);
    } else {
      // Hold (left side)
      double length = (progress - 0.75) / 0.25 * segmentLength;
      path.moveTo(0, segmentLength);
      path.lineTo(0, segmentLength - length);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
