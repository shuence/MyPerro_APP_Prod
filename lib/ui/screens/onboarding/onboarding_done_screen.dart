import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:myperro_app_merged/features/collar_setup/screens/qr_scan_collar_screen.dart';

const _brandOrange = Color(0xFFF5832A);
const _titleBlack = Color(0xFF1F1F1F);

class OnboardingDoneScreen extends StatelessWidget {
  final String petName;

  const OnboardingDoneScreen({super.key, required this.petName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Hero area with your single image
                  SizedBox(
                    width: 800,
                    height: 500,
                    child: Image.asset(
                      'assets/illustrations/onboarding_done_dog.png',
                      fit: BoxFit.contain,
                      alignment:Alignment.center,
                    ),
                  ),

                  // Push the title down to sit just above the buttons
                  const Spacer(),

                  // Title – centered
                  Text(
                    "We’ve Onboarded $petName!",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: _titleBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Outlined pill button: Add More Pets
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Colors.white,
                        foregroundColor: _brandOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                          side: const BorderSide(color: _brandOrange, width: 2),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Add More Pets',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filled orange gradient: Set Up The Collars
                  _PrimaryCTA(
                    label: 'Set Up The Collars',
                    icon: Icons.arrow_forward_rounded,
                    petName: petName,
                  ),

                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryCTA extends StatelessWidget {
  final String label;
  final IconData icon;
  final String petName;

  const _PrimaryCTA({
    required this.label,
    required this.icon,
    required this.petName,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback onTap = () {
      // Navigate to collar setup flow after pet onboarding
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const QrScanCollarScreen(),
        ),
      );
    };

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          bottom: -8,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 22,
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xE6F5832A), Color(0x33F5832A)],
                  ),
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF89A50), _brandOrange],
              ),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Positioned(
                      right: 14,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.28),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(icon, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
