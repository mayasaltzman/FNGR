import 'package:flutter/material.dart';

//widget for the list of chats
class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      //this list view builder will go inside future builder the will fetch the chats associated with this user
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(left: 85.0),
          child: Divider(
            height: 20,
            thickness: 0.75,
            color: Theme.of(context).colorScheme.tertiary,
          )),
      itemCount: 10, //change to actual number from future builder
      itemBuilder: (context, index) {
        return ListTile(
            title: const Text("Test"),
            subtitle: const Text("message"),
            trailing: Icon(Icons.arrow_forward,
                color: Theme.of(context).colorScheme.tertiary),
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                "https://randomuser.me/api/portraits/women/2.jpg",
              ), //replace with image from db
            ));
      },
    );
  }
}

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
          actions: [
            TextButton(onPressed: () {}, child: const Text("Message Requests"))
          ],
        ),
        body: const SingleChildScrollView(
            child: Center(
          child: ChatList(),
        )));
  }
}
