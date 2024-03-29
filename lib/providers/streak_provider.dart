import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider extends ChangeNotifier {
  int _streak = 0;
  late DateTime _lastIncrementDate;
  SharedPreferences? _prefs; // Optional shared preferences for testing

  int get streak => _streak;

  // Updated constructor without direct initialization call
  StreakProvider({SharedPreferences? prefs}) {
    _prefs = prefs;
  }

  // Public method for initializing
  Future<void> init() async {
    await _loadLastIncrementDate();
  }

  void incrementStreak() {
    _streak++;
    _saveLastIncrementDate();
    notifyListeners();
  }

  void resetStreak() {
    _streak = 0;
    _saveLastIncrementDate();
    notifyListeners();
  }

  Future<void> _loadLastIncrementDate() async {
    _prefs ??= await SharedPreferences.getInstance();
    if (_prefs!.containsKey('lastIncrementTimestamp')) {
      int lastIncrementTimestamp = _prefs!.getInt('lastIncrementTimestamp')!;
      _lastIncrementDate = DateTime.fromMillisecondsSinceEpoch(lastIncrementTimestamp, isUtc: true);
    } else {
      _lastIncrementDate = DateTime.now().toUtc();
      await _saveLastIncrementDate();
    }
    _streak = _prefs!.getInt('streak') ?? 0;
    await checkAndResetStreakIfNeeded();
  }

  Future<void> _saveLastIncrementDate() async {
    _prefs ??= await SharedPreferences.getInstance();
    _lastIncrementDate = DateTime.now().toUtc();
    await _prefs!.setInt('lastIncrementTimestamp', _lastIncrementDate.millisecondsSinceEpoch);
    await _prefs!.setInt('streak', _streak);
  }

  Future<void> checkAndResetStreakIfNeeded() async {
    _prefs ??= await SharedPreferences.getInstance();

    final now = DateTime.now().toUtc();
    _lastIncrementDate = DateTime.fromMillisecondsSinceEpoch(_prefs!.getInt('lastIncrementTimestamp')!, isUtc: true);

    final lastIncrementDayUtc = DateTime.utc(_lastIncrementDate.year, _lastIncrementDate.month, _lastIncrementDate.day);
    final todayUtc = DateTime.utc(now.year, now.month, now.day);
    final difference = todayUtc.difference(lastIncrementDayUtc).inDays;

    if (difference > 1) {
      resetStreak();
    }
  }
}
