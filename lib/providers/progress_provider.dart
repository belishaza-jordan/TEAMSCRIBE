import 'package:flutter/foundation.dart';
import '../models/activity_model.dart';
import '../services/progress_service.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressService _service;

  List<MemberProgressModel> _members       = [];
  List<ActivityModel>       _activities    = [];
  List<ActivityModel>       _notifications = [];
  bool                      _isLoading     = false;
  String?                   _error;

  ProgressProvider(this._service);

  List<MemberProgressModel> get members       => _members;
  List<ActivityModel>       get activities    => _activities;
  List<ActivityModel>       get notifications => _notifications;
  bool                      get isLoading     => _isLoading;
  String?                   get error         => _error;

  Future<void> loadAll(String groupId) async {
    _setLoading(true);
    try {
      final results = await Future.wait([
        _service.fetchMemberProgress(groupId),
        _service.fetchActivities(groupId),
      ]);
      _members    = results[0] as List<MemberProgressModel>;
      _activities = results[1] as List<ActivityModel>;
      _error      = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchNotifications() async {
    _setLoading(true);
    try {
      _notifications = await _service.fetchNotifications();
      _error = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshActivities(String groupId) async {
    try {
      _activities = await _service.fetchActivities(groupId);
      notifyListeners();
    } catch (_) {}
  }

  void clear() {
    _members    = [];
    _activities = [];
    notifyListeners();
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
