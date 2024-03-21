import 'dart:async';
import 'package:flutter/material.dart';
import 'common_definitions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'gongs.dart';
import 'gong_provider.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatefulWidget {
  final int minute;
  final int second;
  final Function()? onTimerComplete;
  final TimerOperation operation; // Add this line

  const TimerWidget({
    super.key,
    required this.minute,
    this.second = 0,
    this.onTimerComplete,
    this.operation = TimerOperation.start, // Default to start
  });

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.minute * 60 + widget.second;
    _handleOperation(widget.operation);
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.operation != oldWidget.operation) {
      _handleOperation(widget.operation);
    }
  }

  void _handleOperation(TimerOperation operation) {
    switch (operation) {
      case TimerOperation.start:
      case TimerOperation.resume:
        _startTimer();
        break;
      case TimerOperation.pause:
        _pauseTimer();
        break;
      case TimerOperation.reset:
        _resetTimer();
        break;
      // Optionally, add a default case if needed
      // default:
      //   // Handle any cases that are not explicitly handled above
      //   break;
    }
  }

  void _resetTimer() {
    // Logic to reset the timer
    _timer?.cancel();
    setState(() {
      _remainingSeconds =
          widget.minute * 60 + widget.second; // Reset to initial state
      // Optionally, you might want to restart the timer immediately or do something else
    });
  }

  void _startTimer() {
    _playGongSound();
    _timer?.cancel(); // Ensure any existing timer is canceled
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _playGongSound(); // Play gong sound when timer is up
        if (widget.onTimerComplete != null) {
          widget.onTimerComplete!();
        }
      }
    });
  }

  void _playGongSound() async {
    // Access GongProvider to get the current gong's sound path
    final gongProvider = Provider.of<GongProvider>(context, listen: false);
    final String gongSoundPath =
        GongSounds.files[gongProvider.currentGongIndex];

    final player = AudioPlayer(); // Create a new instance of the player
    await player
        .play(AssetSource(gongSoundPath)); // Play the selected gong sound
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  // No need for a resumeTimer() method, as _startTimer() handles resume logic as well

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = twoDigits(_remainingSeconds ~/ 60);
    final seconds = twoDigits(_remainingSeconds % 60);
    return Container(
      padding: const EdgeInsets.only(top: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$minutes',
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10), // Adjusted padding
          const Text(
            ':',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10), // Adjusted padding
          Text(
            '$seconds',
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
