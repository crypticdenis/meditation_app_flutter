import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';

class WeekRatingWidget extends StatelessWidget {
  WeekRatingWidget({Key? key}) : super(key: key);

  final daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Color getColorBasedOnAverageValue(double average) {
    int index =
        roundToNearestHalf(average).clamp(0, colorGradient.length).toInt() * 2;
    print('index');
    print(index);
    return colorGradient[index];
  }

  @override
  Widget build(BuildContext context) {
    final ratingsProvider = Provider.of<RatingsProvider>(context);
    final Map<String, List<int>> sampleRatings = ratingsProvider.ratings;

    final weekStartDate = getWeekStart(DateTime.now());
    final List<BarChartGroupData> barGroups = List.generate(7, (index) {
      final date = weekStartDate.add(Duration(days: index));
      final dateString = dateFormat.format(date);

      // Retrieve the list of ratings for the current day
      final List<int> dailyRatings = sampleRatings[dateString] ?? [];
      // Calculate the average rating for the day
      final double averageRating = dailyRatings.isNotEmpty
          ? dailyRatings.reduce((a, b) => a + b) / dailyRatings.length
          : 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: roundToNearestHalf(averageRating),
            color: getColorBasedOnAverageValue(averageRating),
            width: 15,
          ),
        ],
      );
    });

    return Container(
      height: 220,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white12,
      ),
      margin: const EdgeInsets.all(15),
      padding:
          const EdgeInsets.only(right: 18.0, left: 12.0, top: 40, bottom: 12),
      child: BarChart(
        BarChartData(
          maxY: 5,
          alignment: BarChartAlignment.spaceBetween,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(daysOfWeek[value.toInt() % daysOfWeek.length],
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, meta) {
                  // Show 1-5 scale on the left
                  return Text(value.toInt().toString(),
                      style: TextStyle(color: Colors.white));
                },
                interval: 1,
                // Set interval to 1 to display all numbers from 1 to 5
                reservedSize: 28, // Adjust the size as needed
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
