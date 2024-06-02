import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationTimeProvider with ChangeNotifier {
  int _selectedMinute = 0;
  bool _isLoading = true;  // To indicate if the loading is in progress

  int get selectedMinute => _selectedMinute;
  bool get isLoading => _isLoading;

  set selectedMinute(int newValue) {
    _selectedMinute = newValue;
    notifyListeners();
    _saveToPrefs();
  }

  MeditationTimeProvider() {
    _loadFromPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedMinute', _selectedMinute);
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedMinute = prefs.getInt('selectedMinute') ?? 10;
    _isLoading = false;  // Loading complete
    notifyListeners();
  }
}
