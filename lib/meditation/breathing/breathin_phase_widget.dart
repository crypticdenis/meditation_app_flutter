import 'package:flutter/material.dart';

class BreathingPhaseWidget extends StatelessWidget {
  final String currentPhase;

  BreathingPhaseWidget({required this.currentPhase});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPhaseBox('In', 'inhale'),
        _buildPhaseBox('Hold', 'hold'),
        _buildPhaseBox('Out', 'exhale'),
      ],
    );
  }

  Widget _buildPhaseBox(String text, String phase) {
    bool isActive = currentPhase == phase;
    Color? activeColor;

    switch (phase) {
      case 'inhale':
        activeColor = Color.lerp(Colors.blue, Colors.white, 0.5);
        break;
      case 'hold':
        activeColor = Color.lerp(Colors.green, Colors.white, 0.5);
        break;
      case 'exhale':
        activeColor = Color.lerp(Colors.purple, Colors.white, 0.5);
        break;
      default:
        activeColor = Colors.grey[700];
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.grey[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(
            phase == 'inhale'
                ? Icons.arrow_downward
                : phase == 'hold'
                ? Icons.pause
                : Icons.arrow_upward,
            color: Colors.white,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
