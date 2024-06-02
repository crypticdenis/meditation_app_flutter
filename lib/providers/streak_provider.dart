import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakProvider extends ChangeNotifier {
  int _streak = 0;
  DateTime _lastIncrementDate = DateTime.now().toUtc(); // Initialized here
  SharedPreferences? _prefs;

  int get streak => _streak;

  StreakProvider({SharedPreferences? prefs}) {
    _prefs = prefs;
  }

  Future<void> init() async {
    await _loadLastIncrementDate();
    print(streak);
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
    await checkAndResetStreakIfNeeded(); // Ensure this check is done once
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
    if (_prefs!.containsKey('lastIncrementTimestamp')) {
      _lastIncrementDate = DateTime.fromMillisecondsSinceEpoch(_prefs!.getInt('lastIncrementTimestamp')!, isUtc: true);
    } else {
      _lastIncrementDate = now;
    }

    final lastIncrementDayUtc = DateTime.utc(_lastIncrementDate.year, _lastIncrementDate.month, _lastIncrementDate.day);
    final todayUtc = DateTime.utc(now.year, now.month, now.day);
    final difference = todayUtc.difference(lastIncrementDayUtc).inDays;

    if (difference > 1) {
      resetStreak();
      notifyListeners(); // Added notifyListeners() here to reflect the changes
    }
  }
}
