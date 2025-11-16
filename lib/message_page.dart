import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  @override
  MessageWidgetState createState() => MessageWidgetState();
}

class MessageWidgetState extends State<MessageWidget> {
  final _chatController = InMemoryChatController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //replace users with db data
    return Scaffold(
      //this is from https://pub.dev/packages/flutter_chat_core/example
      //more documentation how to work with chat https://flyer.chat/docs/flutter/guides/dynamic-theming/
      body: Chat(
        chatController: _chatController,
        currentUserId: 'user1',
        backgroundColor: Theme.of(context).colorScheme.primary,
        //builders allow for styling of message theme
        //need to test what another user message looks like once logs are created 
        builders: Builders(
          textMessageBuilder: (
            context,
            message,
            index, {
            required bool isSentByMe,
            MessageGroupStatus? groupStatus,
          }) {
            return SimpleTextMessage(
              message: message,
              index: index,
              sentBackgroundColor: Theme.of(context).colorScheme.tertiaryFixed,
              sentTextStyle: TextStyle(color: Colors.grey[900]),
              timeStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
            );
          },
        ),
        onMessageSend: (text) {
          _chatController.insertMessage(
            TextMessage(
              // Better to use UUID or similar for the ID - IDs must be unique
              id: '${Random().nextInt(1000) + 1}',
              authorId: 'user1',
              createdAt: DateTime.now().toUtc(),
              text: text,
            ),
          );
        },
        resolveUser: (UserID id) async {
          return User(id: id, name: 'John Doe');
        },
      ),
    );
  }
}

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          leading:
              BackButton(color: Theme.of(context).colorScheme.secondaryFixed),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //replace with info from actual user
              const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/women/2.jpg",
                  )),
              Text("Name",
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondaryFixed))
            ],
          ),
          actions: [
            //video call button maybe a future element :/
            //IconButton(
            // onPressed: () {},
            // icon: const Icon(Icons.video_call_rounded),
            // color: Theme.of(context).colorScheme.secondaryFixed),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                color: Theme.of(context).colorScheme.secondaryFixed),
          ],
        ),
        body: const MessageWidget());
  }
}
