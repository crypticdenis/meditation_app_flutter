import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'mocks.mocks.dart';
import 'package:intl/intl.dart';

void main() {
  group('RatingsProvider Tests', () {
    late MockSharedPreferences mockSharedPreferences;
    late RatingsProvider ratingsProvider;

    setUp(() async {
      mockSharedPreferences = MockSharedPreferences();

      // Setup common stubs for SharedPreferences methods
      when(mockSharedPreferences.containsKey(any)).thenReturn(false); // Assume no values exist initially
      when(mockSharedPreferences.getStringList(any)).thenReturn(null);
      when(mockSharedPreferences.setStringList(any, any)).thenAnswer((_) async => true);

      ratingsProvider = RatingsProvider(prefs: mockSharedPreferences);
      await ratingsProvider.init(); // Ensure provider is initialized
    });

    test('Initial ratings should be empty', () async {
      expect(ratingsProvider.ratings, isEmpty);
    });

    test('Loading ratings from SharedPreferences', () async {
      when(mockSharedPreferences.getStringList('ratings')).thenReturn([
        '2024-03-30:5',
        '2024-03-28:3'
      ]);

      await ratingsProvider.loadRatings();

      expect(ratingsProvider.ratings, {
        DateTime.parse('2024-03-30'): 5,
        DateTime.parse('2024-03-28'): 3,
      });
    });

    test('Saving and loading a new rating', () async {
      // Get the current date and time
      final now = DateTime.now().toUtc();

      // Format the date into a string (you can customize the format if needed)
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      // Add the rating with the formatted date
      await ratingsProvider.addRating(formattedDate, 4);

      // We don't have direct access to verify against `mockSharedPreferences`.
      // Instead, let's load it back and verify the content:
      await ratingsProvider.loadRatings();

      final today = DateTime.now().toString().split(' ')[0]; // Get today's date string
      expect(ratingsProvider.ratings, containsPair(today, 4));
    });

    // You can add more tests here if you have additional edge cases or
    // functionality within your RatingsProvider class that needs testing
  });
}