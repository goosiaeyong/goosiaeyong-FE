// lib/presentation/viewmodels/chat_viewmodel.dart

import 'package:flutter/material.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/subscribe_to_chat.dart';

class ChatViewModel extends ChangeNotifier {
  final SendMessage sendMessageUseCase;
  final SubscribeToChat subscribeToChatUseCase;

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  ChatViewModel({
    required this.sendMessageUseCase,
    required this.subscribeToChatUseCase,
  }) {
    _subscribeToChat('defaultChatRoom');
  }

  Future<void> sendMessage(ChatMessage message) async {
    await sendMessageUseCase.call(message);
    _messages.add(message);
    notifyListeners();
  }

  void _subscribeToChat(String chatRoomId) {
    subscribeToChatUseCase.call(chatRoomId).listen((ChatMessage message) {
      _messages.add(message);
      notifyListeners();
    });
  }
}
