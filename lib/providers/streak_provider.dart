import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider extends ChangeNotifier {
  int _streak = 0;
  late DateTime _lastIncrementDate;

  int get streak => _streak;

  StreakProvider() {
    _loadLastIncrementDate();
  }

  void incrementStreak() {
    _streak++;
    _saveLastIncrementDate();
    notifyListeners();
  }

  Future<void> _loadLastIncrementDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastIncrementTimestamp = prefs.getInt('lastIncrementTimestamp') ?? 0;
    _lastIncrementDate = DateTime.fromMillisecondsSinceEpoch(lastIncrementTimestamp);
  }

  Future<void> _saveLastIncrementDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lastIncrementDate = DateTime.now();
    await prefs.setInt('lastIncrementTimestamp', _lastIncrementDate.millisecondsSinceEpoch);
  }
}
