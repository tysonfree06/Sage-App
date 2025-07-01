import 'dart:developer';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/services/storage/local_storage.dart';

class SessionController {
  factory SessionController() => _instance;

  SessionController._internal();

  static final SessionController _instance = SessionController._internal();
  final LocalStorage _localStorage = LocalStorage();

  String? _token;
  UserModel? user;

  String? get token => _token;

  bool get isLoggedIn => _token != null;

  /// Save only the token in local storage
  Future<void> saveToken(String token) async {
    _token = token;
    await _localStorage.setValue('auth_token', token);
    log('Token saved: $token');
  }

  /// Retrieve token from local storage on app start
  Future<void> loadToken() async {
    _token = await _localStorage.readValue('auth_token');
    if (_token != null) {
      log('Token loaded: $_token'); // Debug log: Token loaded
    } else {
      log('No token found in local storage');
    }
  }

  /// Clear token on logout
  Future<void> clearSession() async {
    _token = null;
    user = null;
    await _localStorage.clearValue('auth_token');
    log('Session cleared: Token and user data removed');
  }
}
