import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _chatService;

  List<MessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;

  ChatProvider(this._chatService);

  List<MessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMessages(String groupId) async {
    _setLoading(true);
    try {
      _messages = await _chatService.fetchMessages(groupId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendMessage(String groupId, String content) async {
    try {
      final msg = await _chatService.sendMessage(groupId, content);
      _messages = [..._messages, msg];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markRead(String groupId) async {
    await _chatService.markRead(groupId);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
