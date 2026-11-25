import 'baker_profile.dart';

/// Modelo de sesión de chat
/// Mapea con la tabla 'chat_sessions' en PostgreSQL
class ChatSession {
  final String conversationId;
  final String clientId;
  final int? bakerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Relación opcional con baker
  final BakerProfile? baker;

  ChatSession({
    required this.conversationId,
    required this.clientId,
    this.bakerId,
    required this.createdAt,
    required this.updatedAt,
    this.baker,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      conversationId: json['conversation_id'] as String,
      clientId: json['client_id'] as String,
      bakerId: json['baker_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      baker: json['baker_profiles'] != null
          ? BakerProfile.fromJson(json['baker_profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'client_id': clientId,
      'baker_id': bakerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
