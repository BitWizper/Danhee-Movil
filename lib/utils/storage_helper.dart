import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Helper para manejo de almacenamiento seguro
/// Tokens JWT y datos sensibles
class StorageHelper {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  
  // Keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  
  /// Guardar access token
  static Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }
  
  /// Obtener access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }
  
  /// Guardar refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }
  
  /// Obtener refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
  
  /// Guardar ambos tokens
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }
  
  /// Limpiar tokens (logout)
  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _userRoleKey),
      _storage.delete(key: _userNameKey),
      _storage.delete(key: _userEmailKey),
    ]);
  }
  
  /// Guardar datos del usuario
  static Future<void> saveUserData({
    required String userId,
    required String role,
    required String name,
    required String email,
  }) async {
    await Future.wait([
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userRoleKey, value: role),
      _storage.write(key: _userNameKey, value: name),
      _storage.write(key: _userEmailKey, value: email),
    ]);
  }
  
  /// Obtener ID del usuario
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }
  
  /// Obtener rol del usuario
  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }
  
  /// Obtener nombre del usuario
  static Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }
  
  /// Obtener email del usuario
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }
  
  /// Verificar si el usuario está autenticado
  static Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
  
  /// Verificar si el usuario es repostero
  static Future<bool> isBaker() async {
    final role = await getUserRole();
    return role == 'repostero';
  }
  
  /// Verificar si el usuario es cliente
  static Future<bool> isClient() async {
    final role = await getUserRole();
    return role == 'cliente';
  }
  
  /// SharedPreferences para datos no sensibles
  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }
  
  /// Guardar preferencia
  static Future<void> setPref(String key, dynamic value) async {
    final prefs = await getPrefs();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }
  
  /// Obtener preferencia
  static Future<dynamic> getPref(String key) async {
    final prefs = await getPrefs();
    return prefs.get(key);
  }
  
  /// Eliminar preferencia
  static Future<void> removePref(String key) async {
    final prefs = await getPrefs();
    await prefs.remove(key);
  }
}
