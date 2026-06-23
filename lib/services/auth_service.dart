import '../config/api_config.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _api;
  final StorageService _storage;

  AuthService(this._api, this._storage);

  Future<UserModel> login(String email, String password) async {
    final data = await _api.post('${ApiConfig.authEndpoint}/login', {
      'email': email,
      'password': password,
    });
    final token = data['token'] as String;
    await _storage.saveToken(token);
    _api.setAuthToken(token);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> signup(String name, String email, String password,
      String universityId) async {
    final data = await _api.post('${ApiConfig.authEndpoint}/signup', {
      'name': name,
      'email': email,
      'password': password,
      'university_id': universityId,
    });
    final token = data['token'] as String;
    await _storage.saveToken(token);
    _api.setAuthToken(token);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    _api.clearAuthToken();
  }

  Future<bool> restoreSession() async {
    final token = await _storage.getToken();
    if (token == null) return false;
    _api.setAuthToken(token);
    return true;
  }
}
