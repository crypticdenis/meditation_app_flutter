import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RatingsProvider with ChangeNotifier {
  Map<String, int> _ratings = {};
  SharedPreferences? _prefs; // shared preferences for testing


  RatingsProvider({SharedPreferences? prefs}) : _prefs = prefs {
    if (_prefs != null) { // Additional check for null safety
    }
  }

  Future<void> init() async {
    await loadRatings();
  }

  Map<String, int> get ratings => _ratings;

  Future<void> loadRatings() async {
    final prefs = await SharedPreferences.getInstance();
    String? ratingsJson = prefs.getString('ratings');
    if (ratingsJson != null) {
      Map<String, dynamic> jsonMap = json.decode(ratingsJson);
      _ratings = jsonMap.map((key, value) => MapEntry(key, value.toInt()));
      notifyListeners();
    }
  }

  void addRating(String date, int rating) async {
    _ratings[date] = rating;
    notifyListeners();
    await _saveRatingsToPrefs();
  }

  Future<void> _saveRatingsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String ratingsJson = json.encode(_ratings);
    await prefs.setString('ratings', ratingsJson);
  }
}
