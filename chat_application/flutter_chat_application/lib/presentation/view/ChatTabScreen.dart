import 'package:flutter/material.dart';

import '../../client/main.dart';

class ChatTabScreen extends StatelessWidget {
  const ChatTabScreen({super.key});

  static const route = '/ChatTabScreen';

  @override
  Widget build(BuildContext context) {
    final theme = themeManager.theme;
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: theme.primaryColor,
        onPressed: () {},
        child: Icon(
          Icons.chat_rounded,
          color: theme.iconTheme.color,
        ),
      ),
      body: ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/IndividualChatScreen', arguments: index);
              },
              hoverColor: Colors.blueGrey[50],
              leading:
                  CircleAvatar(radius: 30, backgroundColor: theme.primaryColor),
              title: Text("Mahesh", style: theme.textTheme.headlineSmall),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.done_all,
                    size: 12,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text("Hello", style: theme.textTheme.bodySmall),
                ],
              ),
              trailing: const Text('09/23'),
            );
          }),
    );
  }
}
