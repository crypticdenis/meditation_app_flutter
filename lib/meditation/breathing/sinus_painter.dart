import 'package:flutter/material.dart';
import 'dart:math' as math;

class PulsatingCirclePainter extends CustomPainter {
  final double phase;

  PulsatingCirclePainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double maxRadius = size.width / 4;

    final double radius = (maxRadius * (1 + math.sin(phase))) / 2;

    final Paint paint = Paint()
      ..color = Colors.white // Circle color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
