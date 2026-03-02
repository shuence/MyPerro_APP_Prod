import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myperro_app_merged/core/router/app_router.dart'; // Correct import

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  // product URL
  Uri get _buyUrl => Uri.parse('https://www.myperro.in/');

  @override
  Widget build(BuildContext context) {
    const peachCircle = Color(0xFFF1C59C);
    const brandOrange = Color(0xFFF5832A);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero circle with transparent GIF
                Container(
                  width: 260,
                  height: 260,
                  decoration: const BoxDecoration(
                    color: peachCircle,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/animations/intro_dog.gif',
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'Welcome to',
                  style: GoogleFonts.mochiyPopOne(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6A6A6A),
                  ).copyWith(
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 1),

                SvgPicture.asset(
                  'assets/branding/myperro_logo.svg',
                  height: 80,
                  fit: BoxFit.contain,
                  semanticsLabel: 'MyPerro Logo',
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      // Use AppRouter to navigate to FeaturesScreen
                      Navigator.of(context).pushNamed('/features');  // Ensure FeaturesScreen route name
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandOrange,
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shadowColor: brandOrange.withOpacity(0.35),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),

                const SizedBox(height: 14),

                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Haven't got the collar yet? ",
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.55),
                        fontSize: 14,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!await launchUrl(_buyUrl, mode: LaunchMode.externalApplication)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open link')),
                          );
                        }
                      },
                      child: const Text(
                        'Buy it Now!',
                        style: TextStyle(
                          color: brandOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
