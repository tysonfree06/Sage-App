import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
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
  final SessionController _sessionController = SessionController();
  final SplashServices _splashServices = SplashServices();
  final AuthRepository _userAuth = AuthRepository();

  UserModel? partner;

  Future<void> getPartner() async {
    // if (!SessionController().isPartnerFetched &&
    //     _sessionController.user?.partnerCode != null) {
    if (SessionController().partner == null &&
        _sessionController.user?.partnerCode != null) {
      final dynamic partnerCode = _sessionController.user?.partnerCode ?? '';
      if (partnerCode == '') {
        debugPrint('No partner code found, skipping partner fetch');
        return;
      }
      try {
        final response = await _userAuth.getPartner(partnerCode);
        setState(() {
          partner = UserModel.fromJson(
            response['partner'] as Map<String, dynamic>,
          );
          _sessionController.partner = UserModel.fromJson(
            response['partner'] as Map<String, dynamic>,
          );

          SessionController().isPartnerFetched = true;
        });

        debugPrint('✅ Partner Fetched');
      } catch (e) {
        debugPrint('❌ Error fetching partner: $e');
      }
    } else {
      partner = SessionController().partner;
    }
  }

  Map<String, dynamic> relationshipSuggestion = {};
  Future<void> getRelationshipSuggestion() async {
    relationshipSuggestion = await _splashServices.loadRelationshipSuggestion();
    if (mounted) {
      setState(() {}); //don't remove it
    }
  }

  @override
  void initState() {
    super.initState();
    getPartner();
    getRelationshipSuggestion();
  }

  // List<String> relationshipSuggestions = [
  //   'Send a Thoghtful Message',
  //   'Send a Thoghtful Message',
  // ];

  @override
  Widget build(BuildContext context) {
    //get user form session
    final user = _sessionController.user!;
    // final partner = _sessionController.partner;

    return LightStatusBar(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Assets.images.logo.logoHorizontal.svg(),
          ),
          actions: [
            Assets.icons.points.image(height: 30.w, width: 30.w),
            // const Text(' 500pts'),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Row(
                children: [
                  Text(
                    _sessionController.user?.points.toString() ?? '0',
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

            IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutesName.notifications,
                );
              },
              icon: Assets.icons.notification.svg(),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 👤 User Section
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                  child: partner != null
                                      ? UserContentWidget(
                                          user: partner!,
                                          isPartner: true,
                                        )
                                      : PartnerUnavailable(
                                          onParnerAdded: () {
                                            debugPrint('HELLO');
                                            setState(() {
                                              debugPrint(
                                                'SET STATE CALLED IN HOME',
                                              );
                                              getPartner();
                                            });
                                          },
                                        ),
                                ),
                              )
                            else
                              PartnerUnavailable(
                                onParnerAdded: () {
                                  setState(() {
                                    debugPrint('SET STATE CALLED IN HOME...');
                                    getPartner();
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                      //anniversary section
                      if (partner != null && partner?.anniversaryDate != null)
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
                                targetDate:
                                    partner?.anniversaryDate ?? DateTime.now(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                //Relationship suggestions
                SizedBox(height: 14.h),
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
            ),
          ),
        ),
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
    String imageUrl = 'https://picsum.photos/200/300';
    if (suggestion['imageUrl'] != null) {
      imageUrl = suggestion['imageUrl'] as String;
    }
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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 132.h,
              width: double.infinity,
              color: Colors.grey,
              child: Image.network(
                imageUrl,
                height: 132..h,
                width: double.infinity,
                fit: BoxFit.cover,
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
