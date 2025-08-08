import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/settings_service.dart';

class AddPartnerSheet extends StatefulWidget {
  const AddPartnerSheet({
    super.key,
  });

  @override
  State<AddPartnerSheet> createState() => _AddPartnerSheetState();
}

class _AddPartnerSheetState extends State<AddPartnerSheet> {
  final pinController = TextEditingController();
  final SettingService _settingService = SettingService();
  bool isLoading = false;

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredRichText(
            first: '',
            second: context.l10n.home_add_partner,
          ),
          SizedBox(height: 7.h),
          ColoredRichText(
            first: context.l10n.home_add_partner_with_code,
            second: '',
            firstColor: context.colors.textDarkGreen.withValues(alpha: .60),
            secondColor: context.colors.textDarkGreen,
            firstFontSize: 15.sp,
            secondFontSize: 15.sp,
            firstFontWeight: FontWeight.w500,
            secondFontWeight: FontWeight.w500,
          ),
          SizedBox(height: 50.h),
          MyPinput(
            length: 5,
            controller: pinController,
            enabled: !isLoading,
            onChanged: (value) => setState(() {}),
          ),
          SizedBox(height: 90.h),
          MyButton(
            label: context.l10n.home_connect,
            isLoading: isLoading,
            onPressed: pinController.text.length < 5
                ? null
                : () async {
                    setState(() => isLoading = true);
                    await _settingService
                        .updateProfile(
                      context: context,
                      partnerCode: pinController.text,
                      popScreen: true,
                    )
                        .then((_) {
                      if (mounted) {
                        setState(() => isLoading = false);
                      }
                    });
                    // if (context.mounted) {
                    //   await SplashServices().fetchPartner(context);
                    // }
                  },
          ),
        ],
      ),
    );
  }
}
