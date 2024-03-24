import 'dart:math' as math;
import 'package:flutter/material.dart';

class SinusoidalPainter extends CustomPainter {
  final double amplitude;
  final double frequency;
  final double phase;
  final Paint wavePaint;
  late Paint dotPaint;

  SinusoidalPainter({
    this.amplitude = 60.0,
    this.frequency = 1.5,
    this.phase = 0.0,
  }) : wavePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 20.0 {
    dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    double dotX = size.width / 2;
    double dotY = size.height / 2 +
        amplitude *
            math.sin((2 * math.pi * frequency * dotX / size.width) + phase);
    Rect dotRect = Rect.fromCircle(center: Offset(dotX, dotY), radius: 10.0);

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
