import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/repository/image_upload_repo.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class SettingService {
  final UserRepository _userRepo = UserRepository();
  final ImageUploadRepository _imageUploadRepository = ImageUploadRepository();
  final SessionController _sessionController = SessionController();
  final _listEq = const ListEquality<String>();

  static Future<void> goToEditProfileScreen(BuildContext context) async {
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

  static Future<void> goToNoSubscriptionScreen(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.subscription,
      arguments: false, //show skip button
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
        onConfirm: () {
          // TODO:
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
        onConfirm: () {
          // TODO:
        },
      ),
    );
  }

  Future<String?> uploadProfileImage(File image) async {
    try {
      final response = await _imageUploadRepository.uploadImage(image.path);
      return response;
    } catch (e) {
      debugPrint('[SettingService] Upload failed: $e');
      rethrow;
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
    String? partnerId,
    bool popScreen = false,
  }) async {
    final user = _sessionController.user;

    final Map<String, dynamic> data = {
      'userId': _sessionController.user?.id,
      if (name != null && user?.name != name) 'name': name,
      if (loveLanguage != null && user?.loveLanguage != loveLanguage)
        'love_language': loveLanguage,
      if (apologyLanguage != null && user?.apologyLanguage != apologyLanguage)
        'apology_language': apologyLanguage,
      if (communicationStyle != null &&
          user?.communicationStyle != communicationStyle)
        'communication_style': communicationStyle,
      if (budgetLevel != null && user?.budgetLevel != budgetLevel)
        'budget_level': budgetLevel,
      if (relationshipStatus != null &&
          user?.relationshipStatus != relationshipStatus)
        'relationship_status': relationshipStatus,
      if (anniversaryDate != null && user?.anniversaryDate != anniversaryDate)
        'anniversary_date': anniversaryDate,
      if (dateOfBirth != null && user?.dateOfBirth != dateOfBirth)
        'date_of_birth': dateOfBirth,
      if (city != null && user?.location.city != city) 'city': city,
      if (state != null && user?.location.state != state) 'state': state,
      if (country != null && user?.location.country != country)
        'country': country,
      if (image != null && user?.image != image) 'image_url': image,
      if (interests != null &&
          !_listEq.equals(user?.interests ?? [], interests))
        'interests': interests,
      if (giftPreferences != null &&
          !_listEq.equals(user?.giftPreferences ?? [], giftPreferences))
        'gift_preferences': giftPreferences,
      if (partnerId != null && user?.partnerId != partnerId)
        'partner_id': partnerId,
    };

    if (data.isEmpty) {
      // Nothing to update
      if (popScreen && context.mounted) Navigator.pop(context);
      return;
    }

    try {
      await _userRepo.updateProfile(data);
      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Profile updated successfully');
        if (popScreen) Navigator.pop(context);
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
}
