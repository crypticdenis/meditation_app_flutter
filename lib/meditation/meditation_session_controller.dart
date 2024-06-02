import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class MeditationSession {
  final int duration; // Duration in minutes
  final bool isBreathingExercise; // Whether the session is a breathing exercise

  MeditationSession({required this.duration, this.isBreathingExercise = false});
}

class MeditationSessionManager {
  static const _storageKey = 'recentSessions';

  Future<void> saveSession(MeditationSession session) async {
    final prefs = await SharedPreferences.getInstance();
    List<MeditationSession> sessions = await loadSessions();

    String newSessionDescription =
        '${session.duration} ${session.isBreathingExercise ? 'Breathing Exercise' : 'Simple Meditation'}';

    sessions.removeWhere((existingSession) {
      String existingSessionDescription =
          '${existingSession.duration} ${existingSession.isBreathingExercise ? 'Breathing Exercise' : 'Simple Meditation'}';
      return existingSessionDescription == newSessionDescription;
    });

    sessions.insert(0, session);

    if (sessions.length > 4) {
      sessions = sessions.take(4).toList();
    }

    List<String> stringSessions = sessions
        .map((session) => json.encode({
              'duration': session.duration,
              'isBreathingExercise': session.isBreathingExercise,
            }))
        .toList();

    await prefs.setStringList(_storageKey, stringSessions);
  }

  MeditationSession generateRandomSession() {
    final random = Random();
    int randomDuration = 1 + random.nextInt(60); // 0 to 60, inclusive
    bool isBreathingExercise = random.nextBool();

    return MeditationSession(
      duration: randomDuration,
      isBreathingExercise: isBreathingExercise,
    );
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
    final ratingsProvider =
        Provider.of<RatingsProvider>(context, listen: false);
    String date = DateTime.now()
        .toUtc()
        .toIso8601String()
        .split('T')[0]; // Format: YYYY-MM-DD
    ratingsProvider.addRating(date, rating);
  }

  Future<List<MeditationSession>> getDiverseSessions() async {
    List<MeditationSession> allSessions = await loadSessions();
    // Initial filtering logic you've implemented to get unique sessions
    List<MeditationSession> uniqueSessions = [];
    Set<String> seenDescriptions = {};
    for (var session in allSessions) {
      String sessionDescription =
          '${session.duration} ${session.isBreathingExercise ? 'Breathing Exercise' : 'Simple Meditation'}';
      if (!seenDescriptions.contains(sessionDescription)) {
        uniqueSessions.add(session);
        seenDescriptions.add(sessionDescription);
      }
    }

    List<MeditationSession> diverseSessions = [];
    Set<int> seenDurations = {};
    for (var session in uniqueSessions) {
      if (!seenDurations.contains(session.duration)) {
        diverseSessions.add(session);
        seenDurations.add(session.duration);
      }
    }

    return diverseSessions;
  }

  Future<void> _saveToStorage(Map<String, dynamic> sessionData) async {
    print('Saving session: $sessionData');
    await Future.delayed(Duration(seconds: 1));
    print('Session saved successfully.');
  }
}
