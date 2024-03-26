import 'package:flutter/material.dart';

// Enum used to control the TimerWidget's state.
enum TimerOperation { start, pause, resume, reset }
enum TimerDisplayMode {
  none,
  progressBar,
  timer,
  both,
}

Future<bool> showCancelConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel Timer'),
      content: const Text('Are you sure you want to cancel the timer?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Return false on cancel
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // Return true on confirm
          child: const Text('Yes'),
        ),
      ],
    ),
  );

  // If dialog is dismissed by tapping outside of it, treat it as 'false'
  return result ?? false;
}
