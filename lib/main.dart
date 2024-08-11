// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/stomp_client.dart';
import 'data/repositories/chat_repository_impl.dart';
import 'domain/usecases/send_message.dart';
import 'domain/usecases/subscribe_to_chat.dart';
import 'presentation/pages/chat_screen.dart';
import 'presentation/viewmodels/chat_viewmodel.dart';

void main() {
  final stompClient = StompClientSetup.setupClient();
  final chatRepository = ChatRepositoryImpl(stompClient);
  final sendMessageUseCase = SendMessage(chatRepository);
  final subscribeToChatUseCase = SubscribeToChat(chatRepository);

  stompClient.activate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ChatViewModel(
            sendMessageUseCase: sendMessageUseCase,
            subscribeToChatUseCase: subscribeToChatUseCase,
          ),
        ),
        // 다른 Provider가 있다면 여기에 추가
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}
