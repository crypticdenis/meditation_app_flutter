import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _timerEnabled = true;
  bool _progressBarEnabled = true;
  bool _vibrationEnabled = true; // Default value
  bool _soundscapeEnabled = false;
  SharedPreferences? _prefs;

  SettingsProvider()
  {loadSettings();}

  bool get vibrationEnabled => _vibrationEnabled;
  bool get timerEnabled => _timerEnabled;
  bool get progressBarEnabled => _progressBarEnabled;
  bool get soundscapeEnabled => _soundscapeEnabled;

  Future<void> init() async {
    await loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _timerEnabled = prefs.getBool('timerEnabled') ?? true; // Default value is true
    _vibrationEnabled = prefs.getBool('vibrationEnabled') ?? true;
    _progressBarEnabled = prefs.getBool('progressBarEnabled') ?? true;
    _soundscapeEnabled = prefs.getBool('soundscapeEnabled') ?? true;
    notifyListeners();
  }


  void setTimerEnabled(bool value) {
    _timerEnabled = value;
    _saveBool('timerEnabled', value);
  }

  void setVibrationEnabled(bool value) {
    _vibrationEnabled = value;
    _saveBool('vibrationEnabled', value);
  }

  void setProgressBarEnabled(bool value) {
    _progressBarEnabled = value;
    _saveBool('progressBarEnabled', value);
  }

  void setSoundscapeEnabled(bool value) {
    _soundscapeEnabled = value;
    _saveBool('soundscapeEnabled', value);
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    notifyListeners();
  }
}
