import 'package:flutter/material.dart';
import 'chat_list_page.dart';

class ChatRequestListPage extends StatefulWidget {
  const ChatRequestListPage({super.key});

  @override
  State<ChatRequestListPage> createState() => _ChatRequestListPageState();
}

class _ChatRequestListPageState extends State<ChatRequestListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          leading:
              BackButton(color: Theme.of(context).colorScheme.secondaryFixed),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Text(
            "Message Requests",
            style:
                TextStyle(color: Theme.of(context).colorScheme.secondaryFixed),
          ),
        ),
        body: const SingleChildScrollView(
            child: Center(
          child: ChatList(), //invoke chatlist from chats
        )));
  }
}
