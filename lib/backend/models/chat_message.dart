/// Modelo de mensaje de chat
/// Mapea con la tabla 'chat_messages' en PostgreSQL
class ChatMessage {
  final int id;
  final String conversationId;
  final String senderRole; // 'client' or 'baker'
  final String content;
  final DateTime createdAt;
  final Map<String, dynamic>? toolCalls;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderRole,
    required this.content,
    required this.createdAt,
    this.toolCalls,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as String,
      senderRole: json['sender_role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      toolCalls: json['tool_calls'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_role': senderRole,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'tool_calls': toolCalls,
    };
  }

  bool get isFromClient => senderRole == 'client';
  bool get isFromBaker => senderRole == 'baker';
}
