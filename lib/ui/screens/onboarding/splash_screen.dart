import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Stay here ~3 seconds, then go to Intro
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      // Intro is our "/" route
      Navigator.of(context).pushReplacementNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    const peachCircle = Color(0xFFF4C295); // Updated color

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle with your transparent GIF
              Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: peachCircle,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/animations/splash_dog.gif',
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 1),
              // MyPerro logo with tagline
              SvgPicture.asset(
                'assets/branding/myperro_logo_with_tagline.svg',
                height: 125,
                semanticsLabel: 'MyPerro Logo',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
