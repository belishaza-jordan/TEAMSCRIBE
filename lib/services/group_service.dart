import '../config/api_config.dart';
import '../models/group_model.dart';
import 'api_service.dart';

class GroupService {
  final ApiService _api;

  GroupService(this._api);

  Future<List<GroupModel>> fetchMyGroups() async {
    final data = await _api.get(ApiConfig.groupsEndpoint);
    return (data['groups'] as List)
        .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GroupModel> fetchGroup(String groupId) async {
    final data = await _api.get('${ApiConfig.groupsEndpoint}/$groupId');
    return GroupModel.fromJson(data['group'] as Map<String, dynamic>);
  }

  Future<GroupModel> createGroup(String name, String description) async {
    final data = await _api.post(ApiConfig.groupsEndpoint, {
      'name': name,
      'description': description,
    });
    return GroupModel.fromJson(data['group'] as Map<String, dynamic>);
  }

  Future<void> inviteMember(String groupId, String email) async {
    await _api.post('${ApiConfig.groupsEndpoint}/$groupId/invite', {
      'email': email,
    });
  }

  Future<void> deleteGroup(String groupId) async {
    await _api.delete('${ApiConfig.groupsEndpoint}/$groupId');
  }
}
