import 'package:flutter/material.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'app_bar.dart';
import 'time_picker.dart'; // Import your Timer widget



class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BreathingScreenState createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  int _selectedMinute = 10; // Default to 10 minutes as per your initState

  @override
  void initState() {
    super.initState();
  }

  void _handleTimeSelected(int minute) {
    setState(() {
      _selectedMinute = minute;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(title: 'Meditation'),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TimePicker(
                initialMinute: 10, // Preset or dynamically set
                onTimeSelected: _handleTimeSelected, // Implement in Timer
              ),
              ElevatedButton(
                onPressed: () {
                  // Display the selected time
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Selected Time: $_selectedMinute'),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}