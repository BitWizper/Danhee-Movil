/// Modelo de usuario para Supabase
/// Mapea con la tabla 'users' en PostgreSQL
class SupabaseUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String role; // 'client' or 'baker'
  final String? phone;
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupabaseUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.phone,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupabaseUser.fromJson(Map<String, dynamic> json) {
    return SupabaseUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
      'phone': phone,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isBaker => role == 'baker';
  bool get isClient => role == 'client';
}
