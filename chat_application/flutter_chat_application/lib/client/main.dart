
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_application/presentation/view/ChatTabScreen.dart';
import 'package:flutter_chat_application/presentation/view/Home_Page.dart';
import 'package:flutter_chat_application/presentation/view/IndividualChatScreen.dart';
import 'package:flutter_chat_application/presentation/view/profile_screen.dart';
import 'package:flutter_chat_application/presentation/view/register_screen.dart';
import 'package:flutter_chat_application/utils/Theme/theme_manager.dart';
import 'package:flutter_chat_application/utils/services/share_preference.dart';

import '../firebase_options.dart';



final navigatorKey = GlobalKey<NavigatorState>();
final themeManager = ThemeManage();

Client client = Client();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  // final file = File('.env');
  // final lines = await file.readAsLines();
  // final env = <String,String>{};
  // for (final line in lines) {
  //   final parts = line.split('=');
  //   if (parts.length == 2) {
  //     env[parts[0]] = parts[1];
  //   }
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  client
    .setEndpoint("https://cloud.appwrite.io/v1")
    .setProject("65d030089dc7f72656a7")
    .setSelfSigned(status: true); 
  
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      routes: {
        ProfileScreen.route: (context) =>const ProfileScreen(),
        HomePage.route : (context) => const HomePage(),
        ChatTabScreen.route: (context) => const ChatTabScreen(),
        IndividualChatScreen.route: (context) => const IndividualChatScreen(),
      },
      home: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegisterScreen();
  }
}
