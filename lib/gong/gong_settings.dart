import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gong_provider.dart';
import '../custom_time_wheel.dart';
import 'gongs.dart';
import '../custom_app_bar.dart';
import '../providers/theme_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';

class GongSelectionScreen extends StatelessWidget {
  const GongSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gongProvider = Provider.of<GongProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
          title: '', showSettingsButton: false, showSoundSettingsButton: false),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Column(
            children: [
            const SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
          alignment: Alignment.center, // Ensures the text is centered
          children: [
            buildSectionHeader('Gongs'),
            Align(
              alignment: Alignment.centerRight,
              // Aligns the switch to the right
              child: Switch(
                value: gongProvider.gongEnabled,
                onChanged: (bool value) {
            gongProvider.toggleGongEnabled();
                },
                activeColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20), // Rounded edges
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20)
                .copyWith(bottom: 30), // Adjust margins
            child: CustomTimeWheel(
              itemCount: GongSounds.names.length,
              selectedValue: gongProvider.currentGongIndex,
              onSelectedItemChanged: (index) =>
                  gongProvider.setGong(index),
              mode: WheelMode.gongs,
              colorNames: GongSounds.names,
            ),
          ),
        ),
      ),
      ],
    ),)
    ,
    );
  }
}
