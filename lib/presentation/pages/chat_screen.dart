// lib/presentation/pages/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/chat_message.dart';
import '../viewmodels/chat_viewmodel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final message = viewModel.messages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text('From: ${message.senderId}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (text) {
                      final newMessage = ChatMessage(
                        id: DateTime.now().toString(),
                        senderId: 'user',
                        receiverId: 'server',
                        content: text,
                        timestamp: DateTime.now(),
                      );
                      viewModel.sendMessage(newMessage);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
