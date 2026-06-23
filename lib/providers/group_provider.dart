import 'package:flutter/foundation.dart';
import '../models/group_model.dart';
import '../services/group_service.dart';

class GroupProvider extends ChangeNotifier {
  final GroupService _groupService;

  List<GroupModel> _groups = [];
  GroupModel? _selectedGroup;
  bool _isLoading = false;
  String? _error;

  GroupProvider(this._groupService);

  List<GroupModel> get groups => _groups;
  GroupModel? get selectedGroup => _selectedGroup;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchGroups() async {
    _setLoading(true);
    try {
      _groups = await _groupService.fetchMyGroups();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> selectGroup(String groupId) async {
    _setLoading(true);
    try {
      _selectedGroup = await _groupService.fetchGroup(groupId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createGroup(String name, String description) async {
    _setLoading(true);
    try {
      final group = await _groupService.createGroup(name, description);
      _groups = [..._groups, group];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
