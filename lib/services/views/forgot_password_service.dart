import 'package:flutter/cupertino.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/repository/auth_repo.dart';

class ForgotPasswordService {
  final AuthRepository _authRepository = AuthRepository();

  static void goToResetPassword({
    required BuildContext context,
    required String email,
    required String otp,
  }) {
    Navigator.pushNamed(
      context,
      RoutesName.resetPassword,
      arguments: {
        'email': email,
        'otp': otp,
      },
    );
  }

  Future<bool> sendOtp({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
      };
      await _authRepository.forgotPassword(data);
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'OTP sent to your email...');
      }
      return true;
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SignupService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SignupService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
    return false;
  }

  Future<void> verifyOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
        'otp': otp,
      };
      await _authRepository.verifyOtp(data);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Account Verified...');
        goToResetPassword(context: context, email: email, otp: otp);
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SignupService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SignupService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }
}
