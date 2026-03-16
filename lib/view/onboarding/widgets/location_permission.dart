import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
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
  State<LocationPermission> createState() => _LocationPermissionState();
}

class _LocationPermissionState extends State<LocationPermission> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.location.svg(),
          SizedBox(height: 40.h),
          ColoredRichText(
            first: context.l10n.locations_sheet_first_title,
            second: context.l10n.locations_sheet_second_title,
          ),
          SizedBox(height: 7.h),
          Text(
            context.l10n.locations_sheet_subtitle,
            style: context.typography.subtitle.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 34.h),
          MyButton(
            label: context.l10n.locations_sheet_setting,
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
