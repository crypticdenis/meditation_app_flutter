import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/custom_app_bar.dart';
import 'package:meditation_app_flutter/timer_feature/time_picker.dart';
import 'package:meditation_app_flutter/timer_feature/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing_animation_widget.dart';
import 'package:meditation_app_flutter/timer_feature/timer_and_picker_logic.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({Key? key}) : super(key: key);

  @override
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
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
        print('Timer completed!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Breathing'),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 1),
              child: Column(
                children: [
                  if (_timerOperation != TimerOperation.reset)
                    const SizedBox(height: 10),
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
                  ),
                  if (_timerOperation != TimerOperation.reset)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: () => timerLogic.cancelTimer(),
                        child: Image.asset('assets/icons/cross.png', width: 30, height: 30),
                      ),
                    ),
                ],
              ),
            ),
            if (_timerOperation != TimerOperation.reset)
              SizedBox(height: 300, child: SinusoidalWaveWidget(timerOperation: _timerOperation)),
            const Spacer(),
            InkWell(
              onTap: () => timerLogic.toggleTimerOperation(_timerOperation),
              child: Image.asset(
                _timerOperation == TimerOperation.pause || _timerOperation == TimerOperation.reset ? 'assets/icons/play.png' : 'assets/icons/pause.png',
                width: 50,
                height: 50,
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
