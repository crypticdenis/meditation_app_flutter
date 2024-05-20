import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';

class AfterLogSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    void _logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst); // Go back to home screen
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.currentGradient,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                'You have successfully logged in!',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
