import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class InvitationScreen extends StatelessWidget {
  const InvitationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final sessionController = SessionController();
    final referalCode = sessionController.user?.mineinvitationCode ?? '';

    // const String referalCode = 'nzkKFg';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.white,
        leading: const BackButton(),
        title: Text(
          context.l10n.refer_topbar_title,
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: context.colors.textDarkGreen,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colors.mainGreenDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
                child: Column(
                  children: [
                    Text(
                      context.l10n.refer_code,
                      style: context.typography.title.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.white.withValues(alpha: 0.50),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          referalCode,
                          style: context.typography.title.copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.white),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: referalCode));
                            if (context.mounted) {
                              context.flushBarSuccessMessage(
                                message: 'Copied to clipboard',
                              );
                            }
                          },
                          child:
                              Assets.icons.copy.svg(height: 12.h, width: 12.w),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 102.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: context.colors.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Assets.images.whiteHeart.image(
                            width: 30.w,
                            height: 30.h,
                          ),
                          SizedBox(height: 10.h),
                          ColoredRichText(
                            first: context.l10n.refer_twelve_hundred,
                            firstFontSize: 18.sp,
                            firstFontWeight: FontWeight.w600,
                            firstColor: context.colors.textLightGreen,
                            second: 'Pts',
                            secondFontSize: 14.sp,
                            secondFontWeight: FontWeight.w500,
                            secondColor: context.colors.textLightGreen,
                          ),
                          Text(
                            context.l10n.refer_total_points,
                            style: context.typography.title.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.textDarkGreen
                                  .withValues(alpha: 0.60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Container(
                      height: 102.h,
                      padding:
                          EdgeInsets.symmetric(vertical: 9.h, horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: context.colors.mainGreenLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Assets.icons.userProfile.svg(
                            width: 26.w,
                            height: 26.h,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '03',
                            style: context.typography.title.copyWith(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.white,
                            ),
                          ),
                          Text(
                            context.l10n.refer_total_member,
                            style: context.typography.title.copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: context.colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Text(
                context.l10n.refer_to_friends_title,
                style: context.typography.title.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textDarkGreen,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.refer_to_friends_subtitle,
                      style: context.typography.title.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textDarkGreen,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _RewardLeaf(points: '500'),
                        _RewardLeaf(points: '500'),
                        _RewardLeaf(points: '500'),
                        _RewardLeaf(points: '1000'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Text(
                context.l10n.refer_terms_disclaimers,
                style: context.typography.title.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.textDarkGreen,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TermRow(text: context.l10n.refer_terms_disclaimers_1),
                    SizedBox(height: 20.h),
                    _TermRow(text: context.l10n.refer_terms_disclaimers_2),
                  ],
                ),
              ),
              SizedBox(height: 38.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardLeaf extends StatelessWidget {
  const _RewardLeaf({required this.points});

  final String points;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Assets.images.logo.onlyDimLogo.svg(
          width: 30,
          height: 30,
        ),
        SizedBox(height: 10.h),
        ColoredRichText(
          first: points,
          firstFontSize: 16.sp,
          firstFontWeight: FontWeight.w600,
          firstColor: context.colors.textLightGreen,
          second: 'Pts',
          secondFontSize: 16.sp,
          secondFontWeight: FontWeight.w500,
          secondColor: const Color(0xFF000000),
        ),
      ],
    );
  }
}

class _TermRow extends StatelessWidget {
  const _TermRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(height: 4.h),
            Assets.icons.shareArrow.svg(
              width: 15,
              height: 14,
            ),
          ],
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: context.typography.title.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.textDarkGreen.withValues(alpha: 0.60),
            ),
          ),
        ),
      ],
    );
  }
}
