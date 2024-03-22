import 'package:flutter/material.dart';


class HomeScreenButton extends StatelessWidget {
  final String title;
  final IconData icon;

  const HomeScreenButton({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container( // Or any other appropriate widget
      width: 150, // Adjust button width as needed
      height: 75, // Adjust button height as needed
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25) // Add rounded corners if desired
      ),
      child: Row( // Use Row for horizontal layout
        mainAxisAlignment: MainAxisAlignment.start, // Align at the beginning
        children: [
          Icon(icon, color: Colors.white, size: 35), // Set icon color & size
          const SizedBox(width: 10), // Add spacing between icon and text
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 24),
          ),// Set text color & size
        ],
      ),
    );
  }
}