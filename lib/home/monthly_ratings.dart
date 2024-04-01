import 'package:flutter/cupertino.dart';
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
    int index =
        (value.clamp(1, 5)).round() - 1; // Adjusted to use 0-based index
    return colorGradient[index];
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> sampleRatings =
        Provider.of<RatingsProvider>(context).ratings;

    DateTime now = DateTime.now();
    int daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final List<BarChartGroupData> barGroups =
        List.generate(daysInMonth, (index) {
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

    final String monthName =
        DateFormat('MMMM').format(now); // e.g., March 2024

    return Container(
      height: 220,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Colors.white12,
      ),
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(monthName,
                  style: TextStyle(fontSize: 16, color: Colors.white30)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 18.0, top: 40, bottom: 2),
            child: BarChart(
              BarChartData(
                maxY: 5,
                alignment: BarChartAlignment.spaceBetween,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true, // Changed to true to show titles
                      getTitlesWidget: (value, meta) {
                        final DateTime date =
                            DateTime(now.year, now.month, value.toInt() + 1);
                        final bool isMonday = date.weekday == DateTime.monday;

                        if (isMonday) {
                          // Display the date for Mondays
                          final String formattedDate =
                              DateFormat('d.').format(date); // e.g., Mar 5
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(formattedDate,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          );
                        } else {
                          // For days that are not Monday, return an empty Container or adjust as needed
                          return Container();
                        }
                      },
                      reservedSize: 28,
                      interval:
                          1, // You might adjust the interval if you only want to check every 7 days, though this may miss some Mondays depending on the month's starting day
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
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
