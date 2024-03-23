import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../custom_app_bar.dart';
import '../timer_feature/time_picker.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  int _selectedMinute = 10;

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
                initialMinute: 10,
                onTimeSelected: _handleTimeSelected,
              ),
              ElevatedButton(
                onPressed: () {
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
