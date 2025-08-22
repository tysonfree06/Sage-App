import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/redeem/redeem_model.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/redeem_points_service.dart';
import 'package:sage/view/redeem_points/widgets/offer_tile.dart';

class RedeemPointsScreen extends StatefulWidget {
  const RedeemPointsScreen({super.key});

  @override
  State<RedeemPointsScreen> createState() => _RedeemPointsScreenState();
}

class _RedeemPointsScreenState extends State<RedeemPointsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SessionController _sessionController = SessionController();
  List<RedeemOfferDetails> availableOffers = [];
  List<RedeemOfferDetails> pastRedemptions = [];

  bool isLoaded = false;

  Future<void> fetchOffers() async {
    try {
      // Fetch both requests in parallel
      final responses = await Future.wait([
        RedeemPointsService.getAvailableOffers(),
        RedeemPointsService.getPastRedemptions(),
      ]);

      final availableOffersResponse = responses[0];
      final pastRedemptionsResponse = responses[1];

      // Parse available offers
      final availableOffersData =
          (availableOffersResponse['data'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

      availableOffers =
          availableOffersData.map(RedeemOfferDetails.fromJson).toList();

      // Parse past redemptions
      final pastRedemptionsData =
          (pastRedemptionsResponse['data'] as List<dynamic>)
              .cast<Map<String, dynamic>>();

      pastRedemptions =
          pastRedemptionsData.map(RedeemOfferDetails.fromJson).toList();
    } catch (e) {
      if (mounted) {
        context.flushBarErrorMessage(message: 'Failed to load offers');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOffers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    // final availableOffers = getFilteredAvailableOffers();
    // final pastRedemptions = getFilteredPastRedemptions();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.white,
        title: Text(
          context.l10n.redeem_point_topbar_title,
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: context.colors.textDarkGreen,
          ),
        ),
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
                          _sessionController.user?.totalPoints.toString() ??
                              '0',
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
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          RedeemPointsService.goToInvite(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                if (availableOffers.isEmpty && isLoaded)
                  _buildEmptyState(context.l10n.redeem_no_offer_available)
                else
                  !isLoaded
                      ? const Center(
                          child: LoadingWidget(),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          itemCount: availableOffers.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            return OfferTile(
                              offer: availableOffers[index],
                              onNavigation: () async {
                                await RedeemPointsService.goToDetailScreen(
                                  context,
                                  availableOffers[index],
                                );
                                await fetchOffers();
                              },
                            );
                          },
                        ),

                // Past Redemptions tab
                if (pastRedemptions.isEmpty && isLoaded)
                  _buildEmptyState(context.l10n.redeem_no_past_redemptions)
                else
                  !isLoaded
                      ? const Center(
                          child: LoadingWidget(),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          itemCount: pastRedemptions.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            // return OfferTile(
                            //   offer: pastRedemptions[index],
                            // );

                            return OfferTile(
                              offer: pastRedemptions[index],
                              onNavigation: () async {
                                await RedeemPointsService.goToDetailScreen(
                                  context,
                                  pastRedemptions[index],
                                );
                                await fetchOffers();
                              },
                            );
                          },
                        ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
