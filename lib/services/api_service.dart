import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final http.Client _client;
  String? _authToken;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  void setAuthToken(String token) => _authToken = token;
  void clearAuthToken() => _authToken = null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await _client
        .get(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: _headers)
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(
      String endpoint, Map<String, dynamic> body) async {
    final response = await _client
        .patch(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> body) async {
    final response = await _client
        .put(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(ApiConfig.timeout);
    return _handleResponse(response);
  }

  Future<void> delete(String endpoint) async {
    final response = await _client
        .delete(Uri.parse('${ApiConfig.baseUrl}$endpoint'), headers: _headers)
        .timeout(ApiConfig.timeout);
    _handleResponse(response);
  }

  Future<Map<String, dynamic>> multipartPost(
      String endpoint, File file, String fieldName) async {
    final uri     = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', uri);

    if (_authToken != null) {
      request.headers['Authorization'] = 'Bearer $_authToken';
    }

    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    final streamed = await request.send().timeout(ApiConfig.timeout);
    final response = await http.Response.fromStream(streamed);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) return body;

    // For Laravel 422 validation errors, surface the first field-level message
    // since it's more specific than the generic "message" summary.
    String message = body['message'] as String? ?? 'Something went wrong';
    if (response.statusCode == 422) {
      final errors = body['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          message = first.first as String;
        }
      }
    }

    throw ApiException(response.statusCode, message);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  const ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
