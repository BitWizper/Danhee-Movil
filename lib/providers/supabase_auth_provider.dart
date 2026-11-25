import 'package:flutter/foundation.dart';
import '../backend/config/supabase_config.dart';
import '../backend/services/auth_service.dart';
import '../backend/models/supabase_user.dart';

/// Provider para manejo de autenticación con Supabase
class SupabaseAuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  SupabaseUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  SupabaseUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  bool get isBaker => _user?.isBaker ?? false;
  bool get isClient => _user?.isClient ?? false;

  /// Inicializar sesión desde Supabase
  Future<void> initAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (SupabaseConfig.isAuthenticated) {
        _user = await _authService.getUserProfile();
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
      await _authService.signIn(email: email, password: password);
      _user = await _authService.getUserProfile();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registro unificado (cliente o baker)
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? address,
    String? phone,
    String? businessName,
    String? location,
    String? specialty,
    required String role, // 'client' or 'baker'
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signUp(
        email: email,
        password: password,
        name: name,
        role: role,
      );

      // Si es baker, crear perfil de baker
      if (role == 'baker' && businessName != null && location != null && specialty != null) {
        final userId = SupabaseConfig.currentUserId;
        if (userId != null) {
          // Aquí necesitarías el BakerService, pero por ahora lo básico
          // final bakerService = BakerService();
          // await bakerService.createBakerProfile(
          //   userId: userId,
          //   businessName: businessName,
          //   location: location,
          //   specialty: specialty,
          // );
        }
      }

      _user = await _authService.getUserProfile();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registro de cliente (método compatible con interfaz existente)
  Future<bool> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: 'client',
    );
  }

  /// Registro de repostero (método compatible con interfaz existente)
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
    return register(
      name: name,
      email: email,
      password: password,
      phone: phone,
      businessName: businessName,
      location: location,
      specialty: specialty,
      role: 'baker',
    );
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      // Ignorar error en logout
    } finally {
      _user = null;
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Recuperar contraseña
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await SupabaseConfig.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar perfil
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) {
        _errorMessage = 'Usuario no autenticado';
        return false;
      }

      _user = await _authService.updateProfile(
        userId: userId,
        name: name,
        phone: phone,
        address: address,
        avatarUrl: avatarUrl,
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

  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
