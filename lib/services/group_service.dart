import '../config/api_config.dart';
import '../models/group_model.dart';
import '../models/invitation_model.dart';
import 'api_service.dart';

class GroupService {
  final ApiService _api;

  GroupService(this._api);

  /// Fetches only the join_code for a group — lightweight call.
  Future<String?> fetchJoinCode(String groupId) async {
    final data = await _api.get('${ApiConfig.groupsEndpoint}/$groupId');
    final group = data['group'] as Map<String, dynamic>?;
    return group?['join_code'] as String?;
  }

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

  Future<GroupModel> createGroup({
    required String name,
    String? course,
    String? description,
  }) async {
    final data = await _api.post(ApiConfig.groupsEndpoint, {
      'name': name,
      if (course != null && course.isNotEmpty) 'course': course,
      if (description != null && description.isNotEmpty)
        'description': description,
    });
    return GroupModel.fromJson(data['group'] as Map<String, dynamic>);
  }

  Future<void> addMember(String groupId, String email) async {
    await _api.post('${ApiConfig.groupsEndpoint}/$groupId/members', {
      'email': email,
    });
  }

  /// Sends an email invitation with Accept/Reject buttons.
  Future<String> sendEmailInvitation(String groupId, String email) async {
    final data = await _api.post(
        '${ApiConfig.groupsEndpoint}/$groupId/invitations',
        {'email': email});
    return data['message'] as String;
  }

  Future<void> removeMember(String groupId, String userId) async {
    await _api.delete(
        '${ApiConfig.groupsEndpoint}/$groupId/members/$userId');
  }

  Future<String> regenerateCode(String groupId) async {
    final data = await _api.post(
        '${ApiConfig.groupsEndpoint}/$groupId/regenerate-code', {});
    return data['join_code'] as String;
  }

  Future<GroupModel> updateGroup({
    required String groupId,
    required String name,
    String? course,
    String? description,
  }) async {
    final data = await _api.patch('${ApiConfig.groupsEndpoint}/$groupId', {
      'name':        name,
      'course':      course,
      'description': description,
    });
    return GroupModel.fromJson(data['group'] as Map<String, dynamic>);
  }

  Future<GroupModel> joinGroup(String code) async {
    final data = await _api.post('${ApiConfig.groupsEndpoint}/join', {
      'code': code.toUpperCase(),
    });
    return GroupModel.fromJson(data['group'] as Map<String, dynamic>);
  }

  Future<void> deleteGroup(String groupId) async {
    await _api.delete('${ApiConfig.groupsEndpoint}/$groupId');
  }

  Future<List<InvitationModel>> fetchInvitations() async {
    final data = await _api.get('/invitations');
    return (data['invitations'] as List)
        .map((e) => InvitationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GroupModel> acceptInvitation(String invitationId) async {
    final data = await _api.post('/invitations/$invitationId/accept', {});
    return GroupModel.fromJson(data['group'] as Map<String, dynamic>);
  }

  Future<void> declineInvitation(String invitationId) async {
    await _api.post('/invitations/$invitationId/decline', {});
  }
}
