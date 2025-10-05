import 'dart:async';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final StreamController<List<Map<String, dynamic>>> _chatController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  final List<Map<String, dynamic>> _chats = [];

  void setInitialChats(List<Map<String, dynamic>> chats) {
    _chats.clear();
    _chats.addAll(chats);
    _chatController.add(List.from(_chats));
  }

  Stream<List<Map<String, dynamic>>> get chatStream => _chatController.stream;

  List<Map<String, dynamic>> get chats => List.from(_chats);

  void sendMessage(Map<String, dynamic> chat, String message) {
    final index = _chats.indexOf(chat);
    if (index != -1) {
      final now = DateTime.now();
      final msg = {
        'sender': 'you',
        'time': '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
        'message': message,
      };

      _chats[index]['messages'].add(msg);
      _chats[index]['lastMessage'] = message;
      _chats[index]['lastTime'] = msg['time'];

      _chatController.add(List.from(_chats));
    }
  }
}
