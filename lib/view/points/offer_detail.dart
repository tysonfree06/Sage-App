import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/redeem/radeem_model.dart';

class OfferDetailScreen extends StatelessWidget {
  const OfferDetailScreen({required this.offer, super.key});

  final RedeemOfferDetails offer;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.white,
        leading: const BackButton(),
        title: Text(context.l10n.redeem_topbar_title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 215.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.colors.mainGreenDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  offer.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.chipBg,
                      borderRadius: BorderRadius.circular(80),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          offer.offerId,
                          style: context.typography.title.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textLightGreen,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Assets.icons.copyGreen.svg(),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  if (offer.endDate.isBefore(DateTime.now()) ||
                      offer.redemptionDate != null)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x30D4B843),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 29.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                        context.l10n.redeem_past,
                        style: context.typography.title.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFD4B843),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      offer.title,
                      style: context.typography.title.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: context.colors.textDarkGreen,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Assets.images.redHeart.image(
                        width: 20.w,
                        height: 20.h,
                      ),
                      SizedBox(width: 6.w),
                      ColoredRichText(
                        first: '${offer.points}',
                        firstFontSize: 16.sp,
                        firstFontWeight: FontWeight.w600,
                        firstColor: context.colors.textLightGreen,
                        second: 'Pts',
                        secondFontSize: 15.sp,
                        secondFontWeight: FontWeight.w500,
                        secondColor: const Color(0xFF6E7B7B),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Assets.icons.time.svg(
                    width: 15.w,
                    height: 15.h,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '${dateFormat.format(offer.startDate)} - ${dateFormat.format(offer.endDate)}',
                    style: context.typography.title.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          context.colors.textDarkGreen.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.h),
              Text(
                offer.description,
                style: context.typography.title.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textDarkGreen.withValues(alpha: 0.60),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: MediaQuery.of(context).padding.bottom + 16.h,
        ),
        child: (offer.endDate.isBefore(DateTime.now()) || offer.redemptionDate != null)
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.colors.chipBg,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.redeem_date,
                    style: context.typography.title.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textDarkGreen.withAlpha(153),
                    ),
                  ),
                  Text(
                    offer.redemptionDate != null
                        ? dateFormat.format(offer.redemptionDate!)
                        : '-',
                    style: context.typography.title.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.textDarkGreen,
                    ),
                  ),

                ],
              ),
            ),
          ],
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton(
              label: context.l10n.redeem_btn_title,
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (_) => MyDialog(
                    image: Assets.images.dialog.infoBlue,
                    titleFirst: context.l10n.dialog_redeem,
                    titleSecond: context.l10n.redeem_dialog_second_title,
                    subtitle: context.l10n.dialog_redeem_offer_subtitle,
                    confirmLabel: context.l10n.redeem_dialog_yes_sure,
                    onConfirm: () {
                      // do stuff
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
