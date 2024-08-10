// lib/domain/usecases/send_message.dart

import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(ChatMessage message) async {
    await repository.sendMessage(message);
  }
}
