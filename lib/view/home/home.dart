import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/auth_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
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
  final AuthRepository _userAuth = AuthRepository();

  UserModel? partner;

  Future<void> getPartner() async {
    if (!SessionController().isPartnerFetched) {
      final String partnerCode = _sessionController.user?.partnerCode ?? '';
      try {
        final response = await _userAuth.getPartner(partnerCode);
        setState(() {
          partner = UserModel.fromJson(
            response['partner'] as Map<String, dynamic>,
          );
          SessionController().partner = UserModel.fromJson(
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

  @override
  void initState() {
    super.initState();
    getPartner();
  }

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
            const Text(' 500pts'),
            IconButton(
              onPressed: () {},
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
                                      : const PartnerUnavailable(),
                                ),
                              )
                            else
                              const PartnerUnavailable(),
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
                                // targetDate: DateTime(2025, 12, 31, 23, 59, 59),
                                targetDate:
                                    partner?.anniversaryDate ?? DateTime.now(),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // SizedBox(height: 14.h),
                // Text(
                //   'Relationship Suggestions',
                //   style: context.typography.title.copyWith(
                //     fontWeight: FontWeight.w700,
                //     fontSize: 20.sp,
                //     color: context.colors.textDarkGreen,
                //   ),
                // ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PartnerUnavailable extends StatelessWidget {
  const PartnerUnavailable({
    super.key,
  });

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
            const UserNotAvailableWidget(),
          ],
        ),
      ),
    );
  }
}
