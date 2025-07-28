// screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/Models/user_chats.dart';
import '../../provider/services/chat_services.dart';
import '../../shared/theme_data.dart';
import 'widgets/message_bubbles.dart';
import 'widgets/message_inputs.dart';

class AdminChatScreen extends StatefulWidget {
  final String chatThreadId;

  const AdminChatScreen({Key? key, required this.chatThreadId}) : super(key: key);

  @override
  _AdminChatScreenState createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Auto-scroll to bottom when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        title: Consumer<ChatService>(
          builder: (context, chatService, child) {
            final chatThread = chatService.getChatThread(widget.chatThreadId);
            if (chatThread == null) return const Text('Chat', style: TextStyle(color: Colors.white, fontSize: 16));

            final displayName = chatService.getChatDisplayName(chatThread);
            final participants = chatService.getChatParticipants(chatThread);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: const TextStyle(fontSize: 16, color: Colors.white)),
                if (chatThread.type == ChatThreadType.group)
                  Text(
                    '${participants.length} participants',
                    style:  TextStyle(fontSize: 12, color: Colors.grey[100]),
                  ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Consumer<ChatService>(
              builder: (context, chatService, child) {
                final messages = chatService.getMessages(widget.chatThreadId);

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                // Auto-scroll when messages change
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final sender = chatService.getUser(message.senderId);
                    final isMe = message.senderId == chatService.currentUser.id;

                    return MessageBubble(
                      message: message,
                      sender: sender,
                      isMe: isMe,
                      showSenderInfo: !isMe, // Show sender info for others' messages
                    );
                  },
                );
              },
            ),
          ),
          // Message input
          MessageInput(
            onSendMessage: (text) {
              Provider.of<ChatService>(context, listen: false)
                  .sendMessage(widget.chatThreadId, text);
            },
          ),
        ],
      ),
    );
  }
}

