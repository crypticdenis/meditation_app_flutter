import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gong_provider.dart';
import '../custom_time_wheel.dart';
import 'gongs.dart';
import '../custom_app_bar.dart';
import '../providers/theme_provider.dart';

class GongSelectionScreen extends StatelessWidget {
  const GongSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gongProvider = Provider.of<GongProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Settings'),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Center(
          child: CustomTimeWheel(
            itemCount: GongSounds.names.length,
            selectedValue: gongProvider.currentGongIndex,
            onSelectedItemChanged: (index) => gongProvider.setGong(index),
            mode: WheelMode.gongs,
            // Assuming WheelMode has a text option.
            colorNames: GongSounds.names, // Provide the list of gong names.
          ),
        ),
      ),
    );
  }
}
