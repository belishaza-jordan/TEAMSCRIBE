import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/fcm_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FcmService  _fcmService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService, this._fcmService);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated  => _currentUser != null;
  bool get isEmailVerified  => _currentUser?.emailVerified ?? false;

  Future<bool> restoreSession() async {
    final user = await _authService.restoreSession();
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      _fcmService.init(); // register token after session restored
      return true;
    }
    return false;
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _authService.login(email, password);
      _error = null;
      _fcmService.init(); // register token after login
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signup(String name, String email, String password,
      String universityId) async {
    _setLoading(true);
    try {
      _currentUser =
          await _authService.signup(name, email, password, universityId);
      _error = null;
      _fcmService.init(); // register token after signup
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(String name, String university) async {
    _setLoading(true);
    try {
      _currentUser = await _authService.updateProfile(name, university);
      _error = null;
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadAvatar(File file) async {
    _setLoading(true);
    try {
      _currentUser = await _authService.uploadAvatar(file);
      _error = null;
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyEmail(String email, String otp) async {
    _setLoading(true);
    try {
      final user = await _authService.verifyEmail(email, otp);
      _currentUser = user;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resendVerificationEmail() async {
    try {
      await _authService.resendVerificationEmail();
      _error = null;
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> forgotPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.forgotPassword(email);
      _error = null;
    } catch (e) {
      _error = _extractMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> verifyOtp(String email, String otp) async {
    _setLoading(true);
    try {
      final token = await _authService.verifyOtp(email, otp);
      _error = null;
      return token;
    } catch (e) {
      _error = _extractMessage(e);
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(
      String email, String password, String resetToken) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email, password, resetToken);
      _error = null;
      return true;
    } catch (e) {
      _error = _extractMessage(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _fcmService.clearToken(); // deregister token before clearing session
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _extractMessage(Object e) {
    final s = e.toString();
    // Strip the "ApiException(4xx): " prefix for clean UI display
    final colon = s.indexOf(': ');
    return colon != -1 ? s.substring(colon + 2) : s;
  }
}
