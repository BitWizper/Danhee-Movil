import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/supabase_user.dart';

/// Servicio de autenticación con Supabase
/// Maneja registro, login, logout y gestión de sesiones
class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Registrar nuevo usuario
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
    required String role, // 'client' or 'baker'
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user != null) {
      // Crear perfil en tabla users
      await _client.from(SupabaseConfig.tableUsers).insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'role': role,
      });
    }

    return response;
  }

  /// Iniciar sesión
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Obtener usuario actual
  User? get currentUser => _client.auth.currentUser;

  /// Obtener perfil completo del usuario desde la tabla users
  Future<SupabaseUser?> getUserProfile() async {
    final userId = currentUser?.id;
    if (userId == null) return null;

    try {
      final response = await _client
          .from(SupabaseConfig.tableUsers)
          .select()
          .eq('id', userId)
          .single();

      return SupabaseUser.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Actualizar perfil de usuario
  Future<SupabaseUser> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    data['updated_at'] = DateTime.now().toIso8601String();

    final response = await _client
        .from(SupabaseConfig.tableUsers)
        .update(data)
        .eq('id', userId)
        .select()
        .single();

    return SupabaseUser.fromJson(response);
  }

  /// Escuchar cambios de autenticación
  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

  /// Verificar si el usuario está autenticado
  bool get isAuthenticated => _client.auth.currentUser != null;
}
