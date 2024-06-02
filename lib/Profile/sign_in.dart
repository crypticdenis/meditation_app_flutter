import 'package:flutter/material.dart';
import 'login_logic.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app_flutter/providers/theme_provider.dart'; // Import GradientProvider

class SignInScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  SignInScreen({required this.onLoginSuccess});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUp = false;

  final LoginLogic _loginLogic = LoginLogic();

  @override
  Widget build(BuildContext context) {
    final gradientProvider = Provider.of<ThemeProvider>(context); // Use GradientProvider
    final focusColor = Colors.white; // Desired focus color

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: gradientProvider.currentGradient, // Apply gradient
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              // Centered content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: focusColor),
                        ),
                        labelText: 'Email',
                        hintText: 'Enter your email here',
                        labelStyle: TextStyle(color: focusColor),
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white),
                      cursorColor: focusColor,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: focusColor),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter your password here',
                        labelStyle: TextStyle(color: focusColor),
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      cursorColor: focusColor,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_isSignUp) {
                            await _loginLogic.signUp(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              context: context,
                            );
                          } else {
                            await _loginLogic.signIn(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              context: context,
                            );
                          }
                          setState(() {
                            _isLoading = false;
                          });
                          widget.onLoginSuccess();
                        },
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(
                          _isSignUp ? 'Sign Up' : 'Log In',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                        });
                      },
                      child: Text(
                        _isSignUp
                            ? 'Already have an account? Log In'
                            : 'Don\'t have an account? Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _loginLogic.signInWithGoogle(context);
                        setState(() {
                          _isLoading = false;
                        });
                        widget.onLoginSuccess();
                      },
                      icon: Icon(Icons.login, color: Colors.black),
                      label: Text('Sign In with Google', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
