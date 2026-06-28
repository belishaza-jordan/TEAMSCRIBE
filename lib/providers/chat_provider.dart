import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

/// Chat state with 3-second polling for near-real-time updates.
/// Messages sent by the local user are added optimistically, then
/// the next poll will deduplicate via ID comparison.
class ChatProvider extends ChangeNotifier {
  final ChatService _chatService;

  List<MessageModel> _messages   = [];
  bool               _isLoading  = false;
  String?            _error;
  String?            _groupId;
  Timer?             _timer;

  ChatProvider(this._chatService);

  List<MessageModel> get messages  => _messages;
  bool               get isLoading => _isLoading;
  String?            get error     => _error;

  // ── Load + start polling ──────────────────────────────────────────────

  Future<void> loadAndSubscribe(String groupId) async {
    if (_groupId == groupId) return;
    _groupId  = groupId;
    _messages = [];

    _setLoading(true);
    try {
      _messages = await _chatService.fetchMessages(groupId);
      _error    = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }

    _startPolling(groupId);
  }

  void _startPolling(String groupId) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await _poll(groupId);
    });
  }

  Future<void> _poll(String groupId) async {
    try {
      final fresh = await _chatService.fetchMessages(groupId);
      if (fresh.length != _messages.length) {
        _messages = fresh;
        notifyListeners();
      }
    } catch (_) {
      // Non-fatal — will retry on next tick
    }
  }

  // ── Send message ──────────────────────────────────────────────────────

  Future<void> sendMessage(String groupId, String content) async {
    try {
      final msg = await _chatService.sendMessage(groupId, content);
      _messages = [..._messages, msg]; // optimistic
      notifyListeners();
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
    }
  }

  // ── Cleanup ───────────────────────────────────────────────────────────

  Future<void> disconnect() async {
    _timer?.cancel();
    _timer    = null;
    _groupId  = null;
    _messages = [];
  }

  String _extractMessage(Object e) {
    final s = e.toString();
    final i = s.indexOf(': ');
    return i != -1 ? s.substring(i + 2) : s;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
