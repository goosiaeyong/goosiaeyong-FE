// lib/domain/repositories/chat_repository.dart

import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<void> sendMessage(ChatMessage message);
  Stream<ChatMessage> subscribeToChat(String chatRoomId);
}
