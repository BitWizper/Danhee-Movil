import 'package:json_annotation/json_annotation.dart';
import 'user.dart';

part 'auth_response.g.dart';

/// Modelo de respuesta de autenticación
@JsonSerializable()
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;
  
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
