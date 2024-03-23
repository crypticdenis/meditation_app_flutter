import 'package:flutter/material.dart';

class HomeScreenButton extends StatelessWidget {
  final String title;
  final IconData icon;

  const HomeScreenButton({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 75,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 35),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }
}
