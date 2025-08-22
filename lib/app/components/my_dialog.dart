import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({
    required this.titleFirst,
    required this.titleSecond,
    required this.subtitle,
    super.key,
    this.onConfirm,
    this.onCancel,
    this.image,
    this.confirmLabel,
    this.cancelLabel,
    this.disableCancel = false,
  });

  final String titleFirst;
  final String titleSecond;
  final String subtitle;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final SvgGenImage? image;
  final bool disableCancel;

  /// Optional label for the confirm  button
  final String? confirmLabel;
  final String? cancelLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadiuses.extraLargeRadius),
      ),
      insetPadding: EdgeInsets.all(12.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 37.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (image ?? Assets.images.dialog.infoBlue).svg(
              height: 100.h,
              fit: BoxFit.fitHeight,
            ),
            SizedBox(height: 20.h),
            ColoredRichText(
              first: titleFirst,
              second: titleSecond,
            ),
            SizedBox(height: 7.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.typography.subtitle.copyWith(),
            ),
            SizedBox(height: 30.h),
            Row(
              children: [
                if (!disableCancel)
                  Expanded(
                    child: MyButton(
                      label: cancelLabel ?? context.l10n.dialog_cancel,
                      isDark: true,
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                SizedBox(width: 10.w),
                Expanded(
                  child: MyButton(
                    label: confirmLabel ?? context.l10n.dialog_yes_sure,
                    onPressed: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Following is how to use this dialog

// showDialog<void>(
//   context: context,
//   builder: (_) => MyDialog(
//   titleFirst: 'Delete ',
//   titleSecond: 'Account?',
//   subtitle: 'This action cannot be undone.',
//   confirmLabel: 'Delete Forever',
//   onConfirm: () {
//     // do stuff
//   },
// ),
// );
