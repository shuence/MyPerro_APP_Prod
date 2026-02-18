import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/collar.dart';

/// Local storage service using SharedPreferences
class AppStorage {
  final SharedPreferences _prefs;

  AppStorage(this._prefs);

  // Storage keys
  static const String _keyCollarTokenPrefix = 'collar_token_';
  static const String _keyCollarDataPrefix = 'collar_data_';
  static const String _keyAllCollarImeis = 'all_collar_imeis';
  static const String _keyCurrentUserId = 'current_user_id';
  static const String _keyUserToken = 'user_token';

  /// Initialize storage (call this at app startup)
  static Future<AppStorage> init() async {
    final prefs = await SharedPreferences.getInstance();
    return AppStorage(prefs);
  }

  // ==================== Collar Token Management ====================

  /// Save collar token for a specific IMEI
  Future<bool> saveCollarToken(String imei, String token) async {
    return await _prefs.setString('$_keyCollarTokenPrefix$imei', token);
  }

  /// Get collar token for a specific IMEI
  String? getCollarToken(String imei) {
    return _prefs.getString('$_keyCollarTokenPrefix$imei');
  }

  /// Delete collar token for a specific IMEI
  Future<bool> deleteCollarToken(String imei) async {
    return await _prefs.remove('$_keyCollarTokenPrefix$imei');
  }

  // ==================== Collar Data Management ====================

  /// Save complete collar data
  Future<bool> saveCollar(Collar collar) async {
    try {
      // Save collar as JSON
      final jsonString = jsonEncode(collar.toJson());
      await _prefs.setString('$_keyCollarDataPrefix${collar.imei}', jsonString);

      // Add IMEI to list of all collars
      final imeis = getAllCollarImeis();
      if (!imeis.contains(collar.imei)) {
        imeis.add(collar.imei);
        await _saveAllCollarImeis(imeis);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get collar by IMEI
  Collar? getCollar(String imei) {
    try {
      final jsonString = _prefs.getString('$_keyCollarDataPrefix$imei');
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return Collar.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Get all stored collars
  List<Collar> getAllCollars() {
    final imeis = getAllCollarImeis();
    final collars = <Collar>[];

    for (final imei in imeis) {
      final collar = getCollar(imei);
      if (collar != null) {
        collars.add(collar);
      }
    }

    return collars;
  }

  /// Delete collar data
  Future<bool> deleteCollar(String imei) async {
    try {
      // Remove from collar data
      await _prefs.remove('$_keyCollarDataPrefix$imei');

      // Remove from list
      final imeis = getAllCollarImeis();
      imeis.remove(imei);
      await _saveAllCollarImeis(imeis);

      // Remove token
      await deleteCollarToken(imei);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get list of all collar IMEIs
  List<String> getAllCollarImeis() {
    final imeisString = _prefs.getString(_keyAllCollarImeis);
    if (imeisString == null) return [];

    try {
      final list = jsonDecode(imeisString) as List;
      return list.cast<String>();
    } catch (e) {
      return [];
    }
  }

  /// Save list of all collar IMEIs (private helper)
  Future<bool> _saveAllCollarImeis(List<String> imeis) async {
    return await _prefs.setString(_keyAllCollarImeis, jsonEncode(imeis));
  }

  // ==================== User Data Management ====================

  /// Save current user ID
  Future<bool> saveUserId(String userId) async {
    return await _prefs.setString(_keyCurrentUserId, userId);
  }

  /// Get current user ID
  String? getUserId() {
    return _prefs.getString(_keyCurrentUserId);
  }

  /// Save user authentication token
  Future<bool> saveUserToken(String token) async {
    return await _prefs.setString(_keyUserToken, token);
  }

  /// Get user authentication token
  String? getUserToken() {
    return _prefs.getString(_keyUserToken);
  }

  /// Clear all user data (logout)
  Future<bool> clearUserData() async {
    await _prefs.remove(_keyCurrentUserId);
    await _prefs.remove(_keyUserToken);
    return true;
  }

  // ==================== Utility Methods ====================

  /// Clear all storage (for testing/debugging)
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }

  /// Check if a collar with given IMEI exists
  bool hasCollar(String imei) {
    return getCollar(imei) != null;
  }

  /// Get count of stored collars
  int getCollarCount() {
    return getAllCollarImeis().length;
  }
}
