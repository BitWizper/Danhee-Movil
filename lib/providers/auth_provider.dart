import 'package:flutter/foundation.dart';
import '../api/api_service.dart';
import '../config/api_config.dart';
import '../models/auth_response.dart';
import '../models/user.dart';
import '../utils/storage_helper.dart';

/// Provider para manejo de autenticación
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isBaker => _user?.isBaker ?? false;
  bool get isClient => _user?.isClient ?? false;
  
  /// Inicializar sesión desde storage
  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final isAuth = await StorageHelper.isAuthenticated();
      if (isAuth) {
        await _fetchCurrentUser();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Login de usuario
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      _user = authResponse.user;
      
      // Guardar tokens y datos
      await StorageHelper.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      await StorageHelper.saveUserData(
        userId: authResponse.user.id,
        role: authResponse.user.role,
        name: authResponse.user.name ?? '',
        email: authResponse.user.email,
      );
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Registro de cliente
  Future<bool> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'role': 'cliente',
        },
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      _user = authResponse.user;
      
      // Guardar tokens y datos
      await StorageHelper.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      await StorageHelper.saveUserData(
        userId: authResponse.user.id,
        role: authResponse.user.role,
        name: authResponse.user.name ?? '',
        email: authResponse.user.email,
      );
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Registro de repostero
  Future<bool> registerBaker({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String specialty,
    required String location,
    required String businessHours,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final response = await _apiService.post(
        ApiConfig.registerBaker,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'businessName': businessName,
          'specialty': specialty,
          'location': location,
          'businessHours': businessHours,
        },
      );
      
      final authResponse = AuthResponse.fromJson(response.data);
      _user = authResponse.user;
      
      // Guardar tokens y datos
      await StorageHelper.saveTokens(
        authResponse.accessToken,
        authResponse.refreshToken,
      );
      await StorageHelper.saveUserData(
        userId: authResponse.user.id,
        role: authResponse.user.role,
        name: authResponse.user.name ?? '',
        email: authResponse.user.email,
      );
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Logout
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConfig.logout);
    } catch (e) {
      // Ignorar error en logout
    } finally {
      await StorageHelper.clearTokens();
      _user = null;
      _errorMessage = null;
      notifyListeners();
    }
  }
  
  /// Obtener usuario actual
  Future<void> _fetchCurrentUser() async {
    try {
      final response = await _apiService.get(ApiConfig.me);
      _user = User.fromJson(response.data);
    } catch (e) {
      await StorageHelper.clearTokens();
      _user = null;
    }
  }
  
  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
