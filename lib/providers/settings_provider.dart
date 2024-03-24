import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _timerEnabled = true;
  bool _progressBarEnabled = true;

  bool get timerEnabled => _timerEnabled;
  bool get progressBarEnabled => _progressBarEnabled;

  void setTimerEnabled(bool enabled) {
    _timerEnabled = enabled;
    notifyListeners();
  }

  void setProgressBarEnabled(bool enabled) {
    _progressBarEnabled = enabled;
    notifyListeners();
  }
}
