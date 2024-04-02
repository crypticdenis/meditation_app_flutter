import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/appearance/gradient_colors.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/custom_time_wheel.dart';
import 'package:meditation_app_flutter/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: '',
        showSettingsButton: false,
        showSoundSettingsButton: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Center(
          child: CustomTimeWheel(
            itemCount: GradientColors.gradients.length,
            itemExtent: 80,
            selectedValue: themeProvider.currentThemeIndex,
            onSelectedItemChanged: (index) => themeProvider.setTheme(index),
            mode: WheelMode.colors,
            colorNames: GradientColors.names,
          ),
        ),
      ),
    );
  }
}
