import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: BackButton(
            color: Theme.of(context)
                .colorScheme
                .secondaryFixed), //need to make this actually do something and give it color change for press
        actions: [TextButton(onPressed: () {}, child: const Text("Message Requests"))],
      ),
    );
  }
}
