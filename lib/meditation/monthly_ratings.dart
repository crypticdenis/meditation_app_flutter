import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';

class MonthRatingWidget extends StatelessWidget {
  MonthRatingWidget({Key? key}) : super(key: key);

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

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


  @override
  Widget build(BuildContext context) {
    final Map<String, int> sampleRatings = Provider.of<RatingsProvider>(context).ratings;

    DateTime now = DateTime.now();
    int daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final List<BarChartGroupData> barGroups = List.generate(daysInMonth, (index) {
      // Use the first day of the month and add index to get the current day
      final date = DateTime(now.year, now.month, index + 1);
      final dateString = dateFormat.format(date);
      final entryValue = sampleRatings[dateString] ?? 0;

      // Calculate the width of the bar based on the number of days in the month
      double barWidth = MediaQuery.of(context).size.width / (daysInMonth * 2);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entryValue.toDouble(),
            color: getColorBasedOnValue(entryValue.toDouble()),
            width: barWidth,
          ),
        ],
      );
    });

    return Container(
      height: 220,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Colors.white12,
      ),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
      child: BarChart(
        BarChartData(
          maxY: 5,
          alignment: BarChartAlignment.spaceBetween,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                getTitlesWidget: (value, meta) {
                  // Show day of the month
                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text((value.toInt() + 1).toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10)),
                  );
                },
                reservedSize: 32,
                interval: 1,
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