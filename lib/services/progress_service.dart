import '../config/api_config.dart';
import '../models/activity_model.dart';
import 'api_service.dart';

class ProgressService {
  final ApiService _api;

  ProgressService(this._api);

  Future<List<MemberProgressModel>> fetchMemberProgress(String groupId) async {
    final data = await _api
        .get('${ApiConfig.groupsEndpoint}/$groupId/progress');
    return (data['members'] as List)
        .map((m) => MemberProgressModel.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<List<ActivityModel>> fetchActivities(String groupId) async {
    final data = await _api
        .get('${ApiConfig.groupsEndpoint}/$groupId/activities');
    return (data['activities'] as List)
        .map((a) => ActivityModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }

  Future<List<ActivityModel>> fetchNotifications() async {
    final data = await _api.get('/notifications');
    return (data['notifications'] as List)
        .map((a) => ActivityModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }
}
