import 'package:flutter/material.dart';

enum TimerOperation { start, pause, resume, reset }

enum TimerDisplayMode {
  none,
  progressBar,
  timer,
  both,
}

enum SelectedPeriod { week, month, year }

double roundToNearestHalf(double value) {
  return (value * 2).roundToDouble() / 2;
}

DateTime getWeekStart(DateTime current) {
  int daysFromMonday = current.weekday - 1;
  return current.subtract(Duration(days: daysFromMonday));
}

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

Color getColorBasedOnAverageValue(double average) {
  int index =
      roundToNearestHalf(average).clamp(0, colorGradient.length).toInt() * 2;
  print('index');
  print(index);
  return colorGradient[index];
}

  Future<bool> showCancelConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Cancel Timer'),
            content: const Text('Are you sure you want to cancel the timer?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                // Return false on cancel
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                // Return true on confirm
                child: const Text('Yes'),
              ),
            ],
          ),
    );

    // If dialog is dismissed by tapping outside of it, treat it as 'false'
    return result ?? false;
  }
