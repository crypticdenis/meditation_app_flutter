import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'app_bar.dart';
import 'dart:async';
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
  String _breathingInstruction = '';
  int _countdown = 3; // For countdown from 3 to 1
  double _textOpacity = 1.0; // For controlling text opacity

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
        _breathingInstruction = '';
        _countdown = 3; // Reset countdown
        _textOpacity = 1.0; // Ensure text is fully visible initially
      });

      Timer.periodic(Duration(seconds: 1), (timer) {
        if (_countdown > 0) {
          setState(() {
            _breathingInstruction = '$_countdown';
            _textOpacity = 1.0; // Make number visible
          });
          // Start fading out the number after a short delay
          Future.delayed(Duration(milliseconds: 500), () {
            // Adjust this delay as needed
            setState(() {
              _textOpacity = 0.0; // Fade out the number
            });
          });

          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel(); // Stop the countdown
          // After last countdown number has faded, proceed with "Breathe In"
          Future.delayed(Duration(milliseconds: 300), () {
            // Adjust this to allow last number to fade
            setState(() {
              _breathingInstruction = 'Breathe In';
              _textOpacity = 1.0; // Ensure "Breathe In" is fully visible
            });

            // After "Breathe In" is displayed for 4 seconds, start fading it out
            Future.delayed(Duration(seconds: 4), () {
              setState(() {
                _textOpacity = 0.0; // Start fading out "Breathe In"
              });

              // After fading out "Breathe In", display and fade out "Breathe Out"
              Future.delayed(Duration(seconds: 1), () {
                setState(() {
                  _breathingInstruction = 'Breathe Out';
                  _textOpacity = 1.0; // Ensure "Breathe Out" is fully visible
                });
                Future.delayed(Duration(seconds: 4), () {
                  setState(() {
                    _textOpacity = 0.0; // Start fading out "Breathe Out"
                  });

                  // After fading out "Breathe Out", display and fade out "Follow the flow"
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      _breathingInstruction = 'Follow the Flow';
                      _textOpacity =
                          1.0; // Ensure "Follow the flow" is fully visible
                    });
                    Future.delayed(Duration(seconds: 4), () {
                      setState(() {
                        _textOpacity =
                            0.0; // Start fading out "Follow the flow"
                      });
                    });
                  });
                });
              });
            });
          });
        }
      });
    }
  }

  void _cancelTimer() {
    setState(() {
      _timerOperation = TimerOperation.reset;
      _breathingInstruction = ''; // Clear breathing instruction on cancel
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
                child: SinusoidalWaveWidget(),
              ),
            AnimatedOpacity(
              opacity: _textOpacity,
              duration: Duration(seconds: 1),
              // Adjust this duration to control the fade speed
              child: Text(
                _breathingInstruction,
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
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
  }

  void _resetTimer() {
    setState(() {
      _timerOperation = TimerOperation.reset;
      _breathingInstruction = ''; // Clear breathing instruction on reset
      print('Timer completed!');
    });
  }

  void _toggleTimerOperation() {
    if (_timerOperation == TimerOperation.pause ||
        _timerOperation == TimerOperation.reset) {
      _startTimerExplicitly();
    } else {
      setState(() {
        _timerOperation = TimerOperation.pause;
      });
    }
  }
}
