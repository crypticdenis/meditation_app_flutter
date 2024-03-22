import 'package:flutter/material.dart';
import '../gradient_colors.dart';// Adjust the import path as necessary

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0; // Default to first theme
  int get currentThemeIndex => _currentThemeIndex;

  LinearGradient get currentGradient => GradientColors.gradients[_currentThemeIndex];

  void setTheme(int index) {
    if (index != _currentThemeIndex) {
      _currentThemeIndex = index;
      notifyListeners(); // Notify listeners about the change
    }
  }
}

