import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';

class LocationPermission extends StatefulWidget {
  const LocationPermission({
    super.key,
    this.onPressed,
  });
  final VoidCallback? onPressed;

  @override
  State<LocationPermission> createState() =>
      _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.location.svg(),
          ColoredRichText(
            first: context.l10n.locations_sheet_first_title,
            second: context.l10n.locations_sheet_second_title,
          ),

          MyButton(
            label: context.l10n.locations_sheet_setting,
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
