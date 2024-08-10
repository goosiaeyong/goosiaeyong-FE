// lib/data/datasources/stomp_client.dart

import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompClientSetup {
  static StompClient setupClient() {
    return StompClient(
      config: StompConfig(
        url: 'ws://your-stomp-server-url',
        onConnect: (StompFrame frame) {
          print('Connected to STOMP server');
        },
        onDisconnect: (StompFrame frame) {
          print('Disconnected from STOMP server');
        },
      ),
    );
  }
}
