import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/breathing_screen_files/sinus_painter.dart';

class SinusoidalWaveWidget extends StatefulWidget {
  final TimerOperation? timerOperation;
  final Function(TimerOperation)? onTimerOperationChanged;

  const SinusoidalWaveWidget({super.key, this.timerOperation, this.onTimerOperationChanged});

  @override
  _SinusoidalWaveWidgetState createState() => _SinusoidalWaveWidgetState();
}



class _SinusoidalWaveWidgetState extends State<SinusoidalWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    // You can start the animation here if necessary, or wait for the first update.
  }

  @override
  void didUpdateWidget(covariant SinusoidalWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timerOperation != oldWidget.timerOperation) {
      _handleTimerOperationChange(widget.timerOperation);
    }
  }

  void _handleTimerOperationChange(TimerOperation? operation) {
    if (operation == TimerOperation.pause) {
      _controller.stop();
    } else if (operation == TimerOperation.start || operation == TimerOperation.reset) {
      _controller.repeat(reverse: false);
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return CustomPaint(
      painter: SinusoidalPainter(
        phase: _animation.value,
      ),
      child: Container(height: 5),
    );
  }
}

