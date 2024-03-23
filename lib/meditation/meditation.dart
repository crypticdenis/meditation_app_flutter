import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/custom_app_bar.dart';
import 'dart:async';
import 'package:meditation_app_flutter/timer_feature/time_picker.dart';
import 'package:meditation_app_flutter/timer_feature/timer.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/providers/meditation_time_provider.dart';
import 'package:meditation_app_flutter/breathing_screen_files/breathing_animation_widget.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  TimerOperation _timerOperation = TimerOperation.reset;
  final double _opacity = 1.0;
  String _breathingInstruction = '';
  int _countdown = 3;
  double _textOpacity = 1.0;

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
        _countdown = 3;
        _textOpacity = 1.0;
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdown > 0) {
          setState(() {
            _breathingInstruction = '$_countdown';
            _textOpacity = 1.0;
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _textOpacity = 0.0;
            });
          });

          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _breathingInstruction = 'Breathe In';
              _textOpacity = 1.0;
            });

            Future.delayed(const Duration(seconds: 4), () {
              setState(() {
                _textOpacity = 0.0;
              });

              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _breathingInstruction = 'Breathe Out';
                  _textOpacity = 1.0;
                });
                Future.delayed(const Duration(seconds: 4), () {
                  setState(() {
                    _textOpacity = 0.0;
                  });

                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      _breathingInstruction = 'Follow the Flow';
                      _textOpacity = 1.0;
                    });
                    Future.delayed(const Duration(seconds: 4), () {
                      setState(() {
                        _textOpacity = 0.0;
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
      _breathingInstruction = '';
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
                    const SizedBox(height: 10),
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
              SizedBox(
                height: 300,
                child: SinusoidalWaveWidget(),
              ),
            AnimatedOpacity(
              opacity: _textOpacity,
              duration: const Duration(seconds: 1),
              child: Text(
                _breathingInstruction,
                style: const TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
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
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }

  void _resetTimer() {
    setState(() {
      _timerOperation = TimerOperation.reset;
      _breathingInstruction = '';
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
