import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meditation_app_flutter/providers/streak_provider.dart';
import 'mocks.mocks.dart';

void main() {
  group('StreakProvider Tests', () {
    late MockSharedPreferences mockSharedPreferences;
    late StreakProvider provider;

    setUp(() async {
      mockSharedPreferences = MockSharedPreferences();

      // Setup common stubs for SharedPreferences methods
      when(mockSharedPreferences.containsKey(any)).thenReturn(false);
      when(mockSharedPreferences.getInt(any)).thenReturn(0);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.setInt(any, any)).thenAnswer((_) async => true);

      provider = StreakProvider(prefs: mockSharedPreferences);
      await provider.init(); // Ensure provider is initialized before tests
    });

    test('Streak correctly updates from 0 to 1 after another streak is lost and restarts correctly', () async {
      // Simulate losing the streak by setting lastIncrementTimestamp to more than a day ago
      int moreThanADayAgo = DateTime.now().toUtc().subtract(Duration(days: 2)).millisecondsSinceEpoch;
      when(mockSharedPreferences.getInt('lastIncrementTimestamp')).thenReturn(moreThanADayAgo);
      // Initially, the streak is not set, simulating a lost streak where it should be reset to 0
      when(mockSharedPreferences.getInt('streak')).thenReturn(0);

      // First, simulate checking and resetting the streak if needed, which should happen automatically
      // when a streak is lost (this part simulates the user not interacting with the app for more than a day)
      await provider.checkAndResetStreakIfNeeded();

      // Assert that the streak is reset to 0 after it is lost
      expect(provider.streak, 0, reason: "Streak should be 0 after being reset due to inactivity.");

      // Simulate the user interacting with the app again by setting lastIncrementTimestamp to now
      int today = DateTime.now().toUtc().millisecondsSinceEpoch;
      when(mockSharedPreferences.getInt('lastIncrementTimestamp')).thenReturn(today);
      // This is the point where the user restarts their streak, so we increment it
      provider.incrementStreak();

      // Assert that the streak correctly updates from 0 to 1 after restarting
      expect(provider.streak, 1, reason: "Streak should correctly update from 0 to 1 after it is restarted.");
    });

    test('Resets streak if more than one day has passed since last increment', () async {
      int moreThanADayAgo = DateTime.now().toUtc().subtract(Duration(days: 2)).millisecondsSinceEpoch;
      when(mockSharedPreferences.getInt('lastIncrementTimestamp')).thenReturn(moreThanADayAgo);

      await provider.checkAndResetStreakIfNeeded();

      expect(provider.streak, 0, reason: "The streak should be reset if more than one day has passed since the last increment.");
    });

    test('Increments streak up to 7 days with daily usage', () async {
      DateTime startDate = DateTime.now().toUtc().subtract(Duration(days: 6)); // Start from 6 days ago
      for (int i = 0; i < 7; i++) {
        // Simulate each day by setting lastIncrementTimestamp to startDate + i days
        int simulatedDayTimestamp = startDate.add(Duration(days: i)).millisecondsSinceEpoch;
        when(mockSharedPreferences.getInt('lastIncrementTimestamp')).thenReturn(simulatedDayTimestamp);
        when(mockSharedPreferences.getInt('streak')).thenReturn(i); // Expect the streak to be i on the ith day

        // Call incrementStreak for each simulated day
        provider.incrementStreak();

        // Assert that the streak increments as expected
        expect(provider.streak, i + 1, reason: "The streak should increment to ${i + 1} after ${i + 1} days of continuous usage.");
      }
    });


    test('Breaks streak when users have a streak of 3 and then miss a day', () async {
      // Simulate last increment being more than one day ago
      int twoDaysAgo = DateTime.now().toUtc().subtract(Duration(days: 2)).millisecondsSinceEpoch;
      when(mockSharedPreferences.getInt('lastIncrementTimestamp')).thenReturn(twoDaysAgo);
      // Simulate current streak being 3 days
      when(mockSharedPreferences.getInt('streak')).thenReturn(3);

      await provider.checkAndResetStreakIfNeeded();

      expect(provider.streak, 0, reason: "The streak should break and reset to 0 if more than one day has passed since the last increment with a streak of 3.");
    });


    test('Loading initial streak and last increment date on initialization', () async {
      int yesterday = DateTime.now().toUtc().subtract(Duration(days: 1)).millisecondsSinceEpoch;
      when(mockSharedPreferences.containsKey('lastIncrementTimestamp')).thenReturn(true);
      when(mockSharedPreferences.getInt('lastIncrementTimestamp')).thenReturn(yesterday);
      when(mockSharedPreferences.getInt('streak')).thenReturn(3);

      // Reinitialize provider to load values
      await provider.init();

      expect(provider.streak, 3, reason: "The initial streak should be loaded correctly.");
      // We can't directly test private properties (_lastIncrementDate), but it's used in logic for checking and resetting the streak, so its correct loading is implied by other tests working correctly.
    });
  });
}
