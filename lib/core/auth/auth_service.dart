abstract class AuthService {
  Future<void> loginWithEmail({required String loginId, required String password});
  Future<void> loginWithGoogle();
  Future<void> loginWithApple();
  Future<void> signupWithEmail({required String name, required String phone, required String email, required String password});
  Future<void> logout();
}
