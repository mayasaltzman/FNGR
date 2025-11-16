import 'package:flutter/material.dart';


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
              Text("Name", style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondaryFixed))
              
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
        ));
    // body: const SingleChildScrollView(
    //     child: Center(
    //   child: ChatList(),
    // )));
  }
}
