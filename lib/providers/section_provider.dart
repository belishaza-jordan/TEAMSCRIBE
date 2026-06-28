import 'package:flutter/foundation.dart';
import '../models/section_model.dart';
import '../services/section_service.dart';

class SectionProvider extends ChangeNotifier {
  final SectionService _sectionService;

  List<SectionModel> _sections  = [];
  bool               _isLoading = false;
  String?            _error;

  SectionProvider(this._sectionService);

  List<SectionModel> get sections  => _sections;
  bool               get isLoading => _isLoading;
  String?            get error     => _error;

  // Overall group progress: average of all section progress values
  int get groupProgress {
    if (_sections.isEmpty) return 0;
    final total = _sections.fold<int>(0, (sum, s) => sum + s.progress);
    return (total / _sections.length).round();
  }

  int get doneCount       => _sections.where((s) => s.status == 'done').length;
  int get inProgressCount => _sections.where((s) => s.status == 'in_progress').length;
  int get notStartedCount => _sections.where((s) => s.status == 'not_started').length;

  String _extractMessage(Object e) {
    final s = e.toString();
    final i = s.indexOf(': ');
    return i != -1 ? s.substring(i + 2) : s;
  }

  Future<void> fetchSections(String groupId) async {
    _setLoading(true);
    try {
      _sections = await _sectionService.fetchSections(groupId);
      _error    = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<SectionModel?> createSection({
    required String groupId,
    required String title,
    String?  assignedTo,
    String?  dueDate,
  }) async {
    _setLoading(true);
    try {
      final section = await _sectionService.createSection(
        groupId:    groupId,
        title:      title,
        assignedTo: assignedTo,
        dueDate:    dueDate,
      );
      _sections = [..._sections, section];
      _error    = null;
      return section;
    } catch (e) {
      _error = _extractMessage(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateSection({
    required String groupId,
    required String sectionId,
    String? status,
    int?    progress,
  }) async {
    // Optimistic update
    _sections = _sections.map((s) {
      if (s.id != sectionId) return s;
      return s.copyWith(status: status, progress: progress);
    }).toList();
    notifyListeners();

    try {
      final updated = await _sectionService.updateSection(
        groupId:   groupId,
        sectionId: sectionId,
        status:    status,
        progress:  progress,
      );
      _sections = _sections
          .map((s) => s.id == sectionId ? updated : s)
          .toList();
      notifyListeners();
    } catch (e) {
      _error = _extractMessage(e);
      // Reload from server to revert optimistic update
      await fetchSections(groupId);
    }
  }

  void clearSections() {
    _sections = [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
