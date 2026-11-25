import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// Provider de autenticación antiguo (deprecated)
/// Migrado a SupabaseAuthProvider
/// Este archivo se mantiene solo para compatibilidad temporal
@Deprecated('Use SupabaseAuthProvider instead')
class AuthProvider with ChangeNotifier {
  AuthProvider({
    Future<void> Function()? onSessionCleanup,
  }) : _onSessionCleanup = onSessionCleanup;

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

  Future<void> initAuth() async {
    // Deprecated - use SupabaseAuthProvider
  }

  Future<bool> login(String email, String password) async {
    // Deprecated - use SupabaseAuthProvider
    return false;
  }

  Future<bool> registerClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // Deprecated - use SupabaseAuthProvider
    return false;
  }

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
    // Deprecated - use SupabaseAuthProvider
    return false;
  }

  Future<void> logout() async {
    _user = null;
    await _onSessionCleanup?.call();
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
