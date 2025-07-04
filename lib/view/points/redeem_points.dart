import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/redeem/radeem_model.dart';
import 'package:sage/services/views/redeem_points_service.dart';
import 'package:sage/view/points/widgets/offer_tile.dart';

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
      backendId: '1',
      offerId: '#2345679012',
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
    RedeemOfferDetails(
      backendId: '2',
      offerId: '#3456789013',
      title: 'Weekend Wellness Pack',
      points: 300,
      startDate: DateTime(2025, 5, 1),
      endDate: DateTime(2025, 5, 5),
      // no redemptionDate
      description:
          "A special wellness pack to help you recharge over the weekend with meditation, yoga, and healthy eating guides.",
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '3',
      offerId: '#4567890124',
      title: 'Relationship Builder Kit',
      points: 250,
      startDate: DateTime(2025, 6, 15),
      endDate: DateTime(2025, 6, 20),
      redemptionDate: DateTime(2025, 6, 16),
      description:
          "Tools and guides to strengthen your relationship with activities and communication exercises.",
      imageUrl:
          'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '4',
      offerId: '#5678901235',
      title: 'Healthy Habits Booster',
      points: 180,
      startDate: DateTime(2025, 7, 5),
      endDate: DateTime(2025, 7, 10),
      // no redemptionDate
      description:
          "Boost your daily routine with quick, healthy habits designed to improve your lifestyle and relationships.",
      imageUrl:
          'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '5',
      offerId: '#6789012346',
      title: 'Date Night Inspiration',
      points: 150,
      startDate: DateTime(2025, 8, 12),
      endDate: DateTime(2025, 8, 15),
      redemptionDate: DateTime(2025, 8, 13),
      description:
          "Ideas and tips for unforgettable date nights that bring you closer.",
      imageUrl:
          'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '6',
      offerId: '#7890123457',
      title: 'Mindfulness Challenge',
      points: 220,
      startDate: DateTime(2025, 9, 1),
      endDate: DateTime(2025, 9, 7),
      redemptionDate: DateTime(2025, 9, 2),
      description:
          "A week-long mindfulness challenge to help you stay present and improve your emotional health.",
      imageUrl:
          'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '7',
      offerId: '#8901234568',
      title: 'Communication Mastery',
      points: 270,
      startDate: DateTime(2025, 10, 10),
      endDate: DateTime(2025, 10, 15),
      // no redemptionDate
      description:
          "Master effective communication skills for stronger and healthier relationships.",
      imageUrl:
          'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '8',
      offerId: '#9012345679',
      title: 'Self-Care Essentials',
      points: 200,
      startDate: DateTime(2025, 11, 1),
      endDate: DateTime(2025, 11, 5),
      redemptionDate: DateTime(2025, 11, 2),
      description:
          "Essentials for self-care routines that nurture your mind, body, and soul.",
      imageUrl:
          'https://images.unsplash.com/photo-1486308510493-cb6b2df05e6e?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '9',
      offerId: '#0123456780',
      title: 'Gratitude Journal',
      points: 130,
      startDate: DateTime(2025, 12, 1),
      endDate: DateTime(2025, 12, 3),
      redemptionDate: DateTime(2025, 12, 2),
      description:
          "A digital gratitude journal to help you focus on the positive aspects of your relationships.",
      imageUrl:
          'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2?auto=format&fit=crop&w=800&q=80',
    ),
    RedeemOfferDetails(
      backendId: '10',
      offerId: '#1234567891',
      title: 'Stress Relief Toolkit',
      points: 190,
      startDate: DateTime(2025, 12, 15),
      endDate: DateTime(2025, 12, 20),
      redemptionDate: DateTime(2025, 12, 16),
      description:
          "Techniques and tools to help manage stress and improve emotional well-being.",
      imageUrl:
          'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
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
        backgroundColor: context.colors.white,
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
                        onPressed: () {
                          RedeemPointsService.goToInvite(context);
                        },
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
                      return OfferTile(offer: availableOffers[index]);
                    },
                  ),

                // Past Redemptions tab
                if (pastRedemptions.isEmpty)
                  _buildEmptyState(context.l10n.redeem_no_past_redemptions)
                else
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    itemCount: pastRedemptions.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      return OfferTile(offer: pastRedemptions[index]);
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

/*class OfferCard extends StatelessWidget {
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(context, RoutesName.redeemOfferDetail,);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
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
      ),
    );
  }
}*/
