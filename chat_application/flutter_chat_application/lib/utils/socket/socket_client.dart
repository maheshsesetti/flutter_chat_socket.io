import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClientSingleton {
  static final SocketClientSingleton instance = SocketClientSingleton._internal();
  SocketClientSingleton._internal();
  IO.Socket? socket;
  static SocketClientSingleton get getInstance => instance;

  void initSocket() {
    socket = IO.io('http://192.168.0.100:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    socket!.onError((data) => debugPrint(data.toString()));
    socket!.onConnectError((data) => debugPrint(data.toString()));
  }
}
