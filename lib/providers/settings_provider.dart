import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _timerEnabled = true;
  bool _progressBarEnabled = true;
  bool _vibrationEnabled = true; // Default value


  bool get vibrationEnabled => _vibrationEnabled;
  bool get timerEnabled => _timerEnabled;
  bool get progressBarEnabled => _progressBarEnabled;

  void setTimerEnabled(bool enabled) {
    _timerEnabled = enabled;
    notifyListeners();
  }

  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
    notifyListeners(); // Notify widgets listening to this value to rebuild
  }

  void setProgressBarEnabled(bool enabled) {
    _progressBarEnabled = enabled;
    notifyListeners();
  }
}
