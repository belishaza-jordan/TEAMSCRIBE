import '../config/api_config.dart';
import '../models/section_model.dart';
import 'api_service.dart';

class SectionService {
  final ApiService _api;

  SectionService(this._api);

  Future<List<SectionModel>> fetchSections(String groupId) async {
    final data = await _api
        .get('${ApiConfig.groupsEndpoint}/$groupId/sections');
    return (data['sections'] as List)
        .map((e) => SectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SectionModel> createSection({
    required String groupId,
    required String title,
    String?  assignedTo,
    String?  dueDate,
  }) async {
    final data = await _api.post(
        '${ApiConfig.groupsEndpoint}/$groupId/sections', {
      'title': title,
      'assigned_to': assignedTo,
      'due_date': dueDate,
    });
    return SectionModel.fromJson(data['section'] as Map<String, dynamic>);
  }

  Future<SectionModel> updateSection({
    required String groupId,
    required String sectionId,
    String? status,
    int?    progress,
    String? assignedTo,
  }) async {
    final data = await _api.patch(
        '${ApiConfig.groupsEndpoint}/$groupId/sections/$sectionId', {
      'status':      status,
      'progress':    progress,
      'assigned_to': assignedTo,
    });
    return SectionModel.fromJson(data['section'] as Map<String, dynamic>);
  }

  Future<void> deleteSection(String groupId, String sectionId) async {
    await _api.delete(
        '${ApiConfig.groupsEndpoint}/$groupId/sections/$sectionId');
  }
}
