import 'dart:async';
import 'package:flutter/material.dart';
import '../common_definitions.dart';
import 'package:audioplayers/audioplayers.dart';
import '../gong/gongs.dart';
import '../providers/gong_provider.dart';
import 'package:provider/provider.dart';
import '../providers/streak_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditation_app_flutter/home/main_home.dart';

class TimerWidget extends StatefulWidget {
  final int minute;
  final int second;
  final Function()? onTimerComplete;
  final TimerOperation operation;
  final bool isTimerVisible;

  const TimerWidget({
    super.key,
    required this.minute,
    this.second = 0,
    this.onTimerComplete,
    this.operation = TimerOperation.start,
    required this.isTimerVisible,
  });

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _remainingSeconds;
  late int _totalSeconds;
  Timer? _digitTimer;
  Timer? _progressTimer;
  int _elapsedTenths = 0;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.minute * 60 + widget.second;
    _remainingSeconds = _totalSeconds;
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
        _startTimers();
        break;
      case TimerOperation.pause:
        _pauseTimers();
        break;
      case TimerOperation.reset:
        _resetTimers();
        break;
    }
  }

  void _resetTimers() {
    _digitTimer?.cancel();
    _progressTimer?.cancel();
    setState(() {
      _remainingSeconds = widget.minute * 60 + widget.second;
      _elapsedTenths = 0;
    });
  }

  void _startTimers() {
    _playGongSound();
    _digitTimer?.cancel();
    _progressTimer?.cancel();

    _digitTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _digitTimer?.cancel();
        _progressTimer?.cancel();
        _handleTimerComplete();
        _playGongSound();
        if (widget.onTimerComplete != null) {
          widget.onTimerComplete!();
        }
      }
    });

    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _elapsedTenths++;
      });
    });
  }

  void _playGongSound() async {
    final gongProvider = Provider.of<GongProvider>(context, listen: false);
    if (gongProvider.gongEnabled) {
      final String gongSoundPath = GongSounds.files[gongProvider.currentGongIndex];
      final player = AudioPlayer();
      await player.play(AssetSource(gongSoundPath));
    }
  }

  Future<DateTime> getLastIncrementDateFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastIncrementTimestamp = prefs.getInt('lastIncrementTimestamp') ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(lastIncrementTimestamp);
  }

  void _handleTimerComplete() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );

    final streakProvider = Provider.of<StreakProvider>(context, listen: false);
    final lastReset = await getLastIncrementDateFromStorage();
    final today = DateTime.now().toUtc();
    final differenceInDays = DateTime(today.year, today.month, today.day)
        .difference(DateTime(lastReset.year, lastReset.month, lastReset.day))
        .inDays;

    if (differenceInDays == 0 && streakProvider.streak > 0) {
      // User already interacted today, so don't change the streak.
    } else if (differenceInDays == 1) {
      streakProvider.incrementStreak(); // Continue streak
    } else if (differenceInDays > 1) {
      streakProvider.resetStreak(); // Reset streak if more than a day has passed
    } else if (streakProvider.streak == 0) {
      streakProvider.incrementStreak(); // Start streak
    }
  }

  void _pauseTimers() {
    _digitTimer?.cancel();
    _progressTimer?.cancel();
  }

  @override
  void dispose() {
    _digitTimer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = twoDigits(_remainingSeconds ~/ 60);
    final seconds = twoDigits(_remainingSeconds % 60);
    double progress = (_elapsedTenths / 10) / _totalSeconds;

    return Stack(
      children: <Widget>[
        Center(
          child: AnimatedOpacity(
            opacity: widget.isTimerVisible ? 1.0 : 0.0,
            duration: Duration(seconds: 1),
            child: Text(
              '$minutes:$seconds',
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              color: Colors.white,
              minHeight: 8,
            ),
          ),
        ),
      ],
    );
  }
}
