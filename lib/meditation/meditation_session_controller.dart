import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:provider/provider.dart';

class MeditationSessionController {
  void saveSessionRating(BuildContext context, int rating) {
    final ratingsProvider = Provider.of<RatingsProvider>(context, listen: false);
    String date = DateTime.now().toUtc().toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
    ratingsProvider.addRating(date, rating);
  }

  Future<void> _saveToStorage(Map<String, dynamic> sessionData) async {
    print('Saving session: $sessionData');
    await Future.delayed(Duration(seconds: 1));
    print('Session saved successfully.');
  }
}
