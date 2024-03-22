import 'package:flutter/material.dart';

class ScrollWheelIndexProvider with ChangeNotifier {
  int _currentIndex = 0; // Default to the first index

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      notifyListeners(); // Notify listeners about the change
    }
  }
}

