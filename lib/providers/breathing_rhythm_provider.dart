import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BreathingSettings {
  final int inhaleTime;
  final int exhaleTime;

  BreathingSettings({required this.inhaleTime, required this.exhaleTime});
}

class BreathingSettingsProvider with ChangeNotifier {
  BreathingSettings _currentSettings = BreathingSettings(inhaleTime: 4, exhaleTime: 4); // Default values

  BreathingSettings get currentSettings => _currentSettings;
  //int get inhaleTime => _inhaleTime;
  // int get exhaleTime => _exhaleTime;

  BreathingSettingsProvider() {
    init(); // Call init() instead of loadCurrentGongIndex() directly
  }


  Future<void> init() async {
    await loadSettings();
  }

  Future<void> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int inhaleTime = prefs.getInt('inhaleTime') ?? 4; // Provide a default value
    final int exhaleTime = prefs.getInt('exhaleTime') ?? 4; // Provide a default value
    _currentSettings = BreathingSettings(inhaleTime: inhaleTime, exhaleTime: exhaleTime);
    notifyListeners();
  }

  Future<void> saveSettings(int inhaleTime, int exhaleTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('inhaleTime', inhaleTime);
    await prefs.setInt('exhaleTime', exhaleTime);
    _currentSettings = BreathingSettings(inhaleTime: inhaleTime, exhaleTime: exhaleTime);
    notifyListeners();

    print(inhaleTime);
    print(exhaleTime);
  }
}
