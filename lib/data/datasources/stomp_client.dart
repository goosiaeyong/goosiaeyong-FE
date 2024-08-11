import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompClientSetup {
  static StompClient? _stompClient;

  static StompClient setupClient() {
    void onConnect(StompFrame frame) {
      _stompClient!.subscribe(
        destination: '/topic/test/subscription',
        callback: (frame) {
          List<dynamic>? result = json.decode(frame.body!);
          log(result.toString());
        },
      );

      /*
      Timer.periodic(const Duration(seconds: 10), (_) {
        _stompClient!.send(
          destination: '/app/test/endpoints',
          body: json.encode({'a': 123}),
        );
      });
      */
    }

    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080',
        onConnect: onConnect,
        beforeConnect: () async {
          log('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          log('connecting...');
        },
        onWebSocketError: (dynamic error) => log(error.toString()),
        stompConnectHeaders: {'Authorization': 'Bearer yourToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer yourToken'},
        onDisconnect: (StompFrame frame) {
          log('Disconnected from STOMP server');
        },
      ),
    );

    return _stompClient!;
  }
}
