import 'dart:math' as math;
import 'package:flutter/material.dart';

class SinusoidalPainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final double phase;
  final Paint wavePaint;

  SinusoidalPainter({
    this.amplitude =
        60.0, // This is the maximum height the dot will move up or down.
    this.frequency = 1.5, // Increase the frequency to compress the wave
    this.phase = 0.0,
  }) : wavePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8.0;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
