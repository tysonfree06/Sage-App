import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/radeem_model.dart';

final List<RedeemOfferDetails> offers = [
  RedeemOfferDetails(
    backendId: '1',
    offerId: '#2345679012',
    isPast: false,
    title: 'Daily Challenge Vault',
    points: 210,
    startDate: DateTime(2025, 4, 10),
    endDate: DateTime(2025, 4, 12),
    redemptionDate: DateTime(2025, 4, 10),
    description:
        "Redeem to access past daily challenges for more practice. Just by practicing healthy relationship habits you'll earn points for discounts and prizes! Just by practicing healthy relationship habits you'll earn points for discounts and prizes!\n\nUnlimited Chats with Sage AI: Sage AI assists with unbiased advice, personalized ideas for dates and more!!\n\nDiscounts & Prizes for Healthy Habits: Just by practicing healthy relationship habits you'll earn points for discounts and prizes!\n\nUnlimited Saved Ideas: Keep track of all the ideas for your relationship!!",
    imageUrl:
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
  ),
];

class RedeemOfferScreen extends StatelessWidget {
  const RedeemOfferScreen({required this.offer, super.key});

  final RedeemOfferDetails offer;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return Scaffold(
      appBar: AppBar(
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
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    offer.imageUrl,
                    fit: BoxFit.cover,
                  ),
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
                          style: TextStyle(
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
                  if (offer.isPast)
                    Container(
                      decoration: BoxDecoration(
                        color: context.colors.yellow.withValues(alpha: 0.19),
                        borderRadius: BorderRadius.circular(80),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                      child: Text(
                        context.l10n.redeem_past,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.yellow,
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
                      style: TextStyle(
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
                    style: TextStyle(
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
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: context.colors.textDarkGreen.withValues(alpha: 0.60),
                ),
              ),

              // const Spacer(),
              if (offer.isPast == true && offer.redemptionDate != null) ...[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colors.chipBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.redeem_date,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textDarkGreen
                                .withValues(alpha: 0.60),
                          ),
                        ),
                        Text(
                          dateFormat.format(offer.redemptionDate!),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.textDarkGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
              ] else ...[
                SizedBox(height: 30.h),
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
                SizedBox(height: 30.h),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
