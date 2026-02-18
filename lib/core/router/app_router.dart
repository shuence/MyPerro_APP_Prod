import 'package:flutter/material.dart';
// Onboarding & Auth
import '../../ui/screens/onboarding/splash_screen.dart';
import '../../ui/screens/onboarding/intro_screen.dart';
import '../../ui/screens/onboarding/features_screen.dart';
import '../../ui/screens/auth/login_screen.dart';
import '../../ui/screens/auth/signup_screen.dart';
import '../../ui/screens/onboarding/onboarding_title_screen.dart';
// Collar Setup
import '../../features/collar_setup/screens/qr_scan_collar_screen.dart';
// Dashboard
import '../../ui/screens/dashboard_screens/dashboard_screen.dart';

class AppRouter {
  // Route constants - Complete flow
  static const String splash = '/splash';
  static const String intro = '/';
  static const String features = '/features';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String collarSetup = '/collar-setup';
  static const String dashboard = '/dashboard';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case intro:
        return MaterialPageRoute(
          builder: (_) => const IntroScreen(),
        );
      case features:
        return MaterialPageRoute(
          builder: (_) => const FeaturesScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LogInScreen(),
        );
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingTitleScreen(),
        );
      case collarSetup:
        return MaterialPageRoute(
          builder: (_) => const QrScanCollarScreen(),
        );
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(petName: 'Krypto'),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
    }
  }
}
