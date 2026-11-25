import 'baker_profile.dart';
import 'category.dart';

/// Modelo de pastel
/// Mapea con la tabla 'cakes' en PostgreSQL
class Cake {
  final int id;
  final int bakerId;
  final int categoryId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relaciones (opcional, fetched separately)
  final BakerProfile? baker;
  final Category? category;

  Cake({
    required this.id,
    required this.bakerId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    this.baker,
    this.category,
  });

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      id: json['id'] as int,
      bakerId: json['baker_id'] as int,
      categoryId: json['category_id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      baker: json['baker_profiles'] != null
          ? BakerProfile.fromJson(json['baker_profiles'])
          : null,
      category: json['categories'] != null
          ? Category.fromJson(json['categories'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baker_id': bakerId,
      'category_id': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'rating': rating,
      'review_count': reviewCount,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
