import '../config/api_config.dart';
import '../models/message_model.dart';
import 'api_service.dart';

class ChatService {
  final ApiService _api;

  ChatService(this._api);

  Future<List<MessageModel>> fetchMessages(String groupId) async {
    final data = await _api
        .get('${ApiConfig.groupsEndpoint}/$groupId${ApiConfig.chatEndpoint}');
    return (data['messages'] as List)
        .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MessageModel> sendMessage(String groupId, String content) async {
    final data = await _api.post(
        '${ApiConfig.groupsEndpoint}/$groupId${ApiConfig.chatEndpoint}',
        {'content': content});
    return MessageModel.fromJson(data['message'] as Map<String, dynamic>);
  }

  Future<void> markRead(String groupId) async {
    await _api.put(
        '${ApiConfig.groupsEndpoint}/$groupId${ApiConfig.chatEndpoint}/read',
        {});
  }
}
