import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // speed of animation
    )..forward();

    // Define scale effect
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // gives a smooth "pop" effect
      ),
    );

    // After a delay, move to Home
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF43cea2,
      ), // match native splash background
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset('assets/images/logo.png', width: 150, height: 150),
        ),
      ),
    );
  }
}
