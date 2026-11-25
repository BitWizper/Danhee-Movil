import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/baker_profile.dart';
import '../models/supabase_user.dart';

/// Servicio de gestión de perfiles de bakers
class BakerService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Obtener perfil de baker por user ID
  Future<BakerProfile?> getBakerProfile(String userId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBakerProfiles)
          .select('*, users(*)')
          .eq('user_id', userId)
          .single();

      return BakerProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Obtener perfil de baker por ID del perfil
  Future<BakerProfile?> getBakerProfileById(int profileId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBakerProfiles)
          .select('*, users(*)')
          .eq('id', profileId)
          .single();

      return BakerProfile.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Crear perfil de baker
  Future<BakerProfile> createBakerProfile({
    required String userId,
    required String businessName,
    required String location,
    required String specialty,
    String? bio,
    String? portfolioUrl,
    Map<String, dynamic>? businessHours,
  }) async {
    final response = await _client.from(SupabaseConfig.tableBakerProfiles).insert({
      'user_id': userId,
      'business_name': businessName,
      'location': location,
      'specialty': specialty,
      'bio': bio,
      'portfolio_url': portfolioUrl,
      'business_hours': businessHours,
      'is_verified': false,
      'average_rating': 0.0,
      'total_reviews': 0,
    }).select().single();

    return BakerProfile.fromJson(response);
  }

  /// Obtener todos los bakers verificados
  Future<List<BakerProfile>> getAllBakers({bool verifiedOnly = true}) async {
    final query = _client
        .from(SupabaseConfig.tableBakerProfiles)
        .select('*, users(*)');

    if (verifiedOnly) {
      query.eq('is_verified', true);
    }

    final response = await query.order('average_rating', ascending: false);
    return (response as List).map((e) => BakerProfile.fromJson(e)).toList();
  }

  /// Actualizar perfil de baker
  Future<BakerProfile> updateBakerProfile(
    int profileId,
    Map<String, dynamic> data,
  ) async {
    data['updated_at'] = DateTime.now().toIso8601String();

    final response = await _client
        .from(SupabaseConfig.tableBakerProfiles)
        .update(data)
        .eq('id', profileId)
        .select()
        .single();

    return BakerProfile.fromJson(response);
  }

  /// Buscar bakers por ubicación o especialidad
  Future<List<BakerProfile>> searchBakers(String query) async {
    final response = await _client
        .from(SupabaseConfig.tableBakerProfiles)
        .select('*, users(*)')
        .or('location.ilike.%$query%,specialty.ilike.%$query%,business_name.ilike.%$query%')
        .eq('is_verified', true);

    return (response as List).map((e) => BakerProfile.fromJson(e)).toList();
  }
}
