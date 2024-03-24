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

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final double _opacity = 1.0;
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
        // Handle what happens when the timer completes
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
      appBar: CustomAppBar(title: 'Meditation'),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Stack(
          children: [
            // Always visible TimePicker or TimerWidget depending on _timerOperation
            Column(
              children: [
                const SizedBox(height: 10), // Ensure there's always some space at the top
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
                if (_timerOperation != TimerOperation.reset)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () => timerLogic.cancelTimer(),
                      child: Image.asset('assets/icons/cross.png', width: 30, height: 30),
                    ),
                  ),
              ],
            ),
            // The pause/play button is always visible and functional
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () => timerLogic.toggleTimerOperation(_timerOperation),
                child: Image.asset(
                  _timerOperation == TimerOperation.pause || _timerOperation == TimerOperation.reset
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
