import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';
import '../utils/storage_helper.dart';

/// Provider para manejo de autenticación
class AuthProvider with ChangeNotifier {
  AuthProvider({
    AuthRepository? repository,
    Future<void> Function()? onSessionCleanup,
  }) : _repository = repository ?? MockAuthRepositories.instance,
       _onSessionCleanup = onSessionCleanup;

  final AuthRepository _repository;
  final Future<void> Function()? _onSessionCleanup;
  
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
        _user = await _repository.getCurrentUser();
      }
    } catch (e) {
      _errorMessage = e.toString();
      await StorageHelper.clearTokens();
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
      final authResponse = await _repository.login(email, password);
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
      final authResponse = await _repository.registerClient(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
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
      final authResponse = await _repository.registerBaker(
        name: name,
        email: email,
        password: password,
        phone: phone,
        businessName: businessName,
        specialty: specialty,
        location: location,
        businessHours: businessHours,
      );
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
    String? logoutError;
    try {
      await _repository.logout();
    } catch (e) {
      logoutError = e.toString();
    }

    try {
      await StorageHelper.clearSession();
      await _onSessionCleanup?.call();
    } finally {
      _user = null;
      _errorMessage = logoutError;
      notifyListeners();
    }
  }
  
  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
