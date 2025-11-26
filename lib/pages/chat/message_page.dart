//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import '../../services/firebase_service.dart';

class MessagePage extends StatefulWidget {
  final String recipientUid;
  final String recipientName;
  final String recipientImage;

  const MessagePage({
    required this.recipientUid,
    required this.recipientName,
    required this.recipientImage,
    super.key,
  });

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
        leading: BackButton(
          color: Theme.of(context).colorScheme.secondaryFixed,
        ),
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: widget.recipientImage.isNotEmpty
                  ? NetworkImage(widget.recipientImage)
                  : null,
              child: widget.recipientImage.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            Text(
              widget.recipientName,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondaryFixed,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
            color: Theme.of(context).colorScheme.secondaryFixed,
          ),
        ],
      ),
      body: MessageWidget(
        recipientUid: widget.recipientUid,
        recipientName: widget.recipientName,
      ),
    );
  }
}

class ApproveDeclineWidget extends StatefulWidget {
  final void Function() acceptChat;
  final void Function() rejectChat;
  final String chatId;
  final InMemoryChatController chatController;
  final FirebaseService firebaseService;

  const ApproveDeclineWidget(
      {super.key,
      required this.acceptChat,
      required this.rejectChat,
      required this.chatId,
      required this.chatController,
      required this.firebaseService});

  @override
  ApproveDeclineWidgetState createState() => ApproveDeclineWidgetState();
}

class ApproveDeclineWidgetState extends State<ApproveDeclineWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
          color: Colors.grey[200],
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(5)),
              const Text("User wants to send you a message"),
              const SizedBox(height: 10),
              const Text(
                  "Do you want them to send you messages from now on? They’ll only known you’ve seen their request if you choose Allow.",
                  textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Container(
                height: 78,
                color: Theme.of(context).colorScheme.tertiaryFixed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 60,
                  children: [
                    TextButton(
                        onPressed: widget.rejectChat,
                        child: Text(
                          "Decline",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.primaryFixed),
                        )),
                    const VerticalDivider(
                      width: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    TextButton(
                        onPressed: widget.acceptChat,
                        child: const Text("Allow",
                            style: TextStyle(color: Colors.black)))
                  ],
                ),
              )
            ],
          ))
    ]);
  }
}

class MessageWidget extends StatefulWidget {
  final String recipientUid;
  final String recipientName;

  const MessageWidget({
    super.key,
    required this.recipientUid,
    required this.recipientName,
  });

  @override
  MessageWidgetState createState() => MessageWidgetState();
}

class MessageWidgetState extends State<MessageWidget> {
  final _chatController = InMemoryChatController();
  final FirebaseService _firebaseService = FirebaseService();
  late String _chatId = '';
  bool _isLoading = true;
  bool _isAccepted = false;
  late bool _isInitiator;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    try {
      final existingChatId =
          await _firebaseService.getExistingChat(widget.recipientUid);

      if (existingChatId != null) {
        _chatId = existingChatId;
        _isAccepted = await _firebaseService.isChatAccepted(_chatId);
        _isInitiator = await _firebaseService.isCurrentUserInitiator(_chatId);
      } else {
        _isInitiator = true;
        _isAccepted = false;
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      print('Error initializing chat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _sendMessage(String text) async {
    try {
      if (_chatId.isEmpty) {
        _chatId = await _firebaseService.sendFirstMessage(
            recipientUid: widget.recipientUid, text: text);
        _isInitiator = true;

        if (mounted) {
          setState(() {});
        }
      } else {
        await _firebaseService.sendMessage(chatId: _chatId, text: text);
      }
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _acceptChat() async {
    try {
      await _firebaseService.acceptChat(_chatId);
      if (mounted) {
        setState(() {
          _isAccepted = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept: $e')),
        );
      }
    }
  }

  void _rejectChat() async {
    try {
      await _firebaseService.rejectChat(_chatId);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return _isAccepted
        ? LoadChat(
            chatId: _chatId,
            chatController: _chatController,
            sendMessage: _sendMessage,
            firebaseService: _firebaseService,
            isNewChat: _chatId.isEmpty,
          )
        : ApproveDeclineWidget(
            acceptChat: _acceptChat,
            rejectChat: _rejectChat,
            chatId: _chatId,
            chatController: _chatController,
            firebaseService: _firebaseService);
  }
}

/// LoadChat: Encapsulates the StreamBuilder and message handling logic
class LoadChat extends StatefulWidget {
  final String chatId;
  final InMemoryChatController chatController;
  final FirebaseService firebaseService;
  final Function(String) sendMessage;
  final bool isNewChat;

  const LoadChat({
    super.key,
    required this.chatId,
    required this.chatController,
    required this.firebaseService,
    required this.sendMessage,
    this.isNewChat = false,
  });

  @override
  State<LoadChat> createState() => _LoadChatState();
}

class _LoadChatState extends State<LoadChat> {
  bool _initialLoadComplete = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isNewChat) {
      return Chat(
        chatController: widget.chatController,
        currentUserId: widget.firebaseService.currentUserId!,
        backgroundColor: Theme.of(context).colorScheme.primary,
        builders: Builders(
          textMessageBuilder: (context, message, index,
              {required bool isSentByMe, MessageGroupStatus? groupStatus}) {
            return SimpleTextMessage(
              message: message,
              index: index,
              sentBackgroundColor: Theme.of(context).colorScheme.tertiaryFixed,
              sentTextStyle: TextStyle(color: Colors.grey[900]),
              timeStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
            );
          },
        ),
        onMessageSend: widget.sendMessage,
        resolveUser: (userId) async {
          try {
            final userDoc = await widget.firebaseService.getUserProfile(userId);
            final userData = userDoc.data() as Map<String, dynamic>?;
            return User(
              id: userId,
              name: userData?['name'] ?? 'Unknown',
            );
          } catch (e) {
            return User(id: userId, name: 'Unknown');
          }
        },
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: widget.firebaseService.getMessagesStream(widget.chatId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !_initialLoadComplete) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading messages'));
        }

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final timestamp = data['createdAt'] as Timestamp?;
            final message = TextMessage(
              id: doc.id,
              authorId: data['authorId'] ?? '',
              createdAt: timestamp?.toDate() ?? DateTime.now(),
              text: data['text'] ?? '',
            );

            // Avoid duplicates
            if (!widget.chatController.messages
                .any((m) => m.id == message.id)) {
              widget.chatController.insertMessage(message);
            }
          }
        }

        return Chat(
          chatController: widget.chatController,
          currentUserId: widget.firebaseService.currentUserId!,
          backgroundColor: Theme.of(context).colorScheme.primary,
          builders: Builders(
            textMessageBuilder: (context, message, index,
                {required bool isSentByMe, MessageGroupStatus? groupStatus}) {
              return SimpleTextMessage(
                message: message,
                index: index,
                sentBackgroundColor:
                    Theme.of(context).colorScheme.tertiaryFixed,
                sentTextStyle: TextStyle(color: Colors.grey[900]),
                timeStyle: TextStyle(color: Colors.grey[600], fontSize: 10),
              );
            },
          ),
          onMessageSend: widget.sendMessage,
          resolveUser: (userId) async {
            try {
              final userDoc =
                  await widget.firebaseService.getUserProfile(userId);
              final userData = userDoc.data() as Map<String, dynamic>?;
              return User(
                id: userId,
                name: userData?['name'] ?? 'Unknown',
              );
            } catch (e) {
              return User(id: userId, name: 'Unknown');
            }
          },
        );
      },
    );
  }
}
