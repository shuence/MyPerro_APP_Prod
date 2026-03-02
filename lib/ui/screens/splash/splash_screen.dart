import 'package:flutter/material.dart';
import '../onboarding/onboarding_title_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingTitleScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/branding/splash_dog.png',
              height: 400,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/branding/myperro_logo.svg',
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF5832A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
