import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/splash_services.dart';

class LoginService {
  final AuthRepository _authRepository = AuthRepository();

  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.forgotPassword,
    );
  }

  static void goToHome(BuildContext context) {
    context.read<NavigationProvider>().setIndex(0);
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.navigation,
      (route) => false,
    );
    // Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   RoutesName.onBoarding,
    //   (route) => false,
    // );
  }

  static void goToSignup(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.signup,
      (route) => false,
    );
  }

  Future<void> login(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };
    if (context.mounted) await SplashServices().fetchPartner(context);
    try {
      final response = await _authRepository.login(data);
      final String token = response['token'] as String;
      final Map<String, dynamic> userData =
          response['user'] as Map<String, dynamic>;
      // Save session data
      //save token
      await SessionController().saveToken(token);
      debugPrint('Token saved: ${SessionController().token}');

      //save user
      // SessionController().user = UserModel.fromJson(
      //   userData,
      // );
      await SessionController().updateUser(
        UserModel.fromJson(
          userData,
        ),
      );

      //save user to session #muttas
      await SessionController().saveUser(
        UserModel.fromJson(
          userData,
        ),
      );

      debugPrint('User saved: ${SessionController().user}');

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Login successful');
        goToHome(context);
      }

      debugPrint('[LoginService] ✅ Login success for ${userData['email']}');
    } catch (e, stackTrace) {
      // Developer logging
      if (e is AppException) {
        debugPrint('[LoginService] ❌ Login failed: ${e.debugMessage}');
      } else {
        debugPrint('[LoginService] ❌ Unexpected error: $e');

        // Print first 15 lines of the stack trace
        final lines = stackTrace.toString().split('\n');
        final limitedStack = lines.take(15).join('\n');
        debugPrint('[LoginService] 🔍 StackTrace:\n$limitedStack');
      }

      // Show user-friendly error
      if (context.mounted) {
        final errorMessage = (e is AppException)
            ? e.userMessage
            : 'Something went wrong. Please try again.';
        context.flushBarErrorMessage(message: errorMessage);
      }
    }
  }
}
