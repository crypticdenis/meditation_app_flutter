import 'package:flutter/material.dart';
import 'dart:math' as math;

class SegmentedCirclePainter extends CustomPainter {
  final double phase;
  final int inhaleDuration;
  final int holdDuration;
  final int exhaleDuration;

  SegmentedCirclePainter({
    required this.phase,
    required this.inhaleDuration,
    required this.holdDuration,
    required this.exhaleDuration,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int totalDuration = inhaleDuration + holdDuration + exhaleDuration;
    double inhaleAngle = (inhaleDuration / totalDuration) * 2 * math.pi;
    double holdAngle = (holdDuration / totalDuration) * 2 * math.pi;
    double exhaleAngle = (exhaleDuration / totalDuration) * 2 * math.pi;

    double startAngle = -math.pi / 2;

    Paint inhalePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Color.lerp(Colors.blue, Colors.white, 0.5)!;  // Pastel blue

    Paint holdPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Color.lerp(Colors.green, Colors.white, 0.5)!;  // Pastel green

    Paint exhalePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Color.lerp(Colors.purple, Colors.white, 0.5)!;  // Pastel red

    double minDimension = math.min(size.width, size.height);
    double padding = 2; // Add some padding to make the circle smaller
    Rect rect = Rect.fromLTWH(
      (size.width - minDimension) / 2 + padding,
      (size.height - minDimension) / 2 + padding,
      minDimension - 2 * padding,
      minDimension - 2 * padding,
    );

    if (phase < inhaleAngle) {
      canvas.drawArc(rect, startAngle, phase, false, inhalePaint);
    } else if (phase < inhaleAngle + holdAngle) {
      canvas.drawArc(rect, startAngle, inhaleAngle, false, inhalePaint);
      canvas.drawArc(rect, startAngle + inhaleAngle, phase - inhaleAngle, false, holdPaint);
    } else {
      canvas.drawArc(rect, startAngle, inhaleAngle, false, inhalePaint);
      canvas.drawArc(rect, startAngle + inhaleAngle, holdAngle, false, holdPaint);
      canvas.drawArc(rect, startAngle + inhaleAngle + holdAngle, phase - inhaleAngle - holdAngle, false, exhalePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
