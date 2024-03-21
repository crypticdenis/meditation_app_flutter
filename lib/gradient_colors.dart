import 'package:flutter/material.dart';

class GradientColors {
  static final List<LinearGradient> gradients = [
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF590677), Color(0xFF19163C)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF123456), Color(0xFF654321)],
    ),
    // New gradients
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF74ebd5), Color(0xFFACB6E5)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFE000), Color(0xFF799F0C)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF6E7F), Color(0xFFFFB88C)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFf80759), Color(0xFFbc4e9c)],
    ),
  ];

  static final List<String> names = [
    'Purple Dusk',
    'Sunset Orange',
    // New names
    'Mint Mirage',
    'Lemon Drizzle',
    'Rose Dawn',
    'Ocean Azure',
    'Pink Bloom',
  ];
}
