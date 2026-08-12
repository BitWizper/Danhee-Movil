import 'package:json_annotation/json_annotation.dart';

part 'baker.g.dart';

/// Modelo de repostero
@JsonSerializable()
class Baker {
  final String id;
  final String userId;
  final String businessName;
  final String specialty;
  final String location;
  final String businessHours;
  final String? description;
  final String? profileImage;
  final String? coverImage;
  final double? rating;
  final int? reviewCount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  Baker({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.specialty,
    required this.location,
    required this.businessHours,
    this.description,
    this.profileImage,
    this.coverImage,
    this.rating,
    this.reviewCount,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Baker.fromJson(Map<String, dynamic> json) => _$BakerFromJson(json);
  Map<String, dynamic> toJson() => _$BakerToJson(this);
  
  /// Rating formateado
  String get formattedRating => rating != null ? rating!.toStringAsFixed(1) : 'N/A';
  
  /// Verificar si tiene imagen de perfil
  bool get hasProfileImage => profileImage != null && profileImage!.isNotEmpty;
  
  /// Verificar si tiene imagen de portada
  bool get hasCoverImage => coverImage != null && coverImage!.isNotEmpty;
}
