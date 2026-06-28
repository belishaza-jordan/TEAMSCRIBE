import 'dart:io';
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
    final data = await _api.post('${ApiConfig.authEndpoint}/register', {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'university': universityId,
    });
    final token = data['token'] as String;
    await _storage.saveToken(token);
    _api.setAuthToken(token);
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> forgotPassword(String email) async {
    await _api.post('${ApiConfig.authEndpoint}/forgot-password', {
      'email': email,
    });
  }

  Future<String> verifyOtp(String email, String otp) async {
    final data = await _api.post('${ApiConfig.authEndpoint}/verify-otp', {
      'email': email,
      'otp': otp,
    });
    return data['reset_token'] as String;
  }

  Future<void> resetPassword(
      String email, String password, String resetToken) async {
    await _api.post('${ApiConfig.authEndpoint}/reset-password', {
      'email': email,
      'password': password,
      'password_confirmation': password,
      'reset_token': resetToken,
    });
  }

  Future<void> logout() async {
    try {
      await _api.post('${ApiConfig.authEndpoint}/logout', {});
    } finally {
      await _storage.deleteToken();
      _api.clearAuthToken();
    }
  }

  Future<UserModel> verifyEmail(String email, String otp) async {
    final data = await _api.post('${ApiConfig.authEndpoint}/email/verify', {
      'email': email,
      'otp':   otp,
    });
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    return user;
  }

  Future<void> resendVerificationEmail() async {
    await _api.post('${ApiConfig.authEndpoint}/email/resend', {});
  }

  Future<UserModel> updateProfile(String name, String university) async {
    final data = await _api.patch(ApiConfig.profileEndpoint, {
      'name': name,
      'university': university,
    });
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<UserModel> uploadAvatar(File file) async {
    final data = await _api.multipartPost(
        '${ApiConfig.profileEndpoint}/avatar', file, 'avatar');
    return UserModel.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> registerDeviceToken(String token) async {
    await _api.post(ApiConfig.deviceTokenEndpoint, {
      'token': token,
      'platform': 'android',
    });
  }

  Future<void> removeDeviceToken(String token) async {
    await _api.delete('${ApiConfig.deviceTokenEndpoint}?token=$token');
  }

  /// Checks local storage for a saved token, then verifies it is still valid
  /// by calling GET /auth/me. Returns the user if valid, null otherwise.
  Future<UserModel?> restoreSession() async {
    final token = await _storage.getToken();
    if (token == null) return null;

    _api.setAuthToken(token);

    try {
      final data = await _api.get('${ApiConfig.authEndpoint}/me');
      return UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } catch (_) {
      // Token is expired or invalid — wipe it so we go to login
      await _storage.deleteToken();
      _api.clearAuthToken();
      return null;
    }
  }
}
