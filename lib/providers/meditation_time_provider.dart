import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationTimeProvider with ChangeNotifier {
  int _selectedMinute = 10;

  int get selectedMinute => _selectedMinute;

  set selectedMinute(int newValue) {
    _selectedMinute = newValue;
    notifyListeners();
    _saveToPrefs();
  }

  MeditationTimeProvider() {
    _loadFromPrefs();
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedMinute', _selectedMinute);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedMinute = prefs.getInt('selectedMinute') ?? 10;
    notifyListeners();
  }
}
