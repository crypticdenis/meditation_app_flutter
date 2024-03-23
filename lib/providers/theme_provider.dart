import 'package:flutter/material.dart';
import '../appearance/gradient_colors.dart';

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0;

  int get currentThemeIndex => _currentThemeIndex;

  LinearGradient get currentGradient =>
      GradientColors.gradients[_currentThemeIndex];

  void setTheme(int index) {
    if (index != _currentThemeIndex) {
      _currentThemeIndex = index;
      notifyListeners();
    }
  }
}
