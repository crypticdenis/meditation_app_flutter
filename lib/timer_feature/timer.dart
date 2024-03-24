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
    print("this _handleTimerComplete is in use ");
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
