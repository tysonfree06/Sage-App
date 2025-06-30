import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/services/storage/local_storage.dart';

/// A singleton class for managing user session data across the application.
class SessionController {
  /// Factory constructor to access the singleton instance.
  factory SessionController() => _instance;

  /// Private constructor for creating the singleton instance.
  SessionController._internal();

  /// Singleton instance of [SessionController].
  static final SessionController _instance = SessionController._internal();

  /// Instance of [LocalStorage] for accessing local storage operations.
  final LocalStorage _localStorage = LocalStorage();

  /// Indicates whether the user is currently logged in.
  bool isLogin = false;

  /// Current user data, null if no user is logged in.
  UserModel? user;

  /// Saves user data to local storage and updates session state.
  ///
  /// [user] The [UserModel] to be saved.
  /// Returns a [Future] that completes when the data is saved.
  Future<void> saveUserInPreference(UserModel user) async {
    try {
      await _localStorage.setValue('token', jsonEncode(user.toJson()));
      await _localStorage.setValue('isLogin', 'true');
      this.user = user;
      isLogin = true;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      rethrow;
    }
  }

  /// Retrieves user data from local storage and updates session state.
  ///
  /// Returns a [Future] that completes when the data is retrieved.
  Future<void> getUserFromPreference() async {
    try {
      final String? userData =
          await _localStorage.readValue('token') as String?;
      final String? isLoginData =
          await _localStorage.readValue('isLogin') as String?;

      if (userData != null && userData.isNotEmpty) {
        final userJson = jsonDecode(userData) as Map<String, dynamic>;
        user = UserModel.fromJson(userJson);
      } else {
        user = null;
      }

      isLogin = isLoginData == 'true';
    } catch (e) {
      debugPrint('Error retrieving user data: $e');
      user = null;
      isLogin = false;
    }
  }

  /// Clears user session data from local storage and resets session state.
  ///
  /// Returns a [Future] that completes when the data is cleared.
  Future<void> clearSession() async {
    try {
      await _localStorage.clearValue('token');
      await _localStorage.clearValue('isLogin');
      user = null;
      isLogin = false;
    } catch (e) {
      debugPrint('Error clearing session: $e');
      rethrow;
    }
  }
}
