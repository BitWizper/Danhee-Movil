import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/category.dart';

/// Servicio de gestión de categorías
class CategoryService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Obtener todas las categorías activas
  Future<List<Category>> getCategories({bool activeOnly = true}) async {
    final query = _client.from(SupabaseConfig.tableCategories);

    if (activeOnly) {
      query.eq('is_active', true);
    }

    final response = await query.order('sort_order');
    return (response as List).map((e) => Category.fromJson(e)).toList();
  }

  /// Obtener categoría por ID
  Future<Category?> getCategoryById(int id) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableCategories)
          .select()
          .eq('id', id)
          .single();

      return Category.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Obtener categoría por slug
  Future<Category?> getCategoryBySlug(String slug) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableCategories)
          .select()
          .eq('slug', slug)
          .single();

      return Category.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Crear categoría (admin)
  Future<Category> createCategory({
    required String name,
    required String slug,
    String? icon,
    String? description,
    bool isActive = true,
    int sortOrder = 0,
  }) async {
    final response = await _client.from(SupabaseConfig.tableCategories).insert({
      'name': name,
      'slug': slug,
      'icon': icon,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
    }).select().single();

    return Category.fromJson(response);
  }

  /// Actualizar categoría (admin)
  Future<Category> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await _client
        .from(SupabaseConfig.tableCategories)
        .update(data)
        .eq('id', id)
        .select()
        .single();

    return Category.fromJson(response);
  }

  /// Eliminar categoría (admin)
  Future<void> deleteCategory(int id) async {
    await _client.from(SupabaseConfig.tableCategories).delete().eq('id', id);
  }
}
