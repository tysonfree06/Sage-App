import 'package:flutter/cupertino.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/repository/auth/auth_repo.dart';
import 'package:sage/view/auth/widget/account_verification_sheet.dart';

class SignupService {
  final AuthRepository _authRepository = AuthRepository();
  static void showVerificationSheet(
    BuildContext context, {
    String email = 'abc@example.com',
  }) {
    MyBottomSheet.show<void>(
      context,
      child: AccountVerificationSheet(
        email: email,
        onPressed: () {
          Navigator.of(context).pop();
          goToOnBoarding(context);
        },
      ),
    );
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.login,
      (route) => false,
    );
  }

  static void goToOnBoarding(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.onBoarding,
      (route) => false,
    );
  }

  Future<void> signup(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? inviteCode,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        if (inviteCode?.isNotEmpty ?? false) 'inviteCode': inviteCode,
      };

      // final response =
      await _authRepository.signup(data);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Signup successful!');
        showVerificationSheet(
          context,
        ); // or goToHome(context) if already verified
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
