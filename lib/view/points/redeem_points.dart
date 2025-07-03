import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/redeem/radeem_model.dart';
import 'package:sage/view/points/radeem_offer_detail.dart';

class RedeemPointsScreen extends StatefulWidget {
  const RedeemPointsScreen({super.key});

  @override
  State<RedeemPointsScreen> createState() => _RedeemPointsScreenState();
}

class _RedeemPointsScreenState extends State<RedeemPointsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<RedeemOfferDetails> giftCards = [
    RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: '10% off Coupon',
      points: 100,
      redemptionDate: DateTime(2023, 12, 31),
      description: 'Use this coupon to get 10% discount',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: '10% off Coupon',
      points: 100,
      redemptionDate: DateTime(2023, 12, 31),
      description: 'Use this coupon to get 10% discount',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: 'Shipping',
      points: 50,
      description: 'Get free shipping on orders over \$50',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: ' Shipping',
      points: 50,
      description: 'Get free shipping on orders over \$50',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: 'Free Shipping',
      points: 50,
      description: 'Get free shipping on orders over \$50',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: 'Free Shipping',
      points: 50,
      description: 'Get free shipping on orders over \$50',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: 'Free Shipping',
      points: 50,
      description: 'Get free shipping on orders over \$50',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),RedeemOfferDetails(
      startDate: DateTime(2023, 01, 01),
      endDate: DateTime(2023, 12, 31),
      title: 'Free Shipping',
      points: 50,
      description: 'Get free shipping on orders over \$50',
      imageUrl:
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<RedeemOfferDetails> getFilteredAvailableOffers() {
    return giftCards
        .where((giftCard) => giftCard.redemptionDate == null)
        .toList();
  }

  List<RedeemOfferDetails> getFilteredPastRedemptions() {
    return giftCards
        .where((giftCard) => giftCard.redemptionDate != null)
        .toList();
  }

  Widget _buildEmptyState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.icons.noOffers.svg(
          height: 100.h,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 20.h),
        Text(
          message,
          style: context.typography.subtitle.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.textDarkGreen,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableOffers = getFilteredAvailableOffers();
    final pastRedemptions = getFilteredPastRedemptions();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.redeem_point_topbar_title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 13.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.redeemPointBg.path),
                fit: BoxFit.cover,
              ),
              color: context.colors.greenBg,
              borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 12.w,
                    ),
                    Assets.icons.starGreen.svg(
                      height: 40.h,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1200',
                          style: context.typography.title.copyWith(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: context.colors.yellow,
                          ),
                        ),
                        // SizedBox(height: 5.h),
                        Text(
                          context.l10n.redeem_total_points,
                          style: context.typography.subtitle.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: context.colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  color: context.colors.white.withValues(alpha: 0.1),
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          context.l10n.redeem_invite_your_friends,
                          style: context.typography.body.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFFFFFF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          side: BorderSide(
                            color: context.colors.yellow,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppRadiuses.mediumRadius),
                          ),
                        ),
                        child: Text(
                          context.l10n.redeem_invite,
                          style: context.typography.label.copyWith(
                            fontSize: 13.sp,
                            color: context.colors.yellow,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          TabBar(
            controller: _tabController,
            labelColor: context.colors.mainGreenLight,
            unselectedLabelColor:
                context.colors.textDarkGreen.withValues(alpha: 0.6),
            indicatorColor: context.colors.mainGreenLight,
            labelStyle: context.typography.title.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: context.typography.title.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: context.l10n.redeem_available_offers),
              Tab(text: context.l10n.redeem_past_redemptions),
            ],
          ),
          // SizedBox(height: 15.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Available Offers tab
                if (availableOffers.isEmpty)
                  _buildEmptyState(context.l10n.redeem_no_offer_available)
                else
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    itemCount: availableOffers.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return OfferCard(giftCard: availableOffers[index]);
                    },
                  ),

                // Past Redemptions tab
                if (pastRedemptions.isEmpty)
                  _buildEmptyState(context.l10n.redeem_no_past_redemptions)
                else
                  ListView.separated(
                    itemCount: pastRedemptions.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return OfferCard(giftCard: pastRedemptions[index]);
                    },
                  ),
              ],
            ),
          ),

        ],

        /*SizedBox(height: 20.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefix: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Assets.icons.search.svg(
                    height: 20.h,
                    width: 20.w,
                  ),
                ),
                hintText: 'Search offers...',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
            ),
          ),
          SizedBox(height: 15.h),*/
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  const OfferCard({
    required this.giftCard,
    super.key,
  });

  final RedeemOfferDetails giftCard;

  @override
  Widget build(BuildContext context) {
    final redemptionDateFormatted = giftCard.redemptionDate != null
        ? DateFormat('MMM dd, yyyy').format(giftCard.redemptionDate!)
        : '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.redeemPoints,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Offer image
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
                            color: context.colors.textDarkGreen
                                .withValues(alpha: 0.6),
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
              ),
              if (giftCard.redemptionDate != null) ...[
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.redeem_date,
                        style: context.typography.title.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textDarkGreen
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        redemptionDateFormatted,
                        style: context.typography.title.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textDarkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
