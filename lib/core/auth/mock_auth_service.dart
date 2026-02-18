import 'dart:async';
import 'auth_service.dart';

class MockAuthService implements AuthService {
  bool _loggedIn = false;

  @override
  Future<void> loginWithEmail({required String loginId, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // fake network
    // Very basic demo rule:
    if (password.length >= 6) {
      _loggedIn = true;
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loggedIn = true;
  }

  @override
  Future<void> loginWithApple() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _loggedIn = true;
  }

  @override
  Future<void> signupWithEmail({required String name, required String phone, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (password.length >= 6) {
      _loggedIn = true;
    } else {
      throw Exception('Weak password');
    }
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _loggedIn = false;
  }
}
