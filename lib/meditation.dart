import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'app_bar.dart';
import 'time_picker.dart';
import 'timer.dart'; // Make sure this is the updated TimerWidget
import 'common_definitions.dart'; // Import common definitions
import 'providers/meditation_time_provider.dart';
import 'breathing_animation_widget.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  TimerOperation _timerOperation = TimerOperation.reset;
  double _opacity = 1.0;

  void _handleTimeSelected(int minute) {
    final provider =
        Provider.of<MeditationTimeProvider>(context, listen: false);
    provider.selectedMinute = minute;
  }

  void _startTimerExplicitly() {
    final provider =
        Provider.of<MeditationTimeProvider>(context, listen: false);
    if (provider.selectedMinute > 0) {
      setState(() {
        _timerOperation = TimerOperation.start;
      });
    }
  }

  void _cancelTimer() {
    setState(() {
      _timerOperation = TimerOperation.reset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final meditationTimeProvider = Provider.of<MeditationTimeProvider>(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Meditation'),
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
                    SizedBox(height: 10),
                  // Additional space to lift the timer up. Adjust this value as needed.
                  _timerOperation == TimerOperation.reset
                      ? TimePicker(
                          initialMinute: meditationTimeProvider.selectedMinute,
                          onTimeSelected: _handleTimeSelected,
                        )
                      : TimerWidget(
                          minute: meditationTimeProvider.selectedMinute,
                          second: 0,
                          operation: _timerOperation,
                          onTimerComplete: _resetTimer,
                        ),
                  if (_timerOperation != TimerOperation.reset)
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: InkWell(
                        onTap: _cancelTimer,
                        child: Image.asset('assets/icons/cross.png',
                            width: 30, height: 30),
                      ),
                    ),
                ],
              ),
            ),
            if (_timerOperation != TimerOperation.reset)
              Container(
                height: 300,
                // Adjust this height as needed for the SinusoidalWaveWidget.
                child: SinusoidalWaveWidget(),
              ),
            Spacer(),
            InkWell(
              onTap: _toggleTimerOperation,
              child: Image.asset(
                _timerOperation == TimerOperation.pause ||
                        _timerOperation == TimerOperation.reset
                    ? 'assets/icons/play.png'
                    : 'assets/icons/pause.png',
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
    ;
  }

  void _resetTimer() {
    setState(() {
      _timerOperation = TimerOperation.reset;
      print('Timer completed!');
    });
  }

  void _toggleTimerOperation() {
    setState(() {
      if (_timerOperation == TimerOperation.pause ||
          _timerOperation == TimerOperation.reset) {
        _startTimerExplicitly();
      } else {
        _timerOperation = TimerOperation.pause;
      }
    });
  }
}
