import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> getRandomQuote() async {
  final prefs = await SharedPreferences.getInstance();
  final lastQuoteTime = prefs.getInt('last_quote_time');
  final currentTime = DateTime.now().millisecondsSinceEpoch;

  if (lastQuoteTime != null &&
      DateTime.fromMillisecondsSinceEpoch(lastQuoteTime).add(Duration(days: 1)).isAfter(DateTime.now())) {
    final lastQuote = prefs.getString('last_quote');
    final lastAuthor = prefs.getString('last_author');
    if (lastQuote != null && lastAuthor != null) {
      return {"quote": lastQuote, "author": lastAuthor};
    }
  }

  // If there's no valid cached quote, fetch a new one
  final String response = await rootBundle.loadString('assets/quotes.json');
  final List<dynamic> quotes = json.decode(response);
  final randomIndex = Random().nextInt(quotes.length);
  final newQuote = quotes[randomIndex]['quote'];
  final newAuthor = quotes[randomIndex]['author'];

  // Save the new quote and the current time to SharedPreferences
  await prefs.setString('last_quote', newQuote);
  await prefs.setString('last_author', newAuthor);
  await prefs.setInt('last_quote_time', currentTime);

  return {"quote": newQuote, "author": newAuthor};
}


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


void showQuitSessionDialog(BuildContext context, VoidCallback onCancel, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Quit Session?'),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onCancel(); // Call the onCancel callback if provided
            },
            child: const Text('No'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.red),
            ),
            onPressed: () {
              onConfirm(); // Call the onConfirm callback, which contains the logic to execute on confirmation
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
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



  //From Meditation Guided Sessions feature:

Widget buildSectionHeader(String title) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
      child: Text(title,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
    ),
  );
}

final List<Map<String, String>> sessionAssets = [
  {'image': 'assets/images/nature1.png', 'title': 'Relaxation', 'duration': '6 min'},
  {'image': 'assets/images/nature2.png', 'title': 'Deep Sleep', 'duration': '9 min'},
  {'image': 'assets/images/nature3.png', 'title': 'Anxiety Relief', 'duration': '5 min'},
];

Widget _buildImageInfoRow() {
  return SizedBox(
    height: 180,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: sessionAssets.length,
      itemBuilder: (context, index) {
        final session = sessionAssets[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              // Handle your onTap action here
            },
            child: Container(
              width: 240, // Set a fixed width for the container
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  fit: StackFit.expand, // Make the stack fill the container
                  children: [
                    Image.asset(
                      session['image']!,
                      fit: BoxFit.cover, // This ensures the image covers the whole area of the container
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5), // Semi-transparent black
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 30, // Adjust the position as needed
                      child: Text(
                        session['title']!,
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8, // Adjust the position so it's just below the title
                      child: Text(
                        "${session['duration']} min", // Assuming 'duration' is a key in your session map
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}