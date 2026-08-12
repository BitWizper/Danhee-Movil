// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Baker _$BakerFromJson(Map<String, dynamic> json) => Baker(
  id: json['id'] as String,
  userId: json['userId'] as String,
  businessName: json['businessName'] as String,
  specialty: json['specialty'] as String,
  location: json['location'] as String,
  businessHours: json['businessHours'] as String,
  description: json['description'] as String?,
  profileImage: json['profileImage'] as String?,
  coverImage: json['coverImage'] as String?,
  rating: (json['rating'] as num?)?.toDouble(),
  reviewCount: (json['reviewCount'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BakerToJson(Baker instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'businessName': instance.businessName,
  'specialty': instance.specialty,
  'location': instance.location,
  'businessHours': instance.businessHours,
  'description': instance.description,
  'profileImage': instance.profileImage,
  'coverImage': instance.coverImage,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
