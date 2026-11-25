import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

/// Modelo de item del carrito
@JsonSerializable()
class CartItem {
  final String id;
  final String cakeId;
  final String cakeName;
  final String? cakeImage;
  final double price;
  final int quantity;
  final String? notes;
  
  CartItem({
    required this.id,
    required this.cakeId,
    required this.cakeName,
    this.cakeImage,
    required this.price,
    required this.quantity,
    this.notes,
  });
  
  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
  
  /// Subtotal del item
  double get subtotal => price * quantity;
  
  /// Precio formateado
  String get formattedPrice => '\$${price.toStringAsFixed(2)} MXN';
  
  /// Subtotal formateado
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)} MXN';
}

/// Modelo de carrito
@JsonSerializable()
class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    this.createdAt,
    this.updatedAt,
  });
  
  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
  
  /// Total formateado
  String get formattedTotal => '\$${total.toStringAsFixed(2)} MXN';
  
  /// Cantidad total de items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  /// Verificar si el carrito está vacío
  bool get isEmpty => items.isEmpty;
  
  /// Verificar si el carrito tiene items
  bool get isNotEmpty => items.isNotEmpty;
}
