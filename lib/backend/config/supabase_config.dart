import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Configuración centralizada de Supabase
/// Contiene las credenciales y métodos de inicialización
class SupabaseConfig {
  static String? _supabaseUrl;
  static String? _supabaseAnonKey;

  /// Cargar variables de entorno desde .env
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: '.env');
    _supabaseUrl = dotenv.env['SUPABASE_URL'];
    _supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  }

  /// Obtener URL de Supabase
  static String get supabaseUrl {
    return _supabaseUrl ??
        String.fromEnvironment(
          'SUPABASE_URL',
          defaultValue: 'https://wflvyeslkadtlpemxfrk.supabase.co',
        );
  }

  /// Obtener Anon Key de Supabase
  static String get supabaseAnonKey {
    return _supabaseAnonKey ??
        String.fromEnvironment(
          'SUPABASE_ANON_KEY',
          defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmbHZ5ZXNsa2FkdGxwZW14ZnJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTU1NjI5NjUsImV4cCI6MjExMTEzODk2NX0.v5RWTNT7_Vh8xyZaxm8sMF-w0dB5qIg9PurxMqlzFcs',
        );
  }

  /// Inicializar Supabase
  /// Debe llamarse en main.dart antes de runApp()
  static Future<void> initialize() async {
    await loadEnv();
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Habilitar logs en desarrollo
    );
  }

  /// Obtener el cliente de Supabase
  static SupabaseClient get client => Supabase.instance.client;

  /// Obtener el cliente de autenticación
  static GoTrueClient get auth => Supabase.instance.client.auth;

  /// Obtener el usuario actual autenticado
  static dynamic get currentUser => Supabase.instance.client.auth.currentUser;

  /// Verificar si hay un usuario autenticado
  static bool get isAuthenticated => Supabase.instance.client.auth.currentUser != null;

  /// Obtener el ID del usuario actual
  static String? get currentUserId => Supabase.instance.client.auth.currentUser?.id;

  /// Nombres de las tablas en Supabase
  static const String tableUsers = 'users';
  static const String tableBakerProfiles = 'baker_profiles';
  static const String tableCakes = 'cakes';
  static const String tableCategories = 'categories';
  static const String tableReviews = 'reviews';
  static const String tableCakeDesigns = 'cake_designs';
  static const String tableChatSessions = 'chat_sessions';
  static const String tableChatMessages = 'chat_messages';
  static const String tableAppointments = 'appointments';

  /// Nombres de los buckets de Storage
  static const String bucketCakeImages = 'cake-images';
  static const String bucketAvatars = 'avatars';
}
