import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/onboarding_service.dart';

class AnalyzeDataScreen extends StatefulWidget {
  const AnalyzeDataScreen({super.key});

  @override
  State<AnalyzeDataScreen> createState() => _AnalyzeDataScreenState();
}

class _AnalyzeDataScreenState extends State<AnalyzeDataScreen> {
  @override
  void initState() {
    super.initState();
    OnboardingService.goToHomeDelayed(context);
  }

  @override
  Widget build(BuildContext context) {
    return DarkStatusBar(
      child: Scaffold(
        backgroundColor: context.colors.mainGreenDark,
        appBar: AppBar(
          leading: BackButton(
            color: context.colors.mainGreenLight,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(AppDimensions.medium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.images.loading.path,
                width: 150,
                height: 150,
              ),
              SizedBox(height: 12.h),
              Text(
                context.l10n.analyze_data_title,
                style: context.typography.title.copyWith(
                  color: context.colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.2,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                context.l10n.analyze_data_subtitle,
                style: context.typography.subtitle.copyWith(
                  color: context.colors.white.withValues(alpha: .6),
                  letterSpacing: .2,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 150.h),
            ],
          ),
        ),
      ),
    );
  }
}
