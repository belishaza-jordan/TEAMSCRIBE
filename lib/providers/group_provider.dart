import 'package:flutter/foundation.dart';
import '../models/group_model.dart';
import '../models/invitation_model.dart';
import '../services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  final GroupService _groupService;

  List<GroupModel>      _groups      = [];
  GroupModel?           _activeGroup;
  List<InvitationModel> _invitations = [];
  bool                  _isLoading   = false;
  String?               _error;

  GroupProvider(this._groupService);

  List<GroupModel>      get groups      => _groups;
  GroupModel?           get activeGroup => _activeGroup;
  List<InvitationModel> get invitations => _invitations;
  bool                  get isLoading   => _isLoading;
  String?               get error       => _error;
  GroupService          get service     => _groupService;

  String _extractMessage(Object e) {
    final s = e.toString();
    final i = s.indexOf(': ');
    return i != -1 ? s.substring(i + 2) : s;
  }

  Future<void> fetchGroups() async {
    _setLoading(true);
    try {
      _groups = await _groupService.fetchMyGroups();
      _error  = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadGroup(String groupId) async {
    _setLoading(true);
    try {
      _activeGroup = await _groupService.fetchGroup(groupId);
      _error = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<GroupModel?> createGroup({
    required String name,
    String? course,
    String? description,
  }) async {
    _setLoading(true);
    try {
      final group = await _groupService.createGroup(
        name:        name,
        course:      course,
        description: description,
      );
      _groups = [group, ..._groups];
      _error  = null;
      return group;
    } catch (e) {
      _error = _extractMessage(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addMember(String groupId, String email) async {
    try {
      await _groupService.addMember(groupId, email);
      await loadGroup(groupId); // refresh member list
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<String?> regenerateCode(String groupId) async {
    try {
      final newCode = await _groupService.regenerateCode(groupId);
      // Update the cached group with the new code
      _groups = _groups.map((g) {
        if (g.id != groupId) return g;
        return GroupModel(
          id:            g.id,
          name:          g.name,
          course:        g.course,
          description:   g.description,
          createdBy:     g.createdBy,
          joinCode:      newCode,
          memberCount:   g.memberCount,
          sectionsTotal: g.sectionsTotal,
          sectionsDone:  g.sectionsDone,
          progress:      g.progress,
          members:       g.members,
        );
      }).toList();
      if (_activeGroup?.id == groupId) {
        _activeGroup = _groups.firstWhere((g) => g.id == groupId,
            orElse: () => _activeGroup!);
      }
      notifyListeners();
      _error = null;
      return newCode;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return null;
    }
  }

  Future<GroupModel?> joinGroup(String code) async {
    _setLoading(true);
    try {
      final group = await _groupService.joinGroup(code);
      if (!_groups.any((g) => g.id == group.id)) {
        _groups = [group, ..._groups];
      }
      _error = null;
      return group;
    } catch (e) {
      _error = _extractMessage(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> inviteByEmail(String groupId, String email) async {
    try {
      // Send email invitation with Accept/Reject buttons
      await _groupService.sendEmailInvitation(groupId, email);
      _error = null;
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGroup({
    required String groupId,
    required String name,
    String? course,
    String? description,
  }) async {
    _setLoading(true);
    try {
      final updated = await _groupService.updateGroup(
        groupId:     groupId,
        name:        name,
        course:      course,
        description: description,
      );
      _groups = _groups.map((g) => g.id == groupId ? updated : g).toList();
      if (_activeGroup?.id == groupId) _activeGroup = updated;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteGroup(String groupId) async {
    try {
      await _groupService.deleteGroup(groupId);
      _groups = _groups.where((g) => g.id != groupId).toList();
      if (_activeGroup?.id == groupId) _activeGroup = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeMember(String groupId, String userId) async {
    try {
      await _groupService.removeMember(groupId, userId);
      _groups = _groups.where((g) => g.id != groupId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchInvitations() async {
    try {
      _invitations = await _groupService.fetchInvitations();
      notifyListeners();
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
    }
  }

  Future<GroupModel?> acceptInvitation(String invitationId) async {
    try {
      final group = await _groupService.acceptInvitation(invitationId);
      _invitations = _invitations.where((i) => i.id != invitationId).toList();
      if (!_groups.any((g) => g.id == group.id)) {
        _groups = [group, ..._groups];
      }
      notifyListeners();
      return group;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return null;
    }
  }

  Future<bool> declineInvitation(String invitationId) async {
    try {
      await _groupService.declineInvitation(invitationId);
      _invitations = _invitations.where((i) => i.id != invitationId).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    }
  }

  void clearActiveGroup() {
    _activeGroup = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
