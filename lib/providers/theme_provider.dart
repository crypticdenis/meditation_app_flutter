import 'package:flutter/material.dart';
import '../appearance/gradient_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0;
  SharedPreferences? _prefs;

  ThemeProvider() {
    _loadThemeIndex();
  }

  int get currentThemeIndex => _currentThemeIndex;

  LinearGradient get currentGradient =>
      GradientColors.gradients[_currentThemeIndex];

  void setTheme(int index) {
    if (index != _currentThemeIndex) {
      _currentThemeIndex = index;
      notifyListeners();
      _saveThemeIndex();
    }
  }

  Future<void> _loadThemeIndex() async {
    _prefs = await SharedPreferences.getInstance();
    _currentThemeIndex = _prefs?.getInt('themeIndex') ?? 0;
    notifyListeners();
  }

  Future<void> _saveThemeIndex() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    await _prefs?.setInt('themeIndex', _currentThemeIndex);
  }
}
