import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/Models/user_chats.dart';
import '../../../provider/services/chat_services.dart';
import '../../../shared/theme_data.dart';

class ChatListTile extends StatelessWidget {
  final ChatThread chatThread;
  final VoidCallback onTap;

  const ChatListTile({
    Key? key,
    required this.chatThread,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, chatService, child) {
        final displayName = chatService.getChatDisplayName(chatThread);
        final participants = chatService.getChatParticipants(chatThread);
        final lastMessageSender = chatThread.lastMessageSenderId != null
            ? chatService.getUser(chatThread.lastMessageSenderId!)
            : null;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: ListTile(
            leading: _buildAvatar(context, participants, chatService),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    displayName,
                    style:  TextStyle(fontWeight: FontWeight.bold, color: lightColorScheme.secondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (chatThread.type == ChatThreadType.group)
                  Icon(Icons.group, size: 16, color: Colors.grey[600]),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (chatThread.type == ChatThreadType.group)
                  Text(
                    '${participants.length} participants',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                if (chatThread.lastMessageText != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (lastMessageSender != null && chatThread.type == ChatThreadType.group)
                        Text(
                          '${lastMessageSender.name}: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: lastMessageSender.roleColor,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          chatThread.lastMessageText!,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(chatThread.lastMessageAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context, List<User> participants, ChatService chatService) {
    if (chatThread.type == ChatThreadType.group) {
      return  CircleAvatar(
        backgroundColor: lightColorScheme.primary,
        child: const Icon(Icons.group, color: Colors.white),
      );
    } else {
      // For 1-on-1 chats, show the other participant's avatar
      final otherParticipant = participants.firstWhere(
            (user) => user?.id != chatService.currentUser.id,
        orElse: () => participants.first,
      );

      return CircleAvatar(
        backgroundColor: otherParticipant.roleColor,
        child: Text(
          otherParticipant.name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
