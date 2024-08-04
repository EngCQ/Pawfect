import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToSignUp();
  }

  _navigateToSignUp() async {
    await Future.delayed(const Duration(seconds: 3), () {}); // Wait for 3 seconds
    Navigator.pushReplacementNamed(context, '/signIn'); // Navigate to sign-up screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color: Colors.blue, // Replace with your desired background color
          ),
          // Centered white background with border radius and logo
          Center(
            child: Container(
              width: 250, // Adjust width as needed
              height: 250, // Adjust height as needed
              decoration: BoxDecoration(
                color: Colors.white, // White background for the logo
                borderRadius: BorderRadius.circular(16), // Border radius
              ),
              child: Center(
                child: Image.asset('assets/logo.png', width: 200, height: 200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
