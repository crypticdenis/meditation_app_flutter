import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'meditation_session.dart';

class MeditationSessionManager {

  static const _storageKey = 'recentSessions';

  Future<void> saveSession(MeditationSession session) async {
    final prefs = await SharedPreferences.getInstance();
    List<MeditationSession> sessions = await loadSessions();
    sessions.insert(0, session); // Add newest session to the beginning
    if (sessions.length > 3) {
      sessions.removeLast(); // Keep only the last three sessions
    }

    // Save the updated list
    List<String> stringSessions = sessions
        .map((session) => json.encode({
      'duration': session.duration,
      'isBreathingExercise': session.isBreathingExercise,
    }))
        .toList();
    await prefs.setStringList(_storageKey, stringSessions);
  }

  Future<List<MeditationSession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? stringSessions = prefs.getStringList(_storageKey);
    if (stringSessions == null) return [];

    return stringSessions.map((stringSession) {
      final Map<String, dynamic> sessionMap = json.decode(stringSession);
      return MeditationSession(
        duration: sessionMap['duration'],
        isBreathingExercise: sessionMap['isBreathingExercise'],
      );
    }).toList();
  }

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

