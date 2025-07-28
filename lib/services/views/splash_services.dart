import 'dart:async'; // Importing dart:async for asynchronous operations
import 'package:flutter/material.dart'; // Importing Flutter material library
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/app/utils/service_error_handler.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/storage/local_storage.dart';
import 'package:sage/services/views/login_service.dart';

class SplashServices {
  final SessionController _session = SessionController();
  final LocalStorage _localStorage = LocalStorage();
  final AuthRepository _userAuth = AuthRepository();
  final String tag = 'SplashServices';

  Future<void> fetchProfile(BuildContext context) async {
    try {
      await SessionController().loadToken();
      final response = await _userAuth.getCurrentUserProfile();
      // save user to session
      SessionController().user = UserModel.fromJson(
        response['user'] as Map<String, dynamic>,
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
    final String partnerCode = _session.user?.partnerCode ?? '';
    try {
      final response = await _userAuth.getPartner(partnerCode);
      SessionController().partner = UserModel.fromJson(
        response['partner'] as Map<String, dynamic>,
      );
      debugPrint('[$tag] ✅ Partner Fetched');
    } catch (e) {
      // if (context.mounted) {
      //   context.flushBarErrorMessage(
      //     message: 'No Partner Added yet',
      //   );
      // }
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
        await _session.clearSession();
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
}
