import 'package:flutter/material.dart';
import 'chat_list_page.dart';

class RequestListPage extends StatefulWidget {
  const RequestListPage({super.key});

  @override
  State<RequestListPage> createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
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
          child: ChatList(listType: "unaccepted"), //invoke chatlist from chats
        )));
  }
}
