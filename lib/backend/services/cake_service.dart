import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/cake.dart';

/// Servicio de gestión de pasteles
/// Maneja CRUD de pasteles con Supabase
class CakeService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Obtener todos los pasteles con relaciones
  Future<List<Cake>> getCakes({bool featuredOnly = false}) async {
    final query = _client
        .from(SupabaseConfig.tableCakes)
        .select('*, baker_profiles(*), categories(*)');

    if (featuredOnly) {
      query.eq('is_featured', true);
    }

    final response = await query;
    return (response as List).map((e) => Cake.fromJson(e)).toList();
  }

  /// Obtener pasteles por categoría
  Future<List<Cake>> getCakesByCategory(int categoryId) async {
    final response = await _client
        .from(SupabaseConfig.tableCakes)
        .select('*, baker_profiles(*), categories(*)')
        .eq('category_id', categoryId);

    return (response as List).map((e) => Cake.fromJson(e)).toList();
  }

  /// Obtener pasteles de un baker específico
  Future<List<Cake>> getCakesByBaker(int bakerId) async {
    final response = await _client
        .from(SupabaseConfig.tableCakes)
        .select('*, baker_profiles(*), categories(*)')
        .eq('baker_id', bakerId);

    return (response as List).map((e) => Cake.fromJson(e)).toList();
  }

  /// Obtener un pastel por ID
  Future<Cake?> getCakeById(int id) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableCakes)
          .select('*, baker_profiles(*), categories(*)')
          .eq('id', id)
          .single();

      return Cake.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Crear pastel (solo para bakers)
  Future<Cake> createCake({
    required int bakerId,
    required int categoryId,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
  }) async {
    final response = await _client.from(SupabaseConfig.tableCakes).insert({
      'baker_id': bakerId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
    }).select().single();

    return Cake.fromJson(response);
  }

  /// Actualizar pastel
  Future<Cake> updateCake(int id, Map<String, dynamic> data) async {
    final response = await _client
        .from(SupabaseConfig.tableCakes)
        .update(data)
        .eq('id', id)
        .select()
        .single();

    return Cake.fromJson(response);
  }

  /// Eliminar pastel
  Future<void> deleteCake(int id) async {
    await _client.from(SupabaseConfig.tableCakes).delete().eq('id', id);
  }

  /// Buscar pasteles por nombre
  Future<List<Cake>> searchCakes(String query) async {
    final response = await _client
        .from(SupabaseConfig.tableCakes)
        .select('*, baker_profiles(*), categories(*)')
        .ilike('name', '%$query%');

    return (response as List).map((e) => Cake.fromJson(e)).toList();
  }
}
