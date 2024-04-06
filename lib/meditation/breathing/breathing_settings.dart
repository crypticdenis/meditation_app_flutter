import 'package:flutter/material.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import 'package:meditation_app_flutter/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/breathing_rhythm_provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';

class BreathingSettingsScreen extends StatefulWidget {
  const BreathingSettingsScreen({Key? key}) : super(key: key);

  @override
  _BreathingSettingsScreenState createState() =>
      _BreathingSettingsScreenState();
}

class _BreathingSettingsScreenState extends State<BreathingSettingsScreen> {
  double _inhaleTime = 4; // Default value
  double _exhaleTime = 4; // Default value

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final breathingSettingsProvider =
          Provider.of<BreathingSettingsProvider>(context, listen: false);
      setState(() {
        _inhaleTime =
            breathingSettingsProvider.currentSettings.inhaleTime.toDouble();
        _exhaleTime =
            breathingSettingsProvider.currentSettings.exhaleTime.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        title: 'Set Rhythm',
        showSettingsButton: false,
        showSoundSettingsButton: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Inhale Seconds: ${_inhaleTime.toInt()}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SliderTheme(
                  // Customize the theme of the slider
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    activeTickMarkColor: Colors.black,
                    thumbColor: Colors.black,
                    valueIndicatorColor: Colors.black,
                  ),
                  child: Slider(
                    value: _inhaleTime,
                    min: 1,
                    max: 15,
                    divisions: 14,
                    label: _inhaleTime.toInt().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _inhaleTime = value;
                      });
                      _saveSettings(); // Call the save method directly within the setState
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Exhale Seconds: ${_exhaleTime.toInt()}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: Colors.white,
                    thumbColor: Colors.black,
                    activeTickMarkColor: Colors.black,
                    valueIndicatorColor: Colors.black,
                  ),
                  child: Slider(
                    value: _exhaleTime,
                    min: 1,
                    max: 15,
                    divisions: 14,
                    label: _exhaleTime.toInt().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _exhaleTime = value;
                      });
                      _saveSettings(); // Call the save method directly within the setState
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveSettings() {
    final provider = context.read<BreathingSettingsProvider>();
    provider.saveSettings(_inhaleTime.toInt(), _exhaleTime.toInt());
  }
}
