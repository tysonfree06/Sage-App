import 'package:flutter/cupertino.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/view/auth/widget/account_verification_sheet.dart';

class SignupService {
  final AuthRepository _authRepository = AuthRepository();
  final SessionController _sessionController = SessionController();
  static void showVerificationSheet(
    BuildContext context, {
    required String email,
  }) {
    MyBottomSheet.show<void>(
      context,
      isDismissible: false,
      child: AccountVerificationSheet(
        email: email,
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

  Future<void> sendOtp({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': email,
      };
      await _authRepository.sendOtp(data);
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'OTP sent to your email...');
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
      final response = await _authRepository.verifyOtp(data);
      final String token = response['token'] as String;
      final Map<String, dynamic> userData =
          response['user'] as Map<String, dynamic>;

      //save token in session controller
      await _sessionController.saveToken(token);
      //save user
      //save user to session #muttas
      await SessionController().saveUser(
        UserModel.fromJson(
          userData,
        ),
      );
      await SessionController().updateUser(
        UserModel.fromJson(
          userData,
        ),
      );
      // _sessionController.user.name = verifyResponse['name'] as String;

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Account Verified...');
        goToOnBoarding(context);
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

  Future<void> signup(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    String? inviteCode,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'password': password,
        if (inviteCode?.isNotEmpty ?? false) 'invitationCode': inviteCode,
      };

      // final response =
      await _authRepository.signup(data);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Signup successful!');
        showVerificationSheet(
          context,
          email: email,
        );
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

  //date validation
  bool isAtLeast18YearsOld(DateTime? dateOfBirth) {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
    if (dateOfBirth == null) return false;
    if (dateOfBirth.isBefore(eighteenYearsAgo)) {
      debugPrint('Date $dateOfBirth is at least 18 years in the past.');
      return true;
    } else {
      debugPrint('Date $dateOfBirth is less than 18 years ago.');
      return false;
    }
  }

  bool isAnniversaryDateLessThanDOB(
    DateTime dateOfBirth,
    DateTime? anniversaryDate,
  ) {
    if (anniversaryDate == null) return false;
    if (dateOfBirth.isBefore(anniversaryDate)) {
      debugPrint('Date of Birth is Before Anniversary');
      return true;
    } else {
      debugPrint('Date of Birth is After Anniversary');
      return false;
    }
  }
}
