/// Modelo de perfil de baker
/// Mapea con la tabla 'baker_profiles' en PostgreSQL
class BakerProfile {
  final int id;
  final String userId;
  final String businessName;
  final String location;
  final String specialty;
  final String? bio;
  final String? portfolioUrl;
  final bool isVerified;
  final double averageRating;
  final int totalReviews;
  final Map<String, dynamic>? businessHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relación opcional con usuario
  final SupabaseUser? user;

  BakerProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.location,
    required this.specialty,
    this.bio,
    this.portfolioUrl,
    this.isVerified = false,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.businessHours,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory BakerProfile.fromJson(Map<String, dynamic> json) {
    return BakerProfile(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      businessName: json['business_name'] as String,
      location: json['location'] as String,
      specialty: json['specialty'] as String,
      bio: json['bio'] as String?,
      portfolioUrl: json['portfolio_url'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      businessHours: json['business_hours'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: json['users'] != null ? SupabaseUser.fromJson(json['users']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'business_name': businessName,
      'location': location,
      'specialty': specialty,
      'bio': bio,
      'portfolio_url': portfolioUrl,
      'is_verified': isVerified,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'business_hours': businessHours,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
