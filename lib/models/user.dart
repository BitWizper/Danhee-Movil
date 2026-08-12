import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Modelo de usuario
@JsonSerializable()
class User {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String role; // 'cliente' o 'repostero'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
  
  /// Verificar si es cliente
  bool get isClient => role == 'cliente';
  
  /// Verificar si es repostero
  bool get isBaker => role == 'repostero';
}
