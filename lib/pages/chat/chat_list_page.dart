import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import 'message_page.dart';

//widget for the list of chats
class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseService _firebaseService = FirebaseService();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getUserChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty){
          return const Center(child: Text("No chats available"));
        }
        final chats = snapshot.data!.docs;
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
            itemCount: chats.length, //change to actual number from future builder
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chatData = chatDoc.data() as Map<String, dynamic>;
              final participants = chatData['participants'] as List<dynamic>;
              final otherUserId = participants.firstWhere(
                  (id) => id != _firebaseService.currentUserId);
              return FutureBuilder<DocumentSnapshot>(
                future: _firebaseService.getUserProfile(otherUserId),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? 'Unknown';
                  final lastMessage = chatData['lastMessage'] ?? '';
                  final userPhoto = userData['photoURL'] ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userPhoto.isNotEmpty
                          ? NetworkImage(userPhoto)
                          : null,
                      child: userPhoto.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text(
                      userName,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.pink,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MessagePage(),
                          // builder: (context) => MessagePage(
                          //   recipientUid: otherUserId,
                          //   recipientName: userName,
                          //   recipientPhotoURL: userPhoto,
                          // ),
                        ),
                      );
                    },
                  );
                },
              );
            }
        );
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
