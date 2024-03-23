import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SinusoidalWaveWidget extends StatefulWidget {
  const SinusoidalWaveWidget({super.key});

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
    )..repeat(reverse: false);

    _animation =
        Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
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
        dotGradient: themeProvider.currentGradient,
      ),
      child: Container(height: 5),
    );
  }
}

class SinusoidalPainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final double phase;
  final Paint wavePaint;
  late Paint dotPaint;
  final Gradient dotGradient;

  SinusoidalPainter({
    this.amplitude = 60.0,
    this.frequency = 1.5,
    this.phase = 0.0,
    required this.dotGradient,
  }) : wavePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 20.0 {
    dotPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    double dotX = size.width / 2;
    double dotY = size.height / 2 +
        amplitude *
            math.sin((2 * math.pi * frequency * dotX / size.width) + phase);
    Rect dotRect = Rect.fromCircle(center: Offset(dotX, dotY), radius: 10.0);
    dotPaint.shader = dotGradient.createShader(dotRect);

    for (double x = 0.0; x < size.width; x += 1) {
      double y = size.height / 2 +
          amplitude *
              math.sin((2 * math.pi * frequency * x / size.width) + phase);
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, wavePaint);
    canvas.drawCircle(Offset(dotX, dotY), 10.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
