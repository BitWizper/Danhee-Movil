// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
  id: json['id'] as String,
  cakeId: json['cakeId'] as String,
  cakeName: json['cakeName'] as String,
  cakeImage: json['cakeImage'] as String?,
  price: (json['price'] as num).toDouble(),
  quantity: (json['quantity'] as num).toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'cakeId': instance.cakeId,
  'cakeName': instance.cakeName,
  'cakeImage': instance.cakeImage,
  'price': instance.price,
  'quantity': instance.quantity,
  'notes': instance.notes,
};

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
  id: json['id'] as String,
  userId: json['userId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'items': instance.items,
  'total': instance.total,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
