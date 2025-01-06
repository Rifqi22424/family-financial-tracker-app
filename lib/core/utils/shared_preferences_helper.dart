import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _keyAuthToken = "authToken";
  static const String _keyUserId = "userId";
  static const String _keyUserRole = "userRole";

  // Get instance of SharedPreferences
  static Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  /// Save token
  static Future<void> setAuthToken(String token) async {
    final prefs = await _getPreferences();
    await prefs.setString(_keyAuthToken, token);
  }

  /// Get token
  static Future<String?> getAuthToken() async {
    final prefs = await _getPreferences();
    return prefs.getString(_keyAuthToken);
  }

  /// Remove token
  static Future<void> removeAuthToken() async {
    final prefs = await _getPreferences();
    await prefs.remove(_keyAuthToken);
  }

  /// Save user ID
  static Future<void> setUserId(String userId) async {
    final prefs = await _getPreferences();
    await prefs.setString(_keyUserId, userId);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    final prefs = await _getPreferences();
    return prefs.getString(_keyUserId);
  }

  /// Remove user ID
  static Future<void> removeUserId() async {
    final prefs = await _getPreferences();
    await prefs.remove(_keyUserId);
  }

  /// Save user role
  static Future<void> setUserRole(String role) async {
    final prefs = await _getPreferences();
    await prefs.setString(_keyUserRole, role);
  }

  /// Get user role
  static Future<String?> getUserRole() async {
    final prefs = await _getPreferences();
    return prefs.getString(_keyUserRole);
  }

  /// Remove user role
  static Future<void> removeUserRole() async {
    final prefs = await _getPreferences();
    await prefs.remove(_keyUserRole);
  }

  /// Clear all saved data
  static Future<void> clearAll() async {
    final prefs = await _getPreferences();
    await prefs.clear();
  }
}
