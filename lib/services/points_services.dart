import 'package:flutter/material.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/generated/assets/assets.gen.dart';

class PointsServices {
  static void showPointsEarnedDialog(
    BuildContext context,
    String action, {
    int points = 0,
  }) {
    final String actionName = action.isNotEmpty ? 'for $action' : '';
    showDialog<void>(
      context: context,
      builder: (_) => MyDialog(
        titleFirst: 'Great ',
        titleSecond: 'Job!',
        subtitle: 'You have earned $points points $actionName',
        confirmLabel: 'Done',
        disableButtons: true,
        image: Assets.images.dialog.celebration,
        // image: Assets.images.dialog.celebration,
        // image: Assets.images.dialog.bin,
        onConfirm: () {
          Navigator.pop(context);
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        },
      ),
    );
  }
}
