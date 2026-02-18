import 'package:flutter/material.dart';

const _brandOrange = Color(0xFFF5832A);
const _pageBg = Color(0xFFF7F7F7);
const _grey900 = Color(0xFF202020);
const _grey700 = Color(0xFF6B6B6B);

class OnboardingCredentialsScreen extends StatelessWidget {
  const OnboardingCredentialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: _grey900, size: 20),
        ),
        title: const Text(
          'Onboarding_Credentials',
          style: TextStyle(
            color: _grey900,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
          child: Column(
            children: [
              // Large orange circle
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCC80),
                  shape: BoxShape.circle,
                ),
              ),
              
              const Spacer(),
              
              const Text(
                'Onboarding credentials and setup information will be displayed here.',
                style: TextStyle(
                  fontSize: 16,
                  color: _grey700,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _brandOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
