import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

void main() async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;
  final server = await ServerSocket.bind(ip, 3000);
  debugPrint("server is running : ${server.address.address}:3000");

  server.listen((event) {
    handleConnection(event);
  });
}

List<Socket> clients = [];

void handleConnection(Socket client) {
  debugPrint(
      "Server: Connection from ${client.remoteAddress.address}:${client.remotePort}");
  client.listen(
    (Uint8List data) {
      final message = String.fromCharCodes(data);
      for (final c in clients) {
        c.write("Server:$message join in the party");
      }
      clients.add(client);
      client.write("Server: you are logged in as : $message");
    },
    onDone: () {
      debugPrint("Server connection Left");
      client.close();
    },
    onError: (error) {
      debugPrint(error);
      client.close();
    },
  );
}