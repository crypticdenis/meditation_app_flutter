import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/providers/settings_provider.dart';
import 'package:meditation_app_flutter/custom_app_bar.dart';
import 'package:meditation_app_flutter/timer_feature/time_picker.dart';
import 'package:meditation_app_flutter/timer_feature/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/timer_feature/timer_and_picker_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  late TimerLogic timerLogic;
  TimerOperation _timerOperation = TimerOperation.reset;

  @override
  void initState() {
    super.initState();
    timerLogic = TimerLogic(
      context: context,
      onTimerOperationChange: (TimerOperation operation) {
        setState(() {
          _timerOperation = operation;
        });
      },
      onTimerComplete: () {
        print('Timer completed!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: ''),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                if (_timerOperation != TimerOperation.reset)
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: InkWell(
                      onTap: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Quit Session ?'),
                              actions: <Widget>[
                                TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                  ),
                                  onPressed: () {
                                    // Cancel the timer and close the dialog
                                    timerLogic.cancelTimer();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Image.asset('assets/icons/cross.png',
                          width: 20, height: 20),
                    ),
                  ),
                _timerOperation == TimerOperation.reset
                    ? TimePicker(
                        initialMinute: meditationTimeProvider.selectedMinute,
                        onTimeSelected: timerLogic.handleTimeSelected,
                      )
                    : TimerWidget(
                        minute: meditationTimeProvider.selectedMinute,
                        second: 0,
                        operation: _timerOperation,
                        onTimerComplete: () => timerLogic.resetTimer(),
                        // The display mode is dynamically adjusted based on settings
                        displayMode: settingsProvider.progressBarEnabled
                            ? (settingsProvider.timerEnabled
                                ? TimerDisplayMode.both
                                : TimerDisplayMode.progressBar)
                            : (settingsProvider.timerEnabled
                                ? TimerDisplayMode.timer
                                : TimerDisplayMode.none),
                      ),
              ],
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () => timerLogic.toggleTimerOperation(_timerOperation),
                child: Image.asset(
                  _timerOperation == TimerOperation.pause ||
                          _timerOperation == TimerOperation.reset
                      ? 'assets/icons/play.png'
                      : 'assets/icons/pause.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
