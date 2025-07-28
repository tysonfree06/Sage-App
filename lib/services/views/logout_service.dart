import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/reset_password_service.dart';

class LogoutService {
  // static const String tag = 'AuthService';
  static const String tag = 'LogoutService';
  final SessionController _session = SessionController();
  Future<void> logout(BuildContext context) async {
    await _session.clearSession();
    if (context.mounted) {
      ResetPasswordService.goToLogin(context);
      context.flushBarSuccessMessage(message: 'Logged out successfully');
    }
    debugPrint('[$tag] Logged out');
  }

  static void goToWelcome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.welcome,
      (route) => false,
    );
  }
}
