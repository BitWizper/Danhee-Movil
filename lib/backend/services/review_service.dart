import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/review.dart';

/// Servicio de gestión de reseñas
class ReviewService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Obtener reseñas de un baker
  Future<List<Review>> getReviewsByBaker(int bakerId) async {
    final response = await _client
        .from(SupabaseConfig.tableReviews)
        .select()
        .eq('baker_id', bakerId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Review.fromJson(e)).toList();
  }

  /// Obtener reseñas de un cliente
  Future<List<Review>> getReviewsByClient(String clientId) async {
    final response = await _client
        .from(SupabaseConfig.tableReviews)
        .select()
        .eq('client_id', clientId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => Review.fromJson(e)).toList();
  }

  /// Crear reseña
  Future<Review> createReview({
    required String clientId,
    required int bakerId,
    required double rating,
    String? comment,
  }) async {
    final response = await _client.from(SupabaseConfig.tableReviews).insert({
      'client_id': clientId,
      'baker_id': bakerId,
      'rating': rating,
      'comment': comment,
    }).select().single();

    // Actualizar rating promedio del baker
    await _updateBakerRating(bakerId);

    return Review.fromJson(response);
  }

  /// Actualizar rating promedio del baker
  Future<void> _updateBakerRating(int bakerId) async {
    final reviews = await getReviewsByBaker(bakerId);

    if (reviews.isEmpty) {
      await _client
          .from(SupabaseConfig.tableBakerProfiles)
          .update({'average_rating': 0.0, 'total_reviews': 0})
          .eq('id', bakerId);
      return;
    }

    final totalRating = reviews.fold<double>(0, (sum, r) => sum + r.rating);
    final averageRating = totalRating / reviews.length;

    await _client
        .from(SupabaseConfig.tableBakerProfiles)
        .update({
          'average_rating': averageRating,
          'total_reviews': reviews.length,
        })
        .eq('id', bakerId);
  }

  /// Eliminar reseña
  Future<void> deleteReview(int id) async {
    // Obtener baker_id antes de eliminar
    final review = await _client
        .from(SupabaseConfig.tableReviews)
        .select()
        .eq('id', id)
        .single();

    await _client.from(SupabaseConfig.tableReviews).delete().eq('id', id);

    // Actualizar rating del baker
    if (review != null) {
      await _updateBakerRating(review['baker_id'] as int);
    }
  }
}
