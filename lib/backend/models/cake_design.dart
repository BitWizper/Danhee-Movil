/// Modelo de diseño de pastel personalizado
/// Mapea con la tabla 'cake_designs' en PostgreSQL
class CakeDesign {
  final int id;
  final String clientId;
  final String? sponge;
  final String? filling;
  final String? decoration;
  final String? size;
  final String? notes;
  final String status; // 'pending', 'approved', 'rejected', 'completed'
  final DateTime createdAt;

  CakeDesign({
    required this.id,
    required this.clientId,
    this.sponge,
    this.filling,
    this.decoration,
    this.size,
    this.notes,
    this.status = 'pending',
    required this.createdAt,
  });

  factory CakeDesign.fromJson(Map<String, dynamic> json) {
    return CakeDesign(
      id: json['id'] as int,
      clientId: json['client_id'] as String,
      sponge: json['sponge'] as String?,
      filling: json['filling'] as String?,
      decoration: json['decoration'] as String?,
      size: json['size'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'sponge': sponge,
      'filling': filling,
      'decoration': decoration,
      'size': size,
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status == 'completed';
}
