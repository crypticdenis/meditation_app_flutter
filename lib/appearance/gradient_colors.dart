import 'package:flutter/material.dart';

class GradientColors {
  static final List<LinearGradient> gradients = [
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF43cea2), Color(0xFF185a9d)], // Seafoam Blue
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFf80759), Color(0xFFbc4e9c)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF590677), Color(0xFF19163C)], // Purple Dusk
    ),
    // New gradients that complement white fonts
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0072ff), Color(0xFF00c6ff)], // Deep Ocean to Sky Blue
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFfa709a), Color(0xFFfee140)], // Sunset Twilight
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF123456), Color(0xFF654321)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00467F), Color(0xFFFFB88C)], // Twilight Blues and Oranges
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6a11cb), Color(0xFF2575fc)], // Royal Purple to Soft Lilac
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF333333), Color(0xFFdd1818)], // Crimson Fade
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF6E7F), Color(0xFFFFB88C)],
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF654ea3), Color(0xFFeaafc8)], // Lavender Field
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFff9966), Color(0xFFff5e62)], // Warm Sunset
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF12c2e9), Color(0xFFc471ed), Color(0xFFf64f59)], // Celestial Dive
    ),
  ];

  static final List<String> names = [
    'Seafoam Blue',
    'Pink Bloom',
    'Purple Dusk',
    'Deep Ocean Sky',
    'Sunset Orange',
    'Sunset Twilight',
    'Twilight Blues and Oranges',
    'Royal Purple Lilac',
    'Crimson Fade',
    'Lavender Field',
    'Rose Dawn',
    'Warm Sunset',
    'Celestial Dive',
  ];
}
