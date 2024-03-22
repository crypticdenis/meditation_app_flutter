import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'app_bar.dart';
import 'time_picker.dart';
import 'timer.dart'; // Make sure this is the updated TimerWidget
import 'common_definitions.dart'; // Import common definitions
import 'providers/meditation_time_provider.dart';

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
    print('gong is now playing');
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(seconds: 1),
                child: _timerOperation == TimerOperation.reset
                    ? TimePicker(
                        initialMinute: meditationTimeProvider.selectedMinute,
                        onTimeSelected: _handleTimeSelected,
                      )
                    : TimerWidget(
                        minute: meditationTimeProvider.selectedMinute,
                        // Use provider's minute
                        second: 0,
                        operation: _timerOperation,
                        onTimerComplete: () {
                          setState(() {
                            _timerOperation = TimerOperation.reset;
                          });
                          print('Timer completed!');
                        },
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (_timerOperation == TimerOperation.pause ||
                          _timerOperation == TimerOperation.reset) {
                        // This means the timer is currently paused or not started, so we want to start/resume the timer.
                        _startTimerExplicitly();
                      } else {
                        // Otherwise, the timer is currently running, so we want to pause it.
                        setState(() {
                          _timerOperation = TimerOperation.pause;
                        });
                      }
                    },
                    child: (_timerOperation == TimerOperation.pause ||
                            _timerOperation == TimerOperation.reset)
                        ? Image.asset('assets/icons/play.png',
                            width: 50, height: 50)
                        : Image.asset('assets/icons/pause.png',
                            width: 50, height: 50),
                  ),
                  if (_timerOperation != TimerOperation.reset)
                    Padding(
                      padding: const EdgeInsets.all(100),
                      child: InkWell(
                        onTap: _cancelTimer,
                        child: Image.asset('assets/icons/cross.png',
                            width: 50,
                            height:
                                50), // Assuming you want to use a cancel icon here
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
