import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Instance of FlutterSecureStorage for encrypted token storage
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _sessionKey = 'session_key';
  static const String _userDataKey = 'user_data';
  static const String _sessionActiveKey = 'mentra_session_active';

  // ==================== AUTH TOKENS (Secure Storage) ==================== //

  /// Save tokens and auth data securely after login
  static Future<void> saveAuthData({
    required String accessToken,
    required String sessionKey,
    String? refreshToken,
    String? userJson,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _sessionKey, value: sessionKey);

    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
    if (userJson != null) {
      await _secureStorage.write(key: _userDataKey, value: userJson);
    }

    // Set session active flag in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionActiveKey, true);
  }

  /// Retrieve Access Token
  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  /// Retrieve Session Key
  static Future<String?> getSessionKey() async {
    return await _secureStorage.read(key: _sessionKey);
  }

  /// Retrieve Refresh Token
  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  /// Retrieve User JSON Data
  static Future<String?> getUserData() async {
    return await _secureStorage.read(key: _userDataKey);
  }

  // ==================== SESSION STATE (Shared Preferences) ==================== //

  /// Set Session Active Flag
  static Future<void> setSessionActive(bool isActive) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionActiveKey, isActive);
  }

  /// Check if Session is Active
  static Future<bool> isSessionActive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionActiveKey) ?? false;
  }

  // ==================== LOGOUT / CLEAR STORAGE ==================== //

  /// Clear all stored credentials on Logout
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

static Future<void> clearTokens() async {
  await _secureStorage.delete(key: _accessTokenKey);
  await _secureStorage.delete(key: _refreshTokenKey);
  await _secureStorage.delete(key: _sessionKey);
  await _secureStorage.delete(key: _userDataKey);
  
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_sessionActiveKey, false);
}

}