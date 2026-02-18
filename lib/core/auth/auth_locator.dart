import 'auth_service.dart';
import 'mock_auth_service.dart';

class AuthLocator {
  AuthLocator._();
  static final AuthService instance = MockAuthService(); // swap later with real
}
