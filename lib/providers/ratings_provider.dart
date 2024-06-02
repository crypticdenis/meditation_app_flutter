import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RatingsProvider with ChangeNotifier {
  Map<String, List<int>> _ratings = {}; // Each date can have multiple ratings
  SharedPreferences? _prefs;

  RatingsProvider({SharedPreferences? prefs}) {
    _prefs = prefs;
  }

  Future<void> init() async {
    await loadRatings();
  }

  Map<String, List<int>> get ratings => _ratings;

  Future<void> loadRatings() async {
    final prefs = await SharedPreferences.getInstance();
    String? ratingsJson = prefs.getString('ratings');
    if (ratingsJson != null) {
      Map<String, dynamic> jsonMap = json.decode(ratingsJson);
      _ratings = jsonMap.map((key, value) {
        // Convert each value to a List<int>
        var list = List<int>.from(value);
        return MapEntry(key, list);
      });
      notifyListeners();
    }
  }

  void addRating(String date, int rating) async {
    // Append rating to the list for that date, or create a new list
    List<int> ratingsList = _ratings[date] ?? [];
    ratingsList.add(rating);
    _ratings[date] = ratingsList;

    notifyListeners();
    await _saveRatingsToPrefs();
  }

  Future<void> _saveRatingsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    // We need to encode the List<int> as a List<dynamic> for json.encode to work
    String ratingsJson = json.encode(_ratings.map((key, value) => MapEntry(key, value.toList())));
    await prefs.setString('ratings', ratingsJson);
  }
}
