import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/upload_model.dart';
import 'api_service.dart';

class UploadService {
  final ApiService _api;

  UploadService(this._api);

  Future<UploadModel> uploadFile(String sectionId, File file) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.uploadsEndpoint}'),
    );
    request.fields['section_id'] = sectionId;
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await request.send().timeout(ApiConfig.timeout);
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode != 201) {
      throw Exception('Upload failed: ${response.statusCode}');
    }
    return UploadModel.fromJson({'id': '', 'section_id': sectionId, 'uploaded_by': '', 'file_url': '', 'file_name': file.path.split('/').last, 'file_size_bytes': file.lengthSync(), 'uploaded_at': DateTime.now().toIso8601String()});
  }

  Future<List<UploadModel>> fetchUploads(String sectionId) async {
    final data =
        await _api.get('${ApiConfig.uploadsEndpoint}?section_id=$sectionId');
    return (data['uploads'] as List)
        .map((e) => UploadModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
