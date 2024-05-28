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
      when(mockSharedPreferences.getInt(any)).thenReturn(null);
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferences.setInt(any, any))
          .thenAnswer((_) async => true);

      provider = StreakProvider(prefs: mockSharedPreferences);
    });

    test(
        'Streak correctly updates from 0 to 1 after another streak is lost and restarts correctly',
            () async {
          int moreThanADayAgo = DateTime.now()
              .toUtc()
              .subtract(Duration(days: 2))
              .millisecondsSinceEpoch;
          when(mockSharedPreferences.getInt('lastIncrementTimestamp'))
              .thenReturn(moreThanADayAgo);
          when(mockSharedPreferences.getInt('streak')).thenReturn(0);

          await provider.init();
          await provider.checkAndResetStreakIfNeeded();

          expect(provider.streak, 0,
              reason: "Streak should be 0 after being reset due to inactivity.");

          int today = DateTime.now().toUtc().millisecondsSinceEpoch;
          when(mockSharedPreferences.getInt('lastIncrementTimestamp'))
              .thenReturn(today);

          provider.incrementStreak();
          expect(provider.streak, 1,
              reason:
              "Streak should correctly update from 0 to 1 after it is restarted.");
        });

    test('Resets streak if more than one day has passed since last increment',
            () async {
          int moreThanADayAgo = DateTime.now()
              .toUtc()
              .subtract(Duration(days: 2))
              .millisecondsSinceEpoch;
          when(mockSharedPreferences.getInt('lastIncrementTimestamp'))
              .thenReturn(moreThanADayAgo);

          await provider.init();
          await provider.checkAndResetStreakIfNeeded();

          expect(provider.streak, 0,
              reason:
              "The streak should be reset if more than one day has passed since the last increment.");
        });

    test('Increments streak up to 7 days with daily usage', () async {
      DateTime startDate = DateTime.now().toUtc().subtract(Duration(days: 6));
      for (int i = 0; i < 7; i++) {
        int simulatedDayTimestamp =
            startDate.add(Duration(days: i)).millisecondsSinceEpoch;
        when(mockSharedPreferences.getInt('lastIncrementTimestamp'))
            .thenReturn(simulatedDayTimestamp);
        when(mockSharedPreferences.getInt('streak')).thenReturn(i);

        await provider.init();
        provider.incrementStreak();

        expect(provider.streak, i + 1,
            reason:
            "The streak should increment to ${i + 1} after ${i + 1} days of continuous usage.");

        // Simulate the new day by updating the mock
        int nextDayTimestamp =
            startDate.add(Duration(days: i + 1)).millisecondsSinceEpoch;
        when(mockSharedPreferences.getInt('lastIncrementTimestamp'))
            .thenReturn(nextDayTimestamp);
        // Manually set the updated streak value
        when(mockSharedPreferences.getInt('streak')).thenReturn(i + 1);
      }
    });

    test('Loading initial streak and last increment date on initialization',
            () async {
          int yesterday = DateTime.now()
              .toUtc()
              .subtract(Duration(days: 1))
              .millisecondsSinceEpoch;
          when(mockSharedPreferences.containsKey('lastIncrementTimestamp'))
              .thenReturn(true);
          when(mockSharedPreferences.getInt('lastIncrementTimestamp'))
              .thenReturn(yesterday);
          when(mockSharedPreferences.getInt('streak')).thenReturn(3);

          await provider.init();

          expect(provider.streak, 3,
              reason: "The initial streak should be loaded correctly.");
        });
  });
}