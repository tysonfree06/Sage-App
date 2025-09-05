import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/free_user_alert.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/notifications_services.dart';
import 'package:sage/services/views/splash_services.dart';
import 'package:sage/view/home/widgets/countdown_timer.dart';
import 'package:sage/view/home/widgets/user_content.dart';
import 'package:sage/view/home/widgets/user_not_available.dart';
import 'package:sage/view/home/widgets/vertical_dashed_divider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SplashServices _splashServices = SplashServices();
  final AuthRepository _userAuth = AuthRepository();
  final NotificationsServices _notificationServices = NotificationsServices();
  final sessionController = SessionController();

  UserModel? partner;
  Future<void> getPartner() async {
    if (sessionController.partner == null &&
        sessionController.user?.partnerCode != null) {
      final int? partnerCode = sessionController.user?.partnerCode;
      try {
        final response = await _userAuth.getPartner(partnerCode);

        // Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            sessionController.partner = UserModel.fromJson(
              response['partner'] as Map<String, dynamic>,
            );

            partner = UserModel.fromJson(
              response['partner'] as Map<String, dynamic>,
            );
          });
        }
        setState(
          () {
            sessionController.setPartnerStatus(status: true);
          },
        );

        debugPrint('✅ Partner Fetched from Home');
      } catch (e) {
        debugPrint('❌ Error fetching partner: $e');
      }
    } else {
      partner = sessionController.partner;

      if (sessionController.isPartnerFetched == false) {
        debugPrint('GOT PARTNER FROM SESSION');
        setState(
          () {
            sessionController.setPartnerStatus(status: true);
          },
        );
      }
    }
  }

  Map<String, dynamic> relationshipSuggestion = {};
  bool isTipLoaded = false;
  Future<void> getRelationshipSuggestion() async {
    try {
      relationshipSuggestion =
          await _splashServices.loadRelationshipSuggestion();
      if (mounted && relationshipSuggestion.isNotEmpty) {
        setState(() {
          isTipLoaded = true;
        }); //don't remove it
      }
    } catch (e) {
      debugPrint('Failed to fetch Relationship Suggestions / Daily Tip');
    }
  }

  List<dynamic> notificationsList = [];
  int unreadMessagesCount = 0;
  Future<void> fetchNotifications() async {
    try {
      final response = await _notificationServices.getNotifications();
      final data = response['data'] as List<dynamic>;
      if (mounted) {
        setState(() {
          notificationsList = data;
        });
      }
      sessionController.notifications = data;
      final List<dynamic> unreadMessages =
          notificationsList.where((msg) => msg['isRead'] == false).toList();
      if (mounted) {
        setState(() {
          unreadMessagesCount = unreadMessages.length;
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch notifications');
    }
  }

  void loadProfile() {
    // final user = sessionController.user;
    // if (user == null)
    SplashServices().fetchProfile(context);
  }

  @override
  void initState() {
    super.initState();
    getRelationshipSuggestion();
    loadProfile(); //fetch profile on home
    getPartner();
    fetchNotifications();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   PointsServices.showPointsEarnedDialog(
    //     context,
    //     points: 50,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    //get user form session
    final user = sessionController.user!;
    // final partner = _sessionController.partner;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Assets.images.logo.logoHorizontal.svg(),
        ),
        actions: [
          Assets.icons.pointsPng.image(height: 30.w, width: 30.w),
          // const Text(' 500pts'),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Text(
                  sessionController.user?.totalPoints.toString() ?? '0',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                    color: context.colors.greenBg,
                  ),
                ),
                Text(
                  'Pts',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: context.colors.greenBg,
                  ),
                ),
              ],
            ),
          ),

          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                    context,
                    RoutesName.notifications,
                  );
                  await fetchNotifications();
                },
                icon: Assets.icons.notification.svg(),
              ),
              //badge
              if (unreadMessagesCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12.w,
                      minHeight: 12.h,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        color: context.colors.textLightGreen,
        onRefresh: () async {
          await Future.wait([
            SplashServices().fetchProfile(context),
            getPartner(),
            getRelationshipSuggestion(),
            fetchNotifications(),
          ]);
        },
        child: LayoutBuilder(
            // FixedIt: Wrap in LayoutBuilder to force scrollable physics
            builder: (context, constraints) {
          return SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // FixedIt: Always allow pull-to-refresh
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints
                    .maxHeight, // FixedIt: Force scrollable even with small content
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FreeUserAlert(
                      title: 'Get More Out of Sage 💕',
                      subtitle:
                          '''Upgrade your Sage Membership to unlock Saved Ideas, unlimited suggestions, prizes and more!''',
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 21.h),
                      // height: 421.h,
                      decoration: BoxDecoration(
                        color: context.colors.greenBg,
                        borderRadius:
                            BorderRadius.circular(AppRadiuses.extraLargeRadius),
                      ),
                      child: Column(
                        children: [
                          // ConstrainedBox( //it can also be used instead of intrinsic height
                          //   constraints: BoxConstraints(
                          //     maxHeight: 380.h,
                          //   ),
                          // IntrinsicHeight(
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 👤 User Section
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
                                    child: UserContentWidget(
                                      user: user,
                                      isPartner: false,
                                    ),
                                  ),
                                ),

                                // 🔸 Dashed Divider
                                VerticalDashedDivider(
                                  height: double.infinity,
                                  dashHeight: 4,
                                  dashSpacing: 4,
                                  color: context.colors.yellow,
                                ),
                                // 👤 Partner Section
                                if (partner != null)
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                      ),
                                      child: UserContentWidget(
                                        user: partner!,
                                        isPartner: true,
                                      ),
                                    ),
                                  )
                                else if (sessionController.user?.partnerCode ==
                                    null)
                                  PartnerUnavailable(
                                    onParnerAdded: () {
                                      if (mounted) {
                                        setState(() {
                                          debugPrint(
                                              'SET STATE CALLED IN HOME...');
                                          getPartner();
                                        });
                                      }
                                    },
                                  ),

                                () {
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    if (mounted) {
                                      getPartner();
                                    }
                                  });
                                  if (sessionController.isPartnerFetched ==
                                          false &&
                                      sessionController.user!.partnerCode !=
                                          null) {
                                    return Expanded(
                                      child: LoadingWidget(
                                        color: context.colors.white,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }(),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          //anniversary section
                          if (partner != null)
                            Container(
                              margin: EdgeInsets.only(
                                top: 12.h,
                                left: 14.w,
                                right: 14.w,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 16.w,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: context.colors.yellow,
                                borderRadius: BorderRadius.circular(
                                  AppRadiuses.largeRadius,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Next Anniversary In',
                                    style: context.typography.label.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: context.colors.mainGreenDark,
                                    ),
                                  ),
                                  SizedBox(height: 9.h),
                                  CountdownTimerWidget(
                                    targetDate: partner?.anniversaryDate ??
                                        DateTime.now(),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    if (isTipLoaded) ...[
                      Text(
                        'Relationship Suggestions',
                        style: context.typography.title.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          color: context.colors.textDarkGreen,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      RelationshipSuggestionTile(
                        suggestion: relationshipSuggestion,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class RelationshipSuggestionTile extends StatelessWidget {
  const RelationshipSuggestionTile({
    required this.suggestion,
    super.key,
  });
  final Map<String, dynamic> suggestion;
  @override
  Widget build(BuildContext context) {
    String title = "Today's Tip";
    if (suggestion['subject'] != null) {
      title = suggestion['subject'] as String;
    }
    String tip = '';

    if (suggestion['tip'] != null) {
      tip = suggestion['tip'] as String;
    }
    // String imageUrl = 'https://picsum.photos/200/300';
    // if (suggestion['image'] != null) {
    final String imageUrl = suggestion['image'].toString();
    // }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //image
          if (suggestion['image'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 132.h,
                width: double.infinity,
                color: context.colors.white,
                child: Image.network(
                  imageUrl,
                  height: 132..h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),
            ),
          //END: image
          SizedBox(
            height: 8.h,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            tip,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerUnavailable extends StatelessWidget {
  const PartnerUnavailable({
    required this.onParnerAdded,
    super.key,
  });
  final void Function() onParnerAdded;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                AppRadiuses.hundredRadius,
              ),
              child: Container(
                height: 60.w,
                width: 60.w,
                color: Colors.white.withValues(alpha: 0.2),
                child: Image.asset(
                  Assets.icons.userWhitePng.path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Partner',
              style: context.typography.title.copyWith(
                fontSize: 15.sp,
                color: context.colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Divider(
              color: context.colors.white.withValues(alpha: 0.1),
            ),
            UserNotAvailableWidget(
              onParnerAdded: onParnerAdded,
            ),
          ],
        ),
      ),
    );
  }
}
