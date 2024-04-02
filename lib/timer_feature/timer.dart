import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common_definitions.dart';
import 'package:audioplayers/audioplayers.dart';
import '../gong_feature/gongs.dart';
import '../providers/gong_provider.dart';
import 'package:provider/provider.dart';
import '../providers/streak_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../meditation/rate_meditation.dart';
import 'package:meditation_app_flutter/home/home.dart';

class TimerWidget extends StatefulWidget {
  final int minute;
  final int second;
  final Function()? onTimerComplete;
  final TimerOperation operation;
  final TimerDisplayMode displayMode; // Add this line

  const TimerWidget({
    super.key,
    required this.minute,
    this.second = 0,
    this.onTimerComplete,
    this.operation = TimerOperation.start,
    this.displayMode = TimerDisplayMode.both, // Default to showing both
  });

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.minute * 60 + widget.second;
    _remainingSeconds = _totalSeconds;
    _handleOperation(widget.operation);
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    print("this didUpdateWidget is in use ");
    super.didUpdateWidget(oldWidget);
    if (widget.operation != oldWidget.operation) {
      _handleOperation(widget.operation);
    }
  }

  void _handleOperation(TimerOperation operation) {
    print("this _handleOperation is in use ");
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
    }
  }

  void _resetTimer() {
    print("this _resetTimer is in use ");
    _timer?.cancel();
    setState(() {
      _remainingSeconds = widget.minute * 60 + widget.second;
    });
  }

  void _startTimer() {
    print("this _startTimer is in use ");
    _playGongSound();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _handleTimerComplete();
        _playGongSound();
        if (widget.onTimerComplete != null) {
          widget.onTimerComplete!();
        }
      }
    });
  }

  void _playGongSound() async {
    print("this _playGongSound is in use ");
    final gongProvider = Provider.of<GongProvider>(context, listen: false);
    final String gongSoundPath =
        GongSounds.files[gongProvider.currentGongIndex];

    final player = AudioPlayer();
    await player.play(AssetSource(gongSoundPath));
  }

  Future<DateTime> getLastIncrementDateFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastIncrementTimestamp = prefs.getInt('lastIncrementTimestamp') ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(lastIncrementTimestamp);
  }

  void _handleTimerComplete() async {
    print("This _handleTimerComplete is in use");

    // Navigate after all logic is performed and the dialog is dismissed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()), // Assuming Home is defined elsewhere
    );

    final streakProvider = Provider.of<StreakProvider>(context, listen: false);
    final lastReset = await getLastIncrementDateFromStorage();
    final today = DateTime.now().toUtc();
    final differenceInDays = DateTime(today.year, today.month, today.day)
        .difference(DateTime(lastReset.year, lastReset.month, lastReset.day))
        .inDays;

    print(streakProvider.streak);

    // Assuming streak == 0 indicates the user hasn't started a streak yet or it was reset
    if (differenceInDays == 0 && streakProvider.streak > 0) {
      // User already interacted today, so don't change the streak.
    } else if (differenceInDays == 1) {
      streakProvider.incrementStreak(); // Continue streak
    } else if (differenceInDays > 1) {
      streakProvider.resetStreak(); // Reset streak if more than a day has passed
    } else if (streakProvider.streak == 0) {
      streakProvider.incrementStreak(); // Start streak
    }
  print(streakProvider.streak);
    // Show dialog to rate meditation
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return RateMeditationDialog(); // Assuming this is defined elsewhere
        });
  }



  void _pauseTimer() {
    print("this _pauseTimer is in use ");
    _timer?.cancel();
  }

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
    double progress = (_totalSeconds - _remainingSeconds) / _totalSeconds;

    // Conditional rendering based on the display mode
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 100), // Updated to 200
            child: Column(
              children: <Widget>[
                if (widget.displayMode == TimerDisplayMode.both ||
                    widget.displayMode == TimerDisplayMode.progressBar)
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            strokeWidth: 8,
                          ),
                        ),
                        if (widget.displayMode == TimerDisplayMode.both)
                          Text(
                            '$minutes:$seconds',
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                if (widget.displayMode == TimerDisplayMode.timer)
                  Text(
                    '$minutes:$seconds',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (widget.displayMode == TimerDisplayMode.none)
                  Text(
                    'Enable Timer in Settings',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
