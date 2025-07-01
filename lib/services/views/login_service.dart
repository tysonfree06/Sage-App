import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/repository/auth/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';

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
    try {
      final data = {
        'email': email,
        'password': password,
      };
      // Login the user and retrieve both the user data and token
      final response = await _authRepository.login(data);

      final String token = response['token'] as String;
      final Map<String, dynamic> userData =
          response['user'] as Map<String, dynamic>;

      // Save the token and user in the session
      await SessionController().saveToken(token);
      SessionController().user = UserModel.fromJson(userData);

      // Show success message
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Login Success');
      }

      // Navigate to the home screen
      if (context.mounted) goToHome(context);
    } catch (e) {
      // Handle login failure
      if (context.mounted) {
        context.flushBarErrorMessage(message: 'Login Failed: $e');
      }
      // rethrow;
    }
  }
}
