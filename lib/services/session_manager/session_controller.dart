import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/services/storage/local_storage.dart';

class SessionController extends ChangeNotifier {
  factory SessionController() => _instance;

  SessionController._internal();

  static final SessionController _instance = SessionController._internal();
  final LocalStorage _localStorage = LocalStorage();

  String? _token;
  UserModel? _user;
  UserModel? partner;
  bool _isPartnerFetched =
      false; //#muttas remove it when partner is auto loading on splash..

  List<dynamic>? notifications;

  String? get token => _token;
  bool get isPartnerFetched => _isPartnerFetched;

  //make user getter
  UserModel? get user => _user;

  //update user
  Future<void> updateUser(UserModel user) async {
    _user = user;
    notifyListeners();
    debugPrint('USER UPDATED, LISTENERS NOTIFIED');
  }

  bool get isLoggedIn => _token != null;

  /// Save the token in local storage
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

  /// Save the token in local storage
  Future<void> saveUser(UserModel user) async {
    _user = user;
    final userJson = jsonEncode(user.toJson());
    await _localStorage.setValue('user', userJson);
    log('User saved: $user');
  }

  Future<void> loadUser() async {
    final userJson = await _localStorage.readValue('user');
    if (userJson != null) {
      _user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      log('User Loaded: $_user');
    } else {
      log('No user found in local storage');
    }
  }

  Future<void> setPartnerStatus({bool status = false}) async {
    _isPartnerFetched = status;
  }

  /// Clear token on logout
  Future<void> clearSession() async {
    _token = null;
    _user = null;
    partner = null;
    _isPartnerFetched = false;
    notifications = null;
    notifyListeners();
    await _localStorage.clearValue('auth_token');
    log('Session cleared: Token and user data removed');
  }
}
