import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ThemeProvider with ChangeNotifier {
  int _currentThemeIndex = 0;
  SharedPreferences? _prefs;
  List<Map<String, dynamic>> _gradientData = [
    {
      'name': 'Default Gradient',
      'colors': [Colors.blue, Colors.blueAccent]
    }
  ];
  List<LinearGradient> _gradients = [
    LinearGradient(colors: [Colors.blue, Colors.blueAccent])
  ];

  ThemeProvider() {
    _loadThemeIndex();
    _fetchGradientData();
  }

  int get currentThemeIndex => _currentThemeIndex;

  LinearGradient get currentGradient => _gradients.isNotEmpty
      ? _gradients[_currentThemeIndex]
      : LinearGradient(colors: [Colors.white, Colors.white]);

  List<Map<String, dynamic>> get gradientData => _gradientData;

  Future<void> _fetchGradientData() async {
    try {
      final ref =
      FirebaseStorage.instance.ref().child('gradients/gradients.csv');
      final data = await ref.getData();
      final csvString = utf8.decode(data!);
      _parseCSVData(csvString);
      notifyListeners();
    } catch (e) {
      print('Error fetching gradient data: $e');
    }
  }

  void _parseCSVData(String csvString) {
    final lines = csvString.split('\n');
    for (var line in lines.skip(1)) {
      // Skip header line
      final values = line.split(',');
      if (values.length >= 3) {
        final name = values[0];
        final colors = [values[1], values[2]].map((color) {
          final parsedColor = Color(_hexToInt(color.trim()));
          return parsedColor;
        }).toList();
        _gradientData.add({'name': name, 'colors': colors});
        _gradients.add(LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ));
      }
    }
  }

  int _hexToInt(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF' + hex; // Add alpha value if missing
    }
    return int.parse(hex, radix: 16);
  }

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
