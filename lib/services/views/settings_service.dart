import 'package:flutter/material.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';

class SettingService {
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
}
