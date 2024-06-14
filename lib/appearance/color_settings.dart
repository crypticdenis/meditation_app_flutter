import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'package:meditation_app_flutter/custom_time_wheel.dart';
import 'package:meditation_app_flutter/Profile/sign_in.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Future<bool> showSignInDialog() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        final result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sign In Required'),
            content: Text('Sign in now to unlock this sound.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Close the dialog
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SignInScreen(
                      onLoginSuccess: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                    ),
                  );
                },
                child: Text('Sign In'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
        return result ?? false;
      } else {
        return true;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          final result = await showSignInDialog();
          return result;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: themeProvider.currentGradient,
              ),
              child: Center(
                child: CustomTimeWheel(
                  itemCount: themeProvider.gradientData.length,
                  itemExtent: 80,
                  selectedValue: themeProvider.currentThemeIndex,
                  onSelectedItemChanged: (index) =>
                      themeProvider.setTheme(index),
                  mode: WheelMode.colors,
                  colorNames: themeProvider.gradientData
                      .map<String>((data) => data['name'] as String)
                      .toList(),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 16,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                  print('Back button pressed');
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    print('User is not signed in');
                    await showSignInDialog();
                  } else {
                    print('User is signed in');
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
