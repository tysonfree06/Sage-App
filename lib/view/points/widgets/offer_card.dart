import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/redeem/radeem_model.dart';
import 'package:sage/services/views/redeem_points_service.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    required this.giftCard,
    super.key,
  });

  final RedeemOfferDetails giftCard;
  static final _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final redemptionDateFormatted = giftCard.redemptionDate != null
        ? _dateFormat.format(giftCard.redemptionDate!)
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => RedeemPointsService.goToDetailScreen(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOfferRow(context),
              if (redemptionDateFormatted != null) ...[
                SizedBox(height: 12.h),
                _buildRedemptionDateRow(context, redemptionDateFormatted),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOfferRow(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            giftCard.imageUrl,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                giftCard.title,
                style: context.typography.title.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textDarkGreen,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                giftCard.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bodySmall.copyWith(
                  color: context.colors.textDarkGreen.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Assets.images.redHeart.image(
                    height: 16.h,
                    width: 16.w,
                  ),
                  SizedBox(width: 5.w),
                  ColoredRichText(
                    first: '${giftCard.points}',
                    firstFontSize: 13.sp,
                    firstFontWeight: FontWeight.w600,
                    firstColor: context.colors.textLightGreen,
                    second: 'Pts',
                    secondFontSize: 12.sp,
                    secondFontWeight: FontWeight.w500,
                    secondColor: const Color(0xFF000000),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRedemptionDateRow(BuildContext context, String formattedDate) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.redeem_date,
            style: context.typography.title.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.textDarkGreen.withOpacity(0.6),
            ),
          ),
          Text(
            formattedDate,
            style: context.typography.title.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: context.colors.textDarkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

