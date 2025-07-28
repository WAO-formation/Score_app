// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Team_Owners/chats/widgets/chats-list-title.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../provider/services/chat_services.dart';
import 'chats_screen.dart';



class AdminChatListScreen extends StatelessWidget {
  const AdminChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.secondary,
        title: const Text('Chats', style: TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          // Show current user info
          Consumer<ChatService>(
            builder: (context, chatService, child) {
              final currentUser = chatService.currentUser;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: currentUser.roleColor,
                      child: Text(
                        currentUser.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          currentUser.roleDisplayName,
                          style:  TextStyle(fontSize: 10, color: Colors.grey[200]),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ChatService>(
        builder: (context, chatService, child) {
          final chatThreads = chatService.chatThreads;

          if (chatThreads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to start a new chat',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: ListView.builder(
              itemCount: chatThreads.length,
              itemBuilder: (context, index) {
                final chatThread = chatThreads[index];
                return ChatListTile(
                  chatThread: chatThread,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminChatScreen(chatThreadId: chatThread.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightColorScheme.secondary,
        onPressed: () => _showNewChatDialog(context),
        tooltip: 'Start new chat',
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => NewChatDialog(),
    );
  }
}

class NewChatDialog extends StatefulWidget {
  const NewChatDialog({super.key});

  @override
  _NewChatDialogState createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final Set<String> _selectedUserIds = {};
  final TextEditingController _groupNameController = TextEditingController();
  bool _isGroup = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, chatService, child) {
        final availableUsers = chatService.getAvailableUsers();

        return AlertDialog(
          title: const Text('New Chat', style: TextStyle(fontWeight: FontWeight.w500)),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Toggle between 1-on-1 and group chat
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('1-on-1'),
                        value: false,
                        groupValue: _isGroup,
                        onChanged: (value) {
                          setState(() {
                            _isGroup = value!;
                            if (!_isGroup) {
                              // For 1-on-1, limit to 1 selection
                              if (_selectedUserIds.length > 1) {
                                final firstId = _selectedUserIds.first;
                                _selectedUserIds.clear();
                                _selectedUserIds.add(firstId);
                              }
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Group'),
                        value: true,
                        groupValue: _isGroup,
                        onChanged: (value) {
                          setState(() {
                            _isGroup = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                // Group name input (only for group chats)
                if (_isGroup) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _groupNameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name',
                      hintText: 'Enter group name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                Text(
                  'Select ${_isGroup ? 'participants' : 'person'} to chat with:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // User list
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: availableUsers.length,
                    itemBuilder: (context, index) {
                      final user = availableUsers[index];
                      final isSelected = _selectedUserIds.contains(user.id);

                      return CheckboxListTile(
                        title: Text(user.name),
                        subtitle: Text(user.roleDisplayName),
                        secondary: CircleAvatar(
                          backgroundColor: user.roleColor,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        value: isSelected,
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              if (!_isGroup) {
                                // For 1-on-1, replace selection
                                _selectedUserIds.clear();
                              }
                              _selectedUserIds.add(user.id);
                            } else {
                              _selectedUserIds.remove(user.id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _selectedUserIds.isEmpty ? null : () => _createChat(context, chatService),
              child: const Text('Create Chat'),
            ),
          ],
        );
      },
    );
  }

  void _createChat(BuildContext context, ChatService chatService) {
    if (_selectedUserIds.isEmpty) return;

    String? chatId;

    if (!_isGroup && _selectedUserIds.length == 1) {
      // Check if 1-on-1 chat already exists
      final existingChatId = chatService.getExistingOneOnOneChat(_selectedUserIds.first);
      if (existingChatId != null) {
        // Navigate to existing chat
        Navigator.pop(context); // Close dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminChatScreen(chatThreadId: existingChatId),
          ),
        );
        return;
      }
    }

    // Create new chat
    chatId = chatService.createNewChat(
      participantIds: _selectedUserIds.toList(),
      groupName: _isGroup ? _groupNameController.text.trim() : null,
    );

    Navigator.pop(context); // Close dialog

    // Navigate to new chat
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminChatScreen(chatThreadId: chatId!),
      ),
    );
  }
}

