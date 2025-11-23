import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import './request_list_page.dart';
import 'message_page.dart';

//widget for the list of chats
class ChatList extends StatefulWidget {
  final String listType;
  const ChatList({super.key, required this.listType});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.listType == "accepted"
      ? _firebaseService.getAcceptedChatsStream()
      : _firebaseService.getUnaccceptedChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return const Center(child: Text("No chats available"));
        }
        final chats = snapshot.data!.docs.where((chatDoc) {
          final chatData = chatDoc.data() as Map<String, dynamic>;
          final lastMessage = chatData['lastMessage'];
          return lastMessage != null && (lastMessage as String).trim().isNotEmpty;
        }).toList();

        return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(left: 85.0),
                child: Divider(
                  height: 20,
                  thickness: 0.75,
                  color: Theme.of(context).colorScheme.tertiary,
                )),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final participants = chatData['participants'] as List<dynamic>;
              final otherUserId = participants
                  .firstWhere((id) => id != _firebaseService.currentUserId);
              return FutureBuilder<DocumentSnapshot>(
                future: _firebaseService.getUserProfile(otherUserId),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  print("user snapshot data: ${userSnapshot.data!.data()}");
                  final data = userSnapshot.data!.data();
                  if (data == null) {
                    return const ListTile(
                      title: Text('Unknown User'),
                    );
                  }
                  final userData = data as Map<String, dynamic>;

                  final userName = userData['name'] ?? 'Unknown';
                  final lastMessage = chatData['lastMessage'] ?? '';
                  final userPhoto = userData['photoURL'] ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          userPhoto.isNotEmpty ? NetworkImage(userPhoto) : null,
                      child:
                          userPhoto.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(
                            recipientUid: otherUserId,
                            recipientName: userName,
                            recipientImage: userPhoto,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            });
      },
    );
  }
}

class ChatListPage extends StatefulWidget {
  final String listType;
  const ChatListPage({super.key, required this.listType});

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
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestListPage()),
                  );
                },
                child: const Text("Message Requests"))
          ],
        ),
        body: SingleChildScrollView(
            child: Center(
          child: ChatList(listType: widget.listType),
        )));
  }
}
