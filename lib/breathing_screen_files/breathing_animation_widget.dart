import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/breathing_screen_files/sinus_painter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';


class SinusoidalWaveWidget extends StatefulWidget {
  final TimerOperation? timerOperation;
  final Function(TimerOperation)? onTimerOperationChanged;

  const SinusoidalWaveWidget(
      {super.key, this.timerOperation, this.onTimerOperationChanged});

  @override
  _SinusoidalWaveWidgetState createState() => _SinusoidalWaveWidgetState();
}

class _SinusoidalWaveWidgetState extends State<SinusoidalWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer audioPlayer = AudioPlayer();
  bool _isVibrationEnabled = true; // You can change this based on user preference


  DateTime? lastPlayedTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller)
          ..addListener(() {
            setState(() {});
            _checkPhaseAndPlaySound(_animation.value);
          });
  }

  @override
  void didUpdateWidget(covariant SinusoidalWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timerOperation != oldWidget.timerOperation) {
      _handleTimerOperationChange(widget.timerOperation);
    }
  }

  void _handleTimerOperationChange(TimerOperation? operation) {
    if (operation == TimerOperation.pause) {
      _controller.stop();
    } else if (operation == TimerOperation.start ||
        operation == TimerOperation.reset) {
      _controller.repeat(reverse: false);
    }
  }

  void _checkPhaseAndPlaySound(double value) {
    const epsilon = 0.1;
    DateTime now = DateTime.now();

    if (lastPlayedTime == null ||
        now.difference(lastPlayedTime!) > Duration(seconds: 1)) {
      bool isPeak =
          (value % (2 * math.pi) - math.pi / 2).abs() < epsilon; // Peak at π/2
      bool isTrough = (value % (2 * math.pi) - 3 * math.pi / 2).abs() <
          epsilon; // Trough at 3π/2

      if (isPeak) {
        print("Playing sound at peak");
        _playSound('gongs/out.mp3');
      } else if (isTrough) {
        print("Playing sound at trough");
        _playSound('gongs/in.mp3');
      }

      if (isPeak || isTrough) {
        lastPlayedTime = now;
      }
    }
  }

  Future<void> _playSound(String filePath) async {
    await audioPlayer.setSource(AssetSource(filePath));
    await audioPlayer.resume();

    if (_isVibrationEnabled) {
      // Check if the device can vibrate
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(); // Default vibration
      }
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PulsatingCirclePainter(
        phase: _animation.value,
      ),
      child: Container(width: double.infinity, height: 200),
    );
  }
}
