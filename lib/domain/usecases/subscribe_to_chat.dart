// lib/domain/usecases/subscribe_to_chat.dart

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SubscribeToChat {
  final ChatRepository repository;

  SubscribeToChat(this.repository);

  Stream<ChatMessage> call(String chatRoomId) {
    return repository.subscribeToChat(chatRoomId);
  }
}
