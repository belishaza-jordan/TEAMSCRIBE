import '../config/api_config.dart';
import '../models/section_model.dart';
import 'api_service.dart';

class SectionService {
  final ApiService _api;

  SectionService(this._api);

  Future<List<SectionModel>> fetchSections(String groupId) async {
    final data =
        await _api.get('${ApiConfig.groupsEndpoint}/$groupId${ApiConfig.sectionsEndpoint}');
    return (data['sections'] as List)
        .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SectionModel> createSection(
      String groupId, String title, String assignedTo, DateTime? dueDate) async {
    final data = await _api.post(
        '${ApiConfig.groupsEndpoint}/$groupId${ApiConfig.sectionsEndpoint}', {
      'title': title,
      'assigned_to': assignedTo,
      if (dueDate != null) 'due_date': dueDate.toIso8601String(),
    });
    return SectionModel.fromJson(data['section'] as Map<String, dynamic>);
  }

  Future<SectionModel> updateStatus(
      String groupId, String sectionId, SectionStatus status) async {
    final data = await _api.put(
        '${ApiConfig.groupsEndpoint}/$groupId${ApiConfig.sectionsEndpoint}/$sectionId',
        {'status': status.name});
    return SectionModel.fromJson(data['section'] as Map<String, dynamic>);
  }
}
