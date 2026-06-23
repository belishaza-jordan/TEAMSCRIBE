import 'package:flutter/foundation.dart';
import '../models/section_model.dart';
import '../services/section_service.dart';

class SectionProvider extends ChangeNotifier {
  final SectionService _sectionService;

  List<SectionModel> _sections = [];
  bool _isLoading = false;
  String? _error;

  SectionProvider(this._sectionService);

  List<SectionModel> get sections => _sections;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSections(String groupId) async {
    _setLoading(true);
    try {
      _sections = await _sectionService.fetchSections(groupId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createSection(String groupId, String title, String assignedTo,
      DateTime? dueDate) async {
    _setLoading(true);
    try {
      final section = await _sectionService.createSection(
          groupId, title, assignedTo, dueDate);
      _sections = [..._sections, section];
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateStatus(
      String groupId, String sectionId, SectionStatus status) async {
    try {
      final updated =
          await _sectionService.updateStatus(groupId, sectionId, status);
      _sections = _sections
          .map((s) => s.id == sectionId ? updated : s)
          .toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
