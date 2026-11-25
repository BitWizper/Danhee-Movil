/// Modelo de reseña
/// Mapea con la tabla 'reviews' en PostgreSQL
class Review {
  final int id;
  final String clientId;
  final int bakerId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.clientId,
    required this.bakerId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      clientId: json['client_id'] as String,
      bakerId: json['baker_id'] as int,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'baker_id': bakerId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
