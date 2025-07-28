import 'package:flutter/cupertino.dart';

import '../Models/user_chats.dart';

class ChatService extends ChangeNotifier {
  // Current user (simulated login)
  late User _currentUser;

  // In-memory data stores
  final Map<String, User> _users = {};
  final Map<String, ChatThread> _chatThreads = {};
  final Map<String, List<Message>> _messages = {};

  ChatService() {
    _initializeMockData();
  }

  // Getters
  User get currentUser => _currentUser;
  List<ChatThread> get chatThreads => _chatThreads.values.toList()
    ..sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));

  User? getUser(String userId) => _users[userId];

  List<Message> getMessages(String chatThreadId) {
    return _messages[chatThreadId] ?? [];
  }

  ChatThread? getChatThread(String chatThreadId) {
    return _chatThreads[chatThreadId];
  }

  // Initialize mock data for testing
  void _initializeMockData() {
    // Create mock users
    final users = [
      User(id: '1', name: 'John Smith', role: UserRole.coach),
      User(id: '2', name: 'Sarah Johnson', role: UserRole.player),
      User(id: '3', name: 'Mike Wilson', role: UserRole.player),
      User(id: '4', name: 'Admin User', role: UserRole.admin),
      User(id: '5', name: 'Emma Davis', role: UserRole.player),
    ];

    for (var user in users) {
      _users[user.id] = user;
    }

    // Set current user (simulate login)
    _currentUser = users[0]; // John Smith (Coach)

    // Create mock chat threads
    final now = DateTime.now();

    // 1-on-1 chat: Coach with Player
    final chat1 = ChatThread(
      id: 'chat1',
      name: 'Sarah Johnson',
      type: ChatThreadType.oneOnOne,
      participantIds: ['1', '2'],
      createdAt: now.subtract(Duration(days: 2)),
      lastMessageAt: now.subtract(Duration(minutes: 30)),
      lastMessageText: 'Thanks coach! See you at practice.',
      lastMessageSenderId: '2',
    );

    // Group chat: Team chat
    final chat2 = ChatThread(
      id: 'chat2',
      name: 'Team Warriors',
      type: ChatThreadType.group,
      participantIds: ['1', '2', '3', '5'],
      createdAt: now.subtract(Duration(days: 5)),
      lastMessageAt: now.subtract(Duration(hours: 2)),
      lastMessageText: 'Great practice today everyone!',
      lastMessageSenderId: '1',
    );

    // Admin announcement group
    final chat3 = ChatThread(
      id: 'chat3',
      name: 'Announcements',
      type: ChatThreadType.group,
      participantIds: ['1', '2', '3', '4', '5'],
      createdAt: now.subtract(Duration(days: 10)),
      lastMessageAt: now.subtract(Duration(days: 1)),
      lastMessageText: 'Tournament registration closes Friday.',
      lastMessageSenderId: '4',
    );

    _chatThreads[chat1.id] = chat1;
    _chatThreads[chat2.id] = chat2;
    _chatThreads[chat3.id] = chat3;

    // Create mock messages
    _messages[chat1.id] = [
      Message(
        id: 'msg1',
        senderId: '1',
        chatThreadId: chat1.id,
        text: 'Hi Sarah, how\'s your preparation going for the upcoming match?',
        timestamp: now.subtract(Duration(hours: 1)),
      ),
      Message(
        id: 'msg2',
        senderId: '2',
        chatThreadId: chat1.id,
        text: 'Going well coach! I\'ve been working on those drills you suggested.',
        timestamp: now.subtract(Duration(minutes: 45)),
      ),
      Message(
        id: 'msg3',
        senderId: '2',
        chatThreadId: chat1.id,
        text: 'Thanks coach! See you at practice.',
        timestamp: now.subtract(Duration(minutes: 30)),
      ),
    ];

    _messages[chat2.id] = [
      Message(
        id: 'msg4',
        senderId: '1',
        chatThreadId: chat2.id,
        text: 'Team meeting tomorrow at 5 PM. Don\'t miss it!',
        timestamp: now.subtract(Duration(hours: 3)),
      ),
      Message(
        id: 'msg5',
        senderId: '3',
        chatThreadId: chat2.id,
        text: 'Will be there coach!',
        timestamp: now.subtract(Duration(hours: 2, minutes: 30)),
      ),
      Message(
        id: 'msg6',
        senderId: '1',
        chatThreadId: chat2.id,
        text: 'Great practice today everyone!',
        timestamp: now.subtract(Duration(hours: 2)),
      ),
    ];

    _messages[chat3.id] = [
      Message(
        id: 'msg7',
        senderId: '4',
        chatThreadId: chat3.id,
        text: 'Welcome to the sports platform! Please keep all communications respectful.',
        timestamp: now.subtract(Duration(days: 2)),
      ),
      Message(
        id: 'msg8',
        senderId: '4',
        chatThreadId: chat3.id,
        text: 'Tournament registration closes Friday.',
        timestamp: now.subtract(Duration(days: 1)),
      ),
    ];
  }

  // Send a new message
  void sendMessage(String chatThreadId, String text) {
    if (text.trim().isEmpty) return;

    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUser.id,
      chatThreadId: chatThreadId,
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    // Add message to thread
    if (_messages[chatThreadId] == null) {
      _messages[chatThreadId] = [];
    }
    _messages[chatThreadId]!.add(message);

    // Update chat thread's last message info
    final chatThread = _chatThreads[chatThreadId];
    if (chatThread != null) {
      _chatThreads[chatThreadId] = chatThread.copyWith(
        lastMessageAt: message.timestamp,
        lastMessageText: message.text,
        lastMessageSenderId: message.senderId,
      );
    }

    notifyListeners();
  }

  // Get display name for chat thread
  String getChatDisplayName(ChatThread chatThread) {
    if (chatThread.type == ChatThreadType.group) {
      return chatThread.name;
    } else {
      // For 1-on-1 chats, show the other participant's name
      final otherParticipantId = chatThread.participantIds
          .firstWhere((id) => id != _currentUser.id, orElse: () => '');
      final otherUser = _users[otherParticipantId];
      return otherUser?.name ?? 'Unknown User';
    }
  }

  // Get participants for display
  List<User> getChatParticipants(ChatThread chatThread) {
    return chatThread.participantIds
        .map((id) => _users[id])
        .where((user) => user != null)
        .cast<User>()
        .toList();
  }

  // Get all users except current user (for new chat creation)
  List<User> getAvailableUsers() {
    return _users.values
        .where((user) => user.id != _currentUser.id)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  // Create a new chat thread
  String createNewChat({
    required List<String> participantIds,
    String? groupName,
  }) {
    // Always include current user
    final allParticipants = <String>{_currentUser.id, ...participantIds}.toList();

    final chatId = 'chat_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    // Determine chat type and name
    final isGroup = allParticipants.length > 2;
    String chatName;

    if (isGroup) {
      chatName = groupName ?? 'Group Chat';
    } else {
      // For 1-on-1, use the other person's name
      final otherUserId = participantIds.first;
      final otherUser = _users[otherUserId];
      chatName = otherUser?.name ?? 'Unknown User';
    }

    final newChat = ChatThread(
      id: chatId,
      name: chatName,
      type: isGroup ? ChatThreadType.group : ChatThreadType.oneOnOne,
      participantIds: allParticipants,
      createdAt: now,
      lastMessageAt: now,
      lastMessageText: null,
      lastMessageSenderId: null,
    );

    _chatThreads[chatId] = newChat;
    _messages[chatId] = [];

    notifyListeners();
    return chatId;
  }

  // Check if a 1-on-1 chat already exists with a user
  String? getExistingOneOnOneChat(String otherUserId) {
    for (final chatThread in _chatThreads.values) {
      if (chatThread.type == ChatThreadType.oneOnOne &&
          chatThread.participantIds.contains(otherUserId) &&
          chatThread.participantIds.contains(_currentUser.id)) {
        return chatThread.id;
      }
    }
    return null;
  }
}