import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// Servicio de almacenamiento de archivos
/// Maneja subida y eliminación de imágenes en Supabase Storage
class StorageService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Subir imagen de pastel
  Future<String> uploadCakeImage(File imageFile) async {
    final fileName = 'cakes/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await _client.storage.from(SupabaseConfig.bucketCakeImages).upload(
      fileName,
      imageFile,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: false,
      ),
    );

    return _client.storage.from(SupabaseConfig.bucketCakeImages).getPublicUrl(fileName);
  }

  /// Subir avatar de usuario
  Future<String> uploadAvatar(File imageFile, String userId) async {
    final fileName = 'avatars/$userId.jpg';

    await _client.storage.from(SupabaseConfig.bucketAvatars).upload(
      fileName,
      imageFile,
      fileOptions: const FileOptions(
        cacheControl: '3600',
        upsert: true,
      ),
    );

    return _client.storage.from(SupabaseConfig.bucketAvatars).getPublicUrl(fileName);
  }

  /// Eliminar imagen de pastel
  Future<void> deleteCakeImage(String path) async {
    await _client.storage.from(SupabaseConfig.bucketCakeImages).remove([path]);
  }

  /// Eliminar avatar
  Future<void> deleteAvatar(String path) async {
    await _client.storage.from(SupabaseConfig.bucketAvatars).remove([path]);
  }

  /// Obtener URL pública de imagen de pastel
  String getCakeImageUrl(String path) {
    return _client.storage.from(SupabaseConfig.bucketCakeImages).getPublicUrl(path);
  }

  /// Obtener URL pública de avatar
  String getAvatarUrl(String path) {
    return _client.storage.from(SupabaseConfig.bucketAvatars).getPublicUrl(path);
  }

  /// Listar imágenes de un bucket
  Future<List<String>> listFiles(String bucket, {String? path}) async {
    final response = await _client.storage.from(bucket).list(path: path);
    return response.map((file) => file.name).toList();
  }
}
