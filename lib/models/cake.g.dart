// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cake _$CakeFromJson(Map<String, dynamic> json) => Cake(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String?,
  categoryId: json['categoryId'] as String,
  categoryName: json['categoryName'] as String?,
  bakerId: json['bakerId'] as String,
  bakerName: json['bakerName'] as String?,
  isFeatured: json['isFeatured'] as bool? ?? false,
  isAvailable: json['isAvailable'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CakeToJson(Cake instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'bakerId': instance.bakerId,
  'bakerName': instance.bakerName,
  'isFeatured': instance.isFeatured,
  'isAvailable': instance.isAvailable,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  order: (json['order'] as num?)?.toInt(),
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'order': instance.order,
};
