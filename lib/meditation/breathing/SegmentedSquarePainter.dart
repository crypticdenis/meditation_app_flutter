import 'package:flutter/material.dart';
import 'dart:math' as math;

class SegmentedSquarePainter extends CustomPainter {
  final double phase;
  final int inhaleDuration;
  final int holdAfterInhaleDuration;
  final int exhaleDuration;
  final int holdAfterExhaleDuration;

  SegmentedSquarePainter({
    required this.phase,
    required this.inhaleDuration,
    required this.holdAfterInhaleDuration,
    required this.exhaleDuration,
    this.holdAfterExhaleDuration = 0,  // Default to 0 if not provided
  });

  @override
  void paint(Canvas canvas, Size size) {
    int totalDuration = inhaleDuration + holdAfterInhaleDuration + exhaleDuration + holdAfterExhaleDuration;
    double totalLength = 4 * size.width;  // Total perimeter of the square

    double inhaleLength = (inhaleDuration / totalDuration) * totalLength;
    double holdAfterInhaleLength = (holdAfterInhaleDuration / totalDuration) * totalLength;
    double exhaleLength = (exhaleDuration / totalDuration) * totalLength;
    double holdAfterExhaleLength = (holdAfterExhaleDuration / totalDuration) * totalLength;

    double currentLength = (phase / totalDuration) * totalLength;

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
      ..color = Color.lerp(Colors.purple, Colors.white, 0.5)!;  // Pastel purple

    if (currentLength <= inhaleLength) {
      _drawSegment(canvas, size, currentLength, inhalePaint);
    } else if (currentLength <= inhaleLength + holdAfterInhaleLength) {
      _drawSegment(canvas, size, inhaleLength, inhalePaint);
      _drawSegment(canvas, size, currentLength - inhaleLength, holdPaint);
    } else if (currentLength <= inhaleLength + holdAfterInhaleLength + exhaleLength) {
      _drawSegment(canvas, size, inhaleLength, inhalePaint);
      _drawSegment(canvas, size, holdAfterInhaleLength, holdPaint);
      _drawSegment(canvas, size, currentLength - inhaleLength - holdAfterInhaleLength, exhalePaint);
    } else if (holdAfterExhaleDuration > 0) {
      _drawSegment(canvas, size, inhaleLength, inhalePaint);
      _drawSegment(canvas, size, holdAfterInhaleLength, holdPaint);
      _drawSegment(canvas, size, exhaleLength, exhalePaint);
      _drawSegment(canvas, size, currentLength - inhaleLength - holdAfterInhaleLength - exhaleLength, holdPaint);
    } else {
      _drawSegment(canvas, size, inhaleLength, inhalePaint);
      _drawSegment(canvas, size, holdAfterInhaleLength, holdPaint);
      _drawSegment(canvas, size, currentLength - inhaleLength - holdAfterInhaleLength, exhalePaint);
    }
  }

  void _drawSegment(Canvas canvas, Size size, double length, Paint paint) {
    double remainingLength = length;
    Path path = Path();
    double side = size.width;

    if (remainingLength > 0) {
      double segment = math.min(remainingLength, side);
      path.moveTo(0, 0);
      path.lineTo(segment, 0);
      remainingLength -= segment;
    }

    if (remainingLength > 0) {
      double segment = math.min(remainingLength, side);
      path.moveTo(side, 0);
      path.lineTo(side, segment);
      remainingLength -= segment;
    }

    if (remainingLength > 0) {
      double segment = math.min(remainingLength, side);
      path.moveTo(side, side);
      path.lineTo(side - segment, side);
      remainingLength -= segment;
    }

    if (remainingLength > 0) {
      double segment = math.min(remainingLength, side);
      path.moveTo(0, side);
      path.lineTo(0, side - segment);
      remainingLength -= segment;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
