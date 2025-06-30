import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/view/home/widgets/user_content.dart';
import 'package:sage/view/home/widgets/user_not_available.dart';
import 'package:sage/view/home/widgets/vertical_dashed_divider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyUser = UserModel(
      location: Location(city: "Lahore", state: "Punjab", country: "Pakistan"),
      id: "1",
      name: "Sarah Ali",
      email: "sarah@example.com",
      password: "password",
      verified: true,
      interests: ["Cooking", "Traveling", "Hiking", "Reading", "Photography"],
      giftPreferences: ["Books", "Perfume", "Flowers", "Chocolates", "Gadgets"],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      anniversaryDate: DateTime(2022, 5, 20),
      apologyLanguage: "Accepting Responsibility",
      budgetLevel: "Moderate",
      communicationStyle: "Assertive",
      dateOfBirth: DateTime(1995, 3, 14),
      image: 'https://picsum.photos/200',
      loveLanguage: "Quality Time",
      relationshipStatus: "Engaged",
    );

    return LightStatusBar(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100.w,
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Assets.images.logo.logoHorizontal.svg(),
          ),
          actions: [
            Assets.icons.points.svg(),
            Text(" 500pts"),
            IconButton(
              onPressed: () {},
              icon: Assets.icons.notification.svg(),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 21.h),
                // height: 421.h,
                decoration: BoxDecoration(
                  color: context.colors.greenBg,
                  borderRadius:
                      BorderRadius.circular(AppRadiuses.extraLargeRadius),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 👤 User Section
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: UserContentWidget(user: dummyUser),
                        ),
                      ),

                      // 🔸 Dashed Divider
                      VerticalDashedDivider(
                        height: double.infinity,
                        dashHeight: 4,
                        dashSpacing: 4,
                        color: context.colors.yellow,
                      ),

                      // 👤 Partner Section (Currently Not Available)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppRadiuses.hundredRadius),
                                child: Container(
                                  height: 60.w,
                                  width: 60.w,
                                  color: Colors.white.withOpacity(0.2),
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
                                  color: context.colors.white.withOpacity(0.1)),
                              const UserNotAvailableWidget(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
