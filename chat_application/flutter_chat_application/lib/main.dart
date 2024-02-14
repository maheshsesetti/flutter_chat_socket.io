import 'dart:isolate';

  // Import the client file and call its main function
  import 'client/main.dart' as client;
  import 'server/server.dart' as server;
void main() async {
  
  // Spawn server isolate
  final serverReceivePort = ReceivePort();
  await Isolate.spawn(serverEntryPoint, serverReceivePort.sendPort);

  // Spawn client isolate
  // final clientReceivePort = ReceivePort();
  // await Isolate.spawn(clientEntryPoint, clientReceivePort.sendPort);
  client.main();
}

void serverEntryPoint(SendPort sendPort) {
  serverClient(sendPort);
}

void clientEntryPoint(SendPort sendPort) {
 runClient(sendPort);
}

void runClient(SendPort sendPort) {
  sendPort.send('running client');

  client.main();
}

void serverClient(SendPort sendPort) {
  sendPort.send('running Server');

  server.main();
}