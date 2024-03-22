import 'dart:async';
import 'package:flutter/material.dart';
import 'common_definitions.dart';
import 'package:audioplayers/audioplayers.dart';
import 'gongs.dart';
import 'providers/gong_provider.dart';
import 'package:provider/provider.dart';
import 'providers/streak_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rate_meditation.dart';

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
  late int _totalSeconds; // Added to store the total seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.minute * 60 + widget.second; // Initialize total seconds
    _remainingSeconds = _totalSeconds; // Initialize remaining seconds
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
        _handleTimerComplete(); // Call _handleTimerComplete() when the timer completes
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

  Future<DateTime> getLastIncrementDateFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastIncrementTimestamp = prefs.getInt('lastIncrementTimestamp') ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(lastIncrementTimestamp);
  }


  void _handleTimerComplete() async {
    final streakProvider = Provider.of<StreakProvider>(context, listen: false);
    final lastReset = await getLastIncrementDateFromStorage();
    final lastResetDay =
        DateTime(lastReset.year, lastReset.month, lastReset.day);
    final today = DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RateMeditationDialog();
        });

    if (lastResetDay.isBefore(todayDay)) {
      streakProvider.incrementStreak();
      print(lastResetDay);
      print("streak +1");
      _resetTimer();
    } else {
      _timer?.cancel();
    }

    if (widget.onTimerComplete != null) {
      widget.onTimerComplete!();
      print("same same");
      print(lastResetDay);
    }
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
    // Calculate the progress for the circular progress bar
    double progress = (_totalSeconds - _remainingSeconds) / _totalSeconds;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 150),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular progress bar that sits behind the timer text
              SizedBox(
                width: 120, // Diameter of the circular progress bar
                height: 120, // Diameter of the circular progress bar
                child: CircularProgressIndicator(
                  value: progress, // Current progress
                  backgroundColor: Colors.transparent, // Background color of the progress bar
                  color: Colors.white, // Color of the progress
                  strokeWidth: 8, // Thickness of the progress bar
                ),
              ),
              // Timer text that shows the remaining time
              Row(
                mainAxisSize: MainAxisSize.min, // Align texts closer to each other
                children: [
                  Text(
                    '$minutes',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10), // Space between minutes and seconds
                  const Text(
                    ':',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10), // Space between minutes and seconds
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
            ],
          ),
        ),
      ],
    );
  }
}
