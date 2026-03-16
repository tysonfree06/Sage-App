import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/app/utils/service_error_handler.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/repository/image_upload_repo.dart';
import 'package:sage/repository/settings_repo.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/points_services.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/logout_service.dart';
import 'package:sage/services/views/splash_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingService {
  final UserRepository _userRepo = UserRepository();
  final AuthRepository _authRepository = AuthRepository();
  final ImageUploadRepository _imageUploadRepository = ImageUploadRepository();
  final SessionController _sessionController = SessionController();
  final _listEq = const ListEquality<String>();
  final String tag = 'SettingService';

  // static Future<void> goToEditProfileScreen(
  //   BuildContext context,
  // ) async {
  //   await Navigator.pushNamed(
  //     context,
  //     RoutesName.editProfile,
  //   );
  // }

  static Future<void> goToEditProfileScreen(
    BuildContext context,
  ) async {
    await Navigator.pushNamed(
      context,
      RoutesName.editProfile,
    );
  }

  static Future<void> goToChangePasswordScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.changePassword,
    );
  }

  static Future<void> goToUpdateInterestScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.updateInterests,
    );
  }

  static Future<void> goToUpdatePrefScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.updateGiftPreference,
    );
  }

  static Future<void> goToSubscriptionScreen(
    BuildContext context,
    bool isPremium,
  ) async {
    //if user is premium (subscription is active), go to active subscription screen,
    //otherwise show subscription packages
    await Navigator.pushNamed(
      context,
      isPremium ? RoutesName.activeSubscription : RoutesName.subscription,
      arguments: isPremium
          ? {
              'pointsEarned': 0,
            }
          : false, //show skip button
    );
  }

  static Future<void> goToContactUsScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.contactUs,
    );
  }

  static Future<void> showRemovePartnerDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        image: Assets.images.dialog.bin,
        titleFirst: context.l10n.dialog_remove,
        titleSecond: context.l10n.dialog_partner,
        subtitle: context.l10n.dialog_remove_partner_subtitle,
        confirmLabel: context.l10n.dialog_yes_delete,
        onConfirm: () async {
          await SettingService().removePartner(context: context);
        },
      ),
    );
  }

  static Future<void> showCancelSubscriptionDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        image: Assets.images.dialog.infoYellow,
        titleFirst: context.l10n.dialog_cancel,
        titleSecond: context.l10n.dialog_subscription,
        subtitle: context.l10n.dialog_cancel_sub_subtitle,
        confirmLabel: context.l10n.dialog_yes_cancel,
        onConfirm: () {
          // TODO:
        },
      ),
    );
  }

  static Future<void> showDeleteAccountDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        image: Assets.images.dialog.bin,
        titleFirst: context.l10n.dialog_delete,
        titleSecond: context.l10n.dialog_account,
        subtitle: context.l10n.dialog_delete_account_subtitle,
        confirmLabel: context.l10n.dialog_yes_delete,
        onConfirm: () async {
          await SettingService().deleteAccount(context: context);
        },
      ),
    );
  }

  // Future<String?> uploadProfileImage(File image) async {
  //   try {
  //     final response = await _imageUploadRepository.uploadImage(image.path);
  //     return response;
  //   } catch (e) {
  //     debugPrint('[SettingService] Upload failed: $e');
  //     rethrow;
  //   }
  // }

  Future<String?> uploadImage(
    BuildContext context, {
    required File file,
  }) async {
    try {
      final response = await _imageUploadRepository.uploadImage(file: file);

      // Extract URL from response - adjust key as per your API
      return response['imageUrl'] as String?;
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: tag);
      }
      return null;
    }
  }

  Future<void> updateProfile({
    required BuildContext context,
    String? name,
    String? loveLanguage,
    String? apologyLanguage,
    String? communicationStyle,
    String? budgetLevel,
    String? relationshipStatus,
    DateTime? anniversaryDate,
    DateTime? dateOfBirth,
    String? city,
    String? state,
    String? country,
    String? image,
    List<String>? interests,
    List<String>? giftPreferences,
    String? partnerCode,
    bool popScreen = false,
  }) async {
    final user = _sessionController.user;

    final Map<String, dynamic> data = {
      'userId': _sessionController.user?.id,
      if (name != null && user?.name != name) 'name': name,
      if (loveLanguage != null && user?.loveLanguage != loveLanguage)
        'loveLanguage': loveLanguage,
      if (apologyLanguage != null && user?.apologyLanguage != apologyLanguage)
        'apologyLanguage': apologyLanguage,
      if (communicationStyle != null &&
          user?.communicationStyle != communicationStyle)
        'communicationStyle': communicationStyle,
      if (budgetLevel != null && user?.budgetLevel != budgetLevel)
        'budgetLevel': budgetLevel,
      if (relationshipStatus != null &&
          user?.relationshipStatus != relationshipStatus)
        'relationshipStatus': relationshipStatus,
      if (anniversaryDate != null && user?.anniversaryDate != anniversaryDate)
        'anniversaryDate': anniversaryDate.toIso8601String(),
      if (dateOfBirth != null && user?.dateOfBirth != dateOfBirth)
        'dateOfBirth': dateOfBirth.toIso8601String(),
      if (city != null && user?.location?.city != city) 'city': city,
      if (state != null && user?.location?.state != state) 'state': state,
      if (country != null && user?.location?.country != country)
        'country': country,
      if (image != null && user?.image != image) 'image': image,
      if (interests != null &&
          !_listEq.equals(user?.interests ?? [], interests))
        'interests': interests,
      if (giftPreferences != null &&
          !_listEq.equals(user?.giftPreferences ?? [], giftPreferences))
        'giftPreferences': giftPreferences,
      if (partnerCode != null && user?.partnerCode.toString() != partnerCode)
        'partnerCode': partnerCode, //previously 'partnerId' #muttas
    };

    if (data.isEmpty) {
      // Nothing to update
      if (popScreen && context.mounted) Navigator.pop(context);
      return;
    }

    try {
      final response = await _userRepo.updateProfile(data);
      if (context.mounted) {
        await SplashServices().fetchProfile(context);
        if (context.mounted && popScreen && partnerCode != null) {
          Navigator.pop(context);
        }
        if (context.mounted) {
          context.flushBarSuccessMessage(
            message: 'Profile updated successfully',
          );
        }
        final String action =
            partnerCode != null ? 'Adding Partner' : 'Updating Profile';
        //check if it gets points
        final int pointEarned = response['points_earned'] as int;
        if (context.mounted) {
          if (pointEarned > 0) {
            PointsServices.showPointsEarnedDialog(
              context,
              action,
              points: pointEarned,
            );
          }
        }
      }

      debugPrint('[OnboardingService] ✅ Profile update success');
    } catch (e) {
      debugPrint('[OnboardingService] ❌ Error updating profile: $e');
      if (context.mounted) {
        final errorMessage = (e is AppException)
            ? e.userMessage
            : 'Something went wrong. Please try again.';
        context.flushBarErrorMessage(message: errorMessage);
      }
    }
  }

  //Change Password / Update Password
  Future<void> changePassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'userId': _sessionController.user?.id,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
      await _userRepo.updatePassword(data);

      if (context.mounted) {
        Navigator.of(context).pop();
        context.flushBarSuccessMessage(message: 'Password Updated...');
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SettingService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SettingService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }

  //Delete Account
  Future<void> deleteAccount({
    required BuildContext context,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'userId': _sessionController.user?.id,
      };
      await _authRepository.deleteUser(data);
      //clear session
      await _sessionController.clearSession();
      if (context.mounted) {
        LogoutService.goToWelcome(context);
        context.flushBarSuccessMessage(message: 'Account Deleted...');
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SettingService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SettingService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }

  //Remove Partner
  Future<void> removePartner({
    required BuildContext context,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'userId': _sessionController.user?.id,
      };
      await _authRepository.removePartner(data);
      //clear partner from session
      if (context.mounted) {
        _sessionController.partner = null;
        await SplashServices().fetchProfile(context);
        // _sessionController.isPartnerFetched = false;
        await _sessionController.setPartnerStatus(); //set to false
      }

      //End: Remove Partner
      if (context.mounted) {
        Navigator.of(context).pop();
        context.flushBarSuccessMessage(message: 'Partner Removed...');
      }
    } catch (e) {
      if (e is AppException) {
        debugPrint('[SettingService] ❌ ${e.debugMessage}');
        if (context.mounted) {
          context.flushBarErrorMessage(message: e.userMessage);
        }
      } else {
        debugPrint('[SettingService] ❌ Unexpected: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }
  }

  static void gotReferAFriend(BuildContext context) {
    //invite screen
    Navigator.pushNamed(
      context,
      RoutesName.invitation,
    );
  }

  Future<void> sageLaunchUrl(String url) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final Uri _url = Uri.parse(url);
    try {
      await launchUrl(_url);
    } catch (e) {
      debugPrint('Error in sageLaunchUrl $e');
    }
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }

  //send contact us request
  Future<void> contactUs(
    BuildContext context, {
    required String email,
    required String subjectLine,
    required String description,
  }) async {
    final data = {
      'email': email,
      'subject': subjectLine,
      'message': description,
    };
    try {
      await SettingsRepository().sendUserQuery(data);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Response Submitted');

        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e
    // , stackTrace
    ) {
      // // Developer logging
      // if (e is AppException) {
      //   debugPrint(
      //     '[SettingsService] ❌ Failed to send response: ${e.debugMessage}',
      //   );

      // } else {
      //   debugPrint('[SettingService] ❌ Unexpected error: $e');

      //   // Print first 15 lines of the stack trace
      //   final lines = stackTrace.toString().split('\n');
      //   final limitedStack = lines.take(15).join('\n');
      //   debugPrint('[SettingsService] 🔍 StackTrace:\n$limitedStack');
      // }

      // Show user-friendly error
      if (context.mounted) {
        final errorMessage = (e is AppException)
            ? e.userMessage
            : 'Something went wrong. Please try again.';
        context.flushBarErrorMessage(message: errorMessage);
      }
    }
  }

  //services for location
  String getCodeByName(List<dynamic> list, String name) {
    final item = list.firstWhere(
      (e) => e['name'] == name,
    );
    return item['code'].toString();
  }
}
