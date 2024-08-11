// lib/data/repositories/chat_repository_impl.dart

import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final StompClient stompClient;

  ChatRepositoryImpl(this.stompClient);

  @override
  Future<void> sendMessage(ChatMessage message) async {
    final frame = StompFrame(
      command: 'SEND',
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
      // destination: '/app/chat/${widget.chatId}',
      body: frame.body,
    );
  }

  @override
  Stream<ChatMessage> subscribeToChat(String chatRoomId) {
    final controller = StreamController<ChatMessage>();

    stompClient.subscribe(
      destination: '/topic/$chatRoomId',
      callback: (StompFrame frame) {
        final Map<String, dynamic> data = json.decode(frame.body!);
        final message = ChatMessageModel.fromJson(data).toEntity();
        controller.add(message);
      },
    );

    /*
    controller.onCancel = () {
      stompClient.unsubscribe(destination: '/topic/$chatRoomId');
      controller.close();
    };
    */

    return controller.stream;
  }
}
