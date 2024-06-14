import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class CongratulatoryDialog extends StatefulWidget {
  @override
  _CongratulatoryDialogState createState() => _CongratulatoryDialogState();
}

class _CongratulatoryDialogState extends State<CongratulatoryDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Close the dialog after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: AlertDialog(
        title: Center(
          child: Text(
            '🧘🏿‍♂️ Congratulations! 🧘‍♀️',
            style: TextStyle(fontSize: 24), // Increased font size
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Minimize the height of the column
          children: [
            Center(
              child: Text(
                'Take a moment to appreciate the time you’ve dedicated to your well-being.',
                style: TextStyle(fontSize: 18), // Increased font size
                textAlign: TextAlign.center, // Center the content text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
