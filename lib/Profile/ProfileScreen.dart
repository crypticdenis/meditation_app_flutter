import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart';
import 'sign_in.dart';
import 'after_log_success.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _showSignInModal(BuildContext context) {
    final gradientProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: gradientProvider.currentGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SignInScreen(
            onLoginSuccess: () {
              Navigator.pop(context);
              setState(() {
                _user = FirebaseAuth.instance.currentUser;
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradientProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradientProvider.currentGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: _user == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up for free to access our entire Music Library, all Settings, Backgrounds, Sounds, Statistics and more",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showSignInModal(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: Text('Sign Up'),
              ),
            ],
          )
              : AfterLogSuccess(),
        ),
      ),
    );
  }
}
