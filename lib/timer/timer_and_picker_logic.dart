import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';


class TimerLogic {
  late final BuildContext context;
  late Function(TimerOperation) onTimerOperationChange;
  late Function() onTimerComplete;

  TimerLogic({
    required this.context,
    required this.onTimerOperationChange,
    required this.onTimerComplete,
  });

  void handleTimeSelected(int minute) {
    print("this handleTimeSelected is in use tapl");
    final provider = Provider.of<MeditationTimeProvider>(context, listen: false);
    provider.selectedMinute = minute;
  }

  void startTimer() {
    print("this startTimer is in use tapl");
    final provider = Provider.of<MeditationTimeProvider>(context, listen: false);
    if (provider.selectedMinute > 0) {
      onTimerOperationChange(TimerOperation.start);
    }
  }

  void cancelTimer() {
    print("this cancelTimer is in use tapl");
    onTimerOperationChange(TimerOperation.reset);
  }

  void resetTimer() {
    print("this resetTimer is in use tapl");
    onTimerOperationChange(TimerOperation.reset);
    onTimerComplete();
  }

  void toggleTimerOperation(TimerOperation currentOperation) {
    print("this toggleTimerOperation is in use tapl");
    if (currentOperation == TimerOperation.pause || currentOperation == TimerOperation.reset) {
      startTimer();
    } else {
      print("this toggleTimerOperation is in use tapl");
      onTimerOperationChange(TimerOperation.pause);
    }
  }
}

