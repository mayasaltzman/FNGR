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
      final existingChatId = await _firebaseService.getExistingChat(widget.recipientUid);
      print ('existingChatID is $existingChatId');
      if (existingChatId != null){
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
        _chatId = await _firebaseService.sendFirstMessage(recipientUid: widget.recipientUid, text: text);
        _isInitiator = true;

        if(mounted){
          setState(() { });
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

    return LoadChat(
      chatId: _chatId,
      chatController: _chatController,
      sendMessage: _sendMessage,
      firebaseService: _firebaseService,
      isNewChat: _chatId.isEmpty,
    );
  }
}

/// LoadChat: Encapsulates the StreamBuilder and message handling logic
class LoadChat extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (isNewChat) {
      return Chat(
        chatController: chatController,
        currentUserId: firebaseService.currentUserId!,
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
        onMessageSend: sendMessage,
        resolveUser: (userId) async {
          try {
            final userDoc = await firebaseService.getUserProfile(userId);
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
      stream: firebaseService.getMessagesStream(chatId),
      builder: (context, snapshot) {
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
            if (!chatController.messages.any((m) => m.id == message.id)) {
              chatController.insertMessage(message);
            }
          }
        }

        return Chat(
          chatController: chatController,
          currentUserId: firebaseService.currentUserId!,
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
          onMessageSend: sendMessage,
          resolveUser: (userId) async {
            try {
              final userDoc = await firebaseService.getUserProfile(userId);
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
