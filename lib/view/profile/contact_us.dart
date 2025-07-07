import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/l10n/l10n.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: context.colors.mainGreenLight,
        ),
        centerTitle: true,
        title: Text(
          context.l10n.contact_us_title,
          style: context.typography.title.copyWith(
            color: context.colors.textDarkGreen,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.contact_us_description,
              textAlign: TextAlign.center,
              style: context.typography.subtitle.copyWith(
                fontSize: 16.w,
              ),
            ),
            SizedBox(height: 8.h),
            MyTextButton(
              label: context.l10n.contact_us_email,
              fontSize: 16.w,
              onPressed: () {
                //TODO: launch url or copy to clipboard
              },
            ),
          ],
        ),
      ),
    );
  }
}
