import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/ratings_provider.dart';
import 'package:flutter/cupertino.dart';

class YearRatingWidget extends StatelessWidget {
  YearRatingWidget({Key? key}) : super(key: key);

  final DateFormat monthFormat = DateFormat('MMM');
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  Color getColorBasedOnAverageValue(double average) {
    const List<Color> colorGradient = [
      Colors.white, //0
      Colors.white, //0
      Colors.red, // 1 2
      Colors.deepOrange, // 2 4
      Colors.orange, // 2.5 5
      Colors.orangeAccent, // 3 6
      Colors.yellow, // 3 6
      Colors.yellowAccent, // 3.5 7
      Colors.lightGreenAccent, // 4 8
      Colors.lightGreen, // 4.5 9
      Colors.green, // 5 10
    ];

    int index =
        roundToNearestHalf(average).clamp(0, colorGradient.length).toInt() * 2;
    print('index');
    print(index);
    return colorGradient[index];
  }

  double roundToNearestHalf(double value) {
    return (value * 2).roundToDouble() / 2;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> sampleRatings =
        Provider.of<RatingsProvider>(context).ratings;

    final List<BarChartGroupData> barGroups = List.generate(12, (monthIndex) {
      double totalRatings = 0;
      int ratingDaysCount = 0;

      DateTime monthStart = DateTime(DateTime.now().year, monthIndex + 1, 1);
      int daysInMonth =
          DateUtils.getDaysInMonth(monthStart.year, monthStart.month);

      for (int day = 1; day <= daysInMonth; day++) {
        final dateString =
            dateFormat.format(DateTime(monthStart.year, monthStart.month, day));
        if (sampleRatings.containsKey(dateString)) {
          totalRatings += sampleRatings[dateString]!;
          ratingDaysCount++;
        }
      }

      double averageRating =
          ratingDaysCount > 0 ? totalRatings / ratingDaysCount : 0;
      // Round the average rating to the nearest 0.5 increment
      averageRating = roundToNearestHalf(averageRating);

      print('averageRating');
      print(averageRating);

      return BarChartGroupData(
        x: monthIndex,
        barRods: [
          BarChartRodData(
            toY: averageRating,
            color: getColorBasedOnAverageValue(averageRating),
            width: 15,
          ),
        ],
      );
    });

    final String yearName = DateFormat('yyyy').format(DateTime.now());

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
              child: Text(yearName,
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
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        // Use a valid year for creating the DateTime object.
                        return Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                              monthFormat
                                  .format(DateTime(2000, value.toInt() + 1)),
                              // Placeholder year 2000, valid month
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        );
                      },
                      reservedSize: 28,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
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
