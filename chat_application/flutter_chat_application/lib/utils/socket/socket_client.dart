import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_application/utils/services/share_preference.dart';

class SocketClientSingleton {
  static final SocketClientSingleton instance =
      SocketClientSingleton._internal();

  factory SocketClientSingleton() {
    return instance;
  }

  SocketClientSingleton._internal();

  ValueNotifier<List<String>> messages = ValueNotifier<List<String>>([]);
  // static SocketClientSingleton get getInstance => instance;

  Socket? socket;

  Future<void> initSocket() async {
    // connect to server
    socket = await Socket.connect("0.0.0.0", 3000);

    debugPrint(
        "Client is Connected to Server ${socket?.remoteAddress.address} : ${socket?.remotePort}");

    socket?.listen((data) {
      final serverResponse = String.fromCharCodes(data);
      debugPrint("Client Response is : $serverResponse");
    }, onError: (err) {
      debugPrint("Client error is : $err");
      socket?.destroy();
    }, onDone: () {
      socket?.destroy();
    });
    socket?.write("mahesh");
  }

  void sendMessage(TextEditingController message) async {
    messages.value.add(message.text.trim());
    await Prefs.setStringList("messageList", messages.value);
    socket?.write(messages);
    message.clear();
  }

  ValueNotifier<List<String>?>? get getMessages => ValueNotifier( Prefs.getStringList("messageList")?? []);

  static SocketClientSingleton getInstance() {
    return instance;
  }
}
