import 'dart:async'; // Importing dart:async for asynchronous operations
import 'package:flutter/material.dart'; // Importing Flutter material library
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/service_error_handler.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/storage/local_storage.dart';
import 'package:sage/services/views/login_service.dart';

class SplashServices {
  final LocalStorage _localStorage = LocalStorage();
  final AuthRepository _userAuth = AuthRepository();
  final _userRepository = UserRepository();
  final String tag = 'SplashServices';
  final SessionController _sessionController = SessionController();

  Future<void> fetchProfile(BuildContext context) async {
    try {
      await _sessionController.loadToken();
      final response = await _userAuth.getCurrentUserProfile();
      // save user to session
      // SessionController().user = UserModel.fromJson(
      //   response['user'] as Map<String, dynamic>,
      // );
      await _sessionController.updateUser(
        UserModel.fromJson(
          response['user'] as Map<String, dynamic>,
        ),
      );

      debugPrint('[$tag] ✅ Profile fetched');
    } catch (e) {
      if (context.mounted) ErrorHandler.handle(context, e, serviceName: tag);
      rethrow;
    }
  }

  Future<void> fetchPartner(
    BuildContext context,
  ) async {
    final dynamic partnerCode = _sessionController.user?.partnerCode ?? '';
    if (partnerCode == '') {
      debugPrint('[$tag] No partner code found, skipping partner fetch');
      return;
    }
    try {
      final response = await _userAuth.getPartner(partnerCode);
      _sessionController.partner = UserModel.fromJson(
        response['partner'] as Map<String, dynamic>,
      );
      debugPrint('[$tag] ✅ Partner Fetched');
    } catch (e) {
      debugPrint('[$tag] ❌ Error fetching partner: $e');
    }
  }

  Future<void> checkAuthentication(BuildContext context) async {
    final authToken = await _localStorage.readValue('auth_token') ?? '';
    debugPrint('[$tag] Auth Token: $authToken');
    // if (_session.isLoggedIn) {
    if (authToken.isNotEmpty) {
      debugPrint('[$tag] Active session found, fetching profile');
      if (context.mounted) await fetchPartner(context);
      try {
        if (context.mounted) await fetchProfile(context);
        if (context.mounted) LoginService.goToHome(context);
      } catch (_) {
        debugPrint('[$tag] Error fetching profile, clearing session');
        await _sessionController.clearSession();
        if (context.mounted) await goToWelcome(context);
      }
    } else {
      debugPrint(
        '[$tag] No active session found, redirecting to welcome screen',
      );
      Timer(const Duration(seconds: 1), () {
        if (context.mounted) goToWelcome(context);
      });
    }
  }

// Future<void> checkAuthentication(BuildContext context) async {
  //   //TODO: Login using token and on failure go to welcome screen (on token) / login screen (token not working)
  // }

  Future<void> goToWelcome(BuildContext context) async {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.welcome,
        (route) => false,
      ),
    );
  }

  // Future<Map<String, dynamic>> loadRelationshipSuggestion() async {
  //   try {
  //     final response = await _userRepository.fetchRelationshipSuggestion();
  //     debugPrint('[$tag] ✅ Relationship Suggestion Fetched');
  //     return response;
  //   } catch (e) {
  //     debugPrint('[$tag] ❌ Error fetching partner: $e');
  //     return {};
  //   }
  // }

  Future<Map<String, dynamic>> loadRelationshipSuggestion() async {
    try {
      final response = await _userRepository.fetchRelationshipSuggestion();
      debugPrint('[$tag] ✅ Relationship Suggestion Fetched');
      return response;
    } catch (e) {
      debugPrint('[$tag] ❌ Error fetching partner: $e');
      return {};
    }
  }
}
