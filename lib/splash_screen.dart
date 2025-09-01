import 'dart:async';
import 'package:delivery_app/ui/screens/auth_screens/sign_in/signin_mobile.dart';
import 'package:delivery_app/ui/screens/homeScreen/homeScreen_mobile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentDot = 0;
  Timer? _timer;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentDot = (_currentDot + 1) % 3;
      });
    });

    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // Delay the navigation until the splash screen is shown
    await Future.delayed(const Duration(seconds: 3)); // Splash screen delay

    if (_auth.currentUser != null) {
      // If user is logged in → go to Home
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreenMobile()),
      );
    } else {
      // If user is not logged in → go to SignIn
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildDot(int index, Color color) {
    return ScaleTransition(
      scale:
          _currentDot == index ? _animation : const AlwaysStoppedAnimation(0.5),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "TechSphere Recommends",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // White card with logo
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Centered logo
                Image.asset(
                  'assets/images/techspere_logo.png',
                  height: 120,
                ),
                const SizedBox(height: 12),
                Text(
                  "Your Intelligent Device Guide.",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Dots animation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(0, Colors.blue),
                    _buildDot(1, Colors.redAccent),
                    _buildDot(2, Colors.blue),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
