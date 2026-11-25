import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';

/// Servicio de chat con real-time
/// Maneja sesiones de chat y mensajes en tiempo real
class ChatService {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Crear nueva sesión de chat
  Future<ChatSession> createChatSession(String clientId, {int? bakerId}) async {
    final conversationId = DateTime.now().millisecondsSinceEpoch.toString();

    final response = await _client.from(SupabaseConfig.tableChatSessions).insert({
      'conversation_id': conversationId,
      'client_id': clientId,
      'baker_id': bakerId,
    }).select().single();

    return ChatSession.fromJson(response);
  }

  /// Obtener sesiones de chat del usuario actual
  Future<List<ChatSession>> getChatSessions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from(SupabaseConfig.tableChatSessions)
        .select('*, baker_profiles(*)')
        .eq('client_id', userId)
        .order('updated_at', ascending: false);

    return (response as List).map((e) => ChatSession.fromJson(e)).toList();
  }

  /// Obtener sesión de chat por ID de conversación
  Future<ChatSession?> getChatSession(String conversationId) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableChatSessions)
          .select('*, baker_profiles(*)')
          .eq('conversation_id', conversationId)
          .single();

      return ChatSession.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// Enviar mensaje
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String senderRole,
    required String content,
  }) async {
    final response = await _client.from(SupabaseConfig.tableChatMessages).insert({
      'conversation_id': conversationId,
      'sender_role': senderRole,
      'content': content,
    }).select().single();

    // Actualizar timestamp de sesión
    await updateSessionTimestamp(conversationId);

    return ChatMessage.fromJson(response);
  }

  /// Obtener mensajes de una conversación
  Future<List<ChatMessage>> getMessages(String conversationId) async {
    final response = await _client
        .from(SupabaseConfig.tableChatMessages)
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);

    return (response as List).map((e) => ChatMessage.fromJson(e)).toList();
  }

  /// Suscribirse a mensajes en tiempo real
  Stream<List<ChatMessage>> subscribeToMessages(String conversationId) {
    return _client
        .from(SupabaseConfig.tableChatMessages)
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((event) => event.map((e) => ChatMessage.fromJson(e)).toList());
  }

  /// Actualizar timestamp de sesión
  Future<void> updateSessionTimestamp(String conversationId) async {
    await _client
        .from(SupabaseConfig.tableChatSessions)
        .update({'updated_at': DateTime.now().toIso8601String()})
        .eq('conversation_id', conversationId);
  }

  /// Suscribirse a cambios en sesiones de chat
  Stream<List<ChatSession>> subscribeToChatSessions() async* {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    yield* _client
        .from(SupabaseConfig.tableChatSessions)
        .stream(primaryKey: ['conversation_id'])
        .eq('client_id', userId)
        .order('updated_at', ascending: false)
        .map((event) => event.map((e) => ChatSession.fromJson(e)).toList());
  }
}
