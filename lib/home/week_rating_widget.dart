import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';

class WeekRatingWidget extends StatelessWidget {
  WeekRatingWidget({Key? key}) : super(key: key);

  final daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Use the same format as in RatingsProvider

  Color getColorBasedOnValue(double value) {
    List<Color> colorGradient = [
      Colors.red, // 1
      Colors.deepOrange, // 2
      Colors.orangeAccent, // 3
      Colors.lightGreen, // 4
      Colors.green // 5
    ];
    int index = (value.clamp(1, 5)).round() - 1; // Adjusted to use 0-based index
    return colorGradient[index];
  }

  DateTime getWeekStart(DateTime current) {
    int daysFromMonday = current.weekday - 1;
    return current.subtract(Duration(days: daysFromMonday));
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> sampleRatings = Provider.of<RatingsProvider>(context).ratings;

    final List<BarChartGroupData> barGroups = List.generate(7, (index) {
      final weekStartDate = getWeekStart(DateTime.now());
      final date = weekStartDate.add(Duration(days: index));
      final dateString = dateFormat.format(date);

      final entryValue = sampleRatings[dateString] ?? 0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entryValue.toDouble(), // Directly using the rating value as the height
            color: getColorBasedOnValue(entryValue.toDouble()),
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
      padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 40, bottom: 12),
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
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, meta) {
                  // Show 1-5 scale on the left
                  return Text(value.toInt().toString(), style: TextStyle(color: Colors.white));
                },
                interval: 1, // Set interval to 1 to display all numbers from 1 to 5
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
