import 'dart:async'; // Importing dart:async for asynchronous operations
import 'package:flutter/material.dart'; // Importing Flutter material library
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/service_error_handler.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/points_services.dart';
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

      final int pointEarned = response['points_earned'] as int;
      if (context.mounted) {
        if (pointEarned > 0) {
          PointsServices.showPointsEarnedDialog(
            context,
            'Opening the App',
            points: pointEarned,
          );
        }
      }

      await _sessionController.updateUser(
        UserModel.fromJson(
          response['user'] as Map<String, dynamic>,
        ),
      );

      //check if profile is complete, remove "Finish Profile" banner
      checkProfileCompletionStatus();
      //END: check if profile is complete

      await SessionController().saveUser(
        UserModel.fromJson(
          response['user'] as Map<String, dynamic>,
        ),
      );

      debugPrint('[$tag] ✅ Profile fetched');
    } catch (e) {
      if (context.mounted) {
        await ErrorHandler.handle(context, e, serviceName: tag);
      }
      // rethrow;
    }
  }

  Future<void> fetchPartner(
    BuildContext context,
  ) async {
    debugPrint('NOW FETCH PARTNER CALLED');
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
    await _sessionController.loadToken();
    await _sessionController.loadUser();
    debugPrint('[$tag] Auth Token: $authToken');
    if (authToken.isNotEmpty && _sessionController.user != null) {
      debugPrint('[$tag] Active session found, fetching profile');
      if (context.mounted) await fetchPartner(context);
      try {
        if (context.mounted) LoginService.goToHome(context);
        return;
      } catch (_) {
        debugPrint('[$tag] Error fetching profile, clearing session');
        await _sessionController.clearSession();
        if (context.mounted) await goToWelcome(context);
      }
    } else {
      debugPrint(
        '[$tag] No active session found, redirecting to welcome screen',
      );

      if (context.mounted) await goToWelcome(context);
    }
  }

  Future<void> goToWelcome(BuildContext context) async {
    await Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.welcome,
      (route) => false,
    );
  }

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

  int checkProfileCompletionStatus() {
    //Main Questions not answered: return 0;
    //Incomplete: return 1;
    //Complete: return 2;

    // check if user has completed his profile, otherwise, navigate to onboarding
    final UserModel user = SessionController().user!;
    if (user.email.isNotEmpty) {
      //
      //original
      //
      // if (user.loveLanguage == null || user.loveLanguage == '') {
      //   if (mounted) {
      //     SignupService.goToOnBoarding(context);
      //   }
      // }
      //END: original

      // //new
      // final fields = [
      //   user.loveLanguage,
      //   user.apologyLanguage,
      //   user.communicationStyle,
      //   user.relationshipStatus,
      //   user.anniversaryDate, //type: DateTime
      //   user.dateOfBirth, //type: DateTime
      //   user.interests, //type: List
      //   user.giftPreferences, //type: List
      //   user.location,
      // ];
      // // Convert to bools for easier checking
      // final bool allEmptyOrNull =
      //     fields.every((f) => f == null || (f is String && f.trim().isEmpty));
      // final bool anyEmptyOrNull =
      //     fields.any((f) => f == null || (f is String && f.trim().isEmpty));

      // debugPrint("💁🏻 $fields");
      // debugPrint('ALL : $allEmptyOrNull');
      // debugPrint('ANY : $anyEmptyOrNull');

      // if (allEmptyOrNull) {
      //   if (mounted) {
      //     SignupService.goToOnBoarding(context);
      //   }
      // } else if (anyEmptyOrNull) {
      //   //isProfileIncomplete = true;
      //   SessionController().setProfileCompletionStatus(status: true);
      //   debugPrint('Profile Incomplete');
      // }
      // //END: new

      //latest
      final questions = [
        user.loveLanguage,
        user.apologyLanguage,
        user.communicationStyle,
        user.relationshipStatus,
      ];
      final fields = [
        user.anniversaryDate, //type: DateTime
        user.dateOfBirth, //type: DateTime
        user.interests, //type: List
        user.giftPreferences, //type: List
      ];
      // Convert to bools for easier checking

      // final bool allEmptyOrNull = fields.every(_isEmptyValue);
      final bool anyQuestionEmptyOrNull = questions.any(_isEmptyValue);
      final bool anyFieldEmptyOrNull = fields.any(_isEmptyValue);
      debugPrint("💁🏻 $fields");
      debugPrint('QUESTIONS? : $anyQuestionEmptyOrNull');
      debugPrint('FIELDS? : $anyFieldEmptyOrNull');

      if (anyQuestionEmptyOrNull) {
        return 0;
      } else if (anyFieldEmptyOrNull) {
        debugPrint('Profile Incomplete');
        SessionController().setProfileCompletionStatus(status: true);
        return 1;
      }
      SessionController().setProfileCompletionStatus(status: false);
      debugPrint('Profile Complete');
      return 2;
      //latest
    }
    return 2;
  }

  bool _isEmptyValue(dynamic value) {
    if (value == null) return true;

    if (value is String) {
      return value.trim().isEmpty;
    }

    if (value is List) {
      return value.isEmpty;
    }

    if (value is DateTime) {
      // Treat a date value as NOT empty (unless you want to check something else)
      return false;
    }

    // For any other type, consider it "not empty"
    return false;
  }
}
