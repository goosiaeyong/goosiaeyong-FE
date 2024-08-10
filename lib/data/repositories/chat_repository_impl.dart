// lib/data/repositories/chat_repository_impl.dart

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final StompClient stompClient;

  ChatRepositoryImpl(this.stompClient);

  @override
  Future<void> sendMessage(ChatMessage message) async {
    final frame = StompFrame.connect(
      headers: {
        'content-type': 'application/json',
      },
      body: ChatMessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timestamp: message.timestamp,
      ).toJson(),
    );

    stompClient.send(
      destination: '/app/chat.send',
      body: frame.body,
    );
  }

  @override
  Stream<ChatMessage> subscribeToChat(String chatRoomId) {
    stompClient.connect();
    return stompClient
        .subscribe(destination: '/topic/$chatRoomId')
        .map((StompFrame frame) {
      final chatMessageModel = ChatMessageModel.fromJson(frame.body);
      return chatMessageModel.toEntity();
    });
  }
}
