import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_application/presentation/controller/chat_Notifier.dart';

import '../../client/main.dart';
import '../../utils/socket/socket_client.dart';
import '../widgets/custom_textfield.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({super.key});
  static const route = '/IndividualChatScreen';

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  ChatNotifier chatNotifier = ChatNotifier();
  TextEditingController messageEditingController = TextEditingController();
  final _textFieldKey = UniqueKey();
  final SocketClientSingleton _singleton = SocketClientSingleton.getInstance();

  @override
  void initState() {
    _singleton.initSocket();
    super.initState();
    chatNotifier.addListenerNode();
  }

  @override
  Widget build(BuildContext context) {
    // final selectedIndex = ModalRoute.of(context)!.settings.arguments;
    final theme = themeManager.theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leadingWidth: 15,
        centerTitle: false,
        iconTheme: theme.appBarTheme.iconTheme,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
            ),
            SizedBox(
              width: 5,
            ),
            Text("Mahesh",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold))
          ],
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'Add to Contacts',
                child: Text('Add to Contacts'),
              )
            ];
          })
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PopScope(
          canPop: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: _singleton.getMessages!,
                      builder: (context, value, _) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: value?.length,
                            itemBuilder: (context, index) {
                              return Text(value![index]);
                            });
                      })),
              Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              flex: 6,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ValueListenableBuilder(
                                        valueListenable: chatNotifier.isShow,
                                        builder: (context, value, child) {
                                          return CustomTextField(
                                            key: _textFieldKey,
                                            focusNode: chatNotifier.focusNode,
                                            textController:
                                                messageEditingController,
                                            prefixIcon: IconButton(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                onPressed: () {
                                                  chatNotifier
                                                      .onChangeEmoji(context);
                                                },
                                                icon: Icon(chatNotifier
                                                        .isShow.value
                                                    ? Icons.keyboard
                                                    : Icons
                                                        .emoji_emotions_outlined)),
                                            border: InputBorder.none,
                                            suffixIcon: const Icon(
                                                Icons.attach_file_rounded),
                                            onChanged: (value) {
                                              chatNotifier.updateIcon(value);
                                            },
                                          );
                                        })),
                              )),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: CircleAvatar(
                              backgroundColor: theme.primaryColor,
                              radius: 20,
                              child: ValueListenableBuilder(
                                  valueListenable: chatNotifier.isChange,
                                  builder: (context, value, child) {
                                    return IconButton(
                                      onPressed: () {
                                        chatNotifier.isChange.value
                                            ? _singleton.sendMessage(
                                                messageEditingController)
                                            : "";

                                        setState(() {});
                                      },
                                      icon: Icon(
                                        chatNotifier.isChange.value
                                            ? Icons.send_rounded
                                            : Icons.mic,
                                      ),
                                      color: theme.iconTheme.color,
                                    );
                                  }),
                            ),
                          ))
                        ]),
                  ),
                  ValueListenableBuilder(
                      valueListenable: chatNotifier.isShow,
                      builder: (context, value, child) {
                        return chatNotifier.isShow.value
                            ? changeEmoji()
                            : Container();
                      })
                ],
              )
            ],
          ),
          onPopInvoked: (didPop) async {
            if (didPop) {
              return;
            }
            if (chatNotifier.isShow.value) {
              chatNotifier.isShow.value = false;
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget changeEmoji() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        messageEditingController
          ..text += emoji.emoji
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: messageEditingController.text.length));
      },
      onBackspacePressed: () {
        messageEditingController
          ..text =
              messageEditingController.text.characters.skipLast(1).toString()
          ..selection = TextSelection.fromPosition(
              TextPosition(offset: messageEditingController.text.length));
      },
      config: Config(
        categoryViewConfig: const CategoryViewConfig(
          initCategory: Category.SMILEYS,
        ),
        emojiViewConfig: EmojiViewConfig(
          backgroundColor: Colors.white,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
          verticalSpacing: 0,
          horizontalSpacing: 0,
          columns: 7,
          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}
