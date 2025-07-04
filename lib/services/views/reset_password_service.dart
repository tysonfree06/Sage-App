import 'package:flutter/cupertino.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/repository/auth/auth_repo.dart';

class ResetPasswordService {
  final AuthRepository _authRepository = AuthRepository();

  static void goToLogin(
    BuildContext context,
  ) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.login,
      (route) => false,
    );
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'otp': otp,
        'newPassword': newPassword,
      };
      await _authRepository.verifyOtp(data);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Password Updated...');
        goToLogin(context);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[ResetPasswordService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[ResetPasswordService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }
}
