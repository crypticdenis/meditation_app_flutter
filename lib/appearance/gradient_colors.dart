import 'package:flutter/material.dart';

class GradientColors {
  static final List<LinearGradient> gradients = [
    // Midnight Pine
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00332C), Color(0xFF000033)], // Deep Forest Green to Midnight Blue
    ),
    // Twilight Mauve
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4B253A), Color(0xFF423B42)], // Dark Mauve to Twilight Grey
    ),
    // Dusk Amber
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4A2C00), Color(0xFF1B1B1B)], // Deep Amber to Dark Earth
    ),
    // Ocean Depths
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF003B46), Color(0xFF1B2A49)], // Deep Teal to Dark Slate Blue
    ),
    // Gothic Rose
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF45171D), Color(0xFF2F2F31)], // Dark Rose to Gothic Gray
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0E0F0F), Color(0xFF334756)], // Midnight Blue
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF202020), Color(0xFF646F4E)], // Dark Moss
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0A0F0B), Color(0xFF3C6E71)], // Forest Whisper
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF000000), Color(0xFF575600)], // Night Lemon
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF343837), Color(0xFF005F6B)], // Teal Shadow
    ),
  ];

  static final List<String> names = [
    'Midnight Pine',
    'Twilight Mauve',
    'Dusk Amber',
    'Ocean Depths',
    'Gothic Rose',
    'Midnight Blue',
    'Dark Moss',
    'Forest Whisper',
    'Night Lemon',
    'Teal Shadow',
  ];
}
