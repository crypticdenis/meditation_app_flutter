import 'package:flutter/material.dart';
import 'package:meditation_app/gradient_colors.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'custom_time_wheel.dart';
import 'app_bar.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Settings'),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Center(
          // Center the CustomTimeWheel for better UI
          child: CustomTimeWheel(
            itemCount: GradientColors.gradients.length,
            // Corrected to use GradientTheme
            itemExtent: 80,
            // Adjust based on your UI needs
            selectedValue: themeProvider.currentThemeIndex,
            onSelectedItemChanged: (index) => themeProvider.setTheme(index),
            mode: WheelMode.colors,
            colorNames: GradientColors.names, // Provide the list of color names
          ),
        ),
      ),
    );
  }
}
