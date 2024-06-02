import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'monthly_ratings.dart';
import 'yearly_rating.dart';
import 'week_rating_widget.dart';
import 'package:meditation_app_flutter/providers/streak_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  AnalyticsScreenState createState() => AnalyticsScreenState();
}

class AnalyticsScreenState extends State<AnalyticsScreen> {
  SelectedPeriod _selectedPeriod = SelectedPeriod.week;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final streakProvider = Provider.of<StreakProvider>(context);
    final currentStreak = streakProvider.streak;

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient:
              themeProvider.currentGradient, // Ensure themeProvider is defined
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Current Streak: $currentStreak",
                      style:
                      const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 55, bottom: 15),
              child: Text(
                'Ratings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            ToggleButtons(
              borderColor: Colors.transparent,
              borderWidth: 2,
              selectedBorderColor: Colors.transparent,
              selectedColor: Colors.white,
              color: Colors.white30,
              fillColor: Colors.white12,
              borderRadius: BorderRadius.circular(8),
              onPressed: (int index) {
                setState(() {
                  if (index == 0) {
                    _selectedPeriod = SelectedPeriod.week;
                  } else if (index == 1) {
                    _selectedPeriod = SelectedPeriod.month;
                  } else {
                    _selectedPeriod = SelectedPeriod.year;
                  }
                });
              },
              isSelected: [
                _selectedPeriod == SelectedPeriod.week,
                _selectedPeriod == SelectedPeriod.month,
                _selectedPeriod == SelectedPeriod.year,
              ],
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('W'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('M'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Y'),
                ),
              ],
            ),
            SizedBox(
              child: _selectedPeriod == SelectedPeriod.week
                  ? WeekRatingWidget()
                  : (_selectedPeriod == SelectedPeriod.month
                      ? MonthRatingWidget()
                      : YearRatingWidget()),
            ),
          ],
        ),
      ),
    );
  }
}
