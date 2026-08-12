import 'package:json_annotation/json_annotation.dart';

part 'cake.g.dart';

/// Modelo de pastel
@JsonSerializable()
class Cake {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final String categoryId;
  final String? categoryName;
  final String bakerId;
  final String? bakerName;
  final bool isFeatured;
  final bool isAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  Cake({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categoryId,
    this.categoryName,
    required this.bakerId,
    this.bakerName,
    this.isFeatured = false,
    this.isAvailable = true,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Cake.fromJson(Map<String, dynamic> json) => _$CakeFromJson(json);
  Map<String, dynamic> toJson() => _$CakeToJson(this);
  
  /// Precio formateado
  String get formattedPrice => '\$${price.toStringAsFixed(2)} MXN';
  
  /// Verificar si tiene imagen
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}

/// Modelo de categoría
@JsonSerializable()
class Category {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int? order;
  
  Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.order,
  });
  
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
