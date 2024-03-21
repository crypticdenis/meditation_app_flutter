import 'package:flutter/material.dart';
import 'custom_time_wheel.dart';

class TimePicker extends StatefulWidget {
  final int initialMinute;
  final Function(int) onTimeSelected; // Callback for selected time

  const TimePicker({
    super.key,
    this.initialMinute = 10,
    required this.onTimeSelected,
  });

  @override
  TimerState createState() => TimerState();
}

class TimerState extends State<TimePicker> {
  int _selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    _selectedMinute = widget.initialMinute;
  }

  void _updateTime() {
    widget.onTimeSelected(_selectedMinute);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 250,
            child: CustomTimeWheel(
              itemCount: 241,
              selectedValue: _selectedMinute,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedMinute = index;
                });
                _updateTime();
              },
              autoScrollToItem: widget.initialMinute,
              mode: WheelMode.numbers,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Text(
              'min',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
