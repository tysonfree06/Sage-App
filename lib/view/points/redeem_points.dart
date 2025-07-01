import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';

class RedeemPointsScreen extends StatelessWidget {
  const RedeemPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.white,
      appBar: AppBar(
        title: Text(context.l10n.redeem_point_topbar_title),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 130.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.images.redeemPointBg.path),
                  fit: BoxFit.cover,
                ),
                color: context.colors.greenBg,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
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
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                                color: context.colors.yellow,
                              ),
                            ),
                            // SizedBox(height: 5.h),
                            Text(
                              context.l10n.redeem_total_points,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color:
                                    context.colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                  Divider()
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const Text(
                  //       'Invite your friends to earn more points',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w400,
                  //         fontSize: 12,
                  //         color: Colors.white70,
                  //       ),
                  //     ),
                  //     OutlinedButton(
                  //       onPressed: () {},
                  //       style: OutlinedButton.styleFrom(
                  //         side: const BorderSide(color: Color(0xFFD3CF8B)),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(16.r),
                  //         ),
                  //         minimumSize: Size(70.w, 30.h),
                  //         padding: EdgeInsets.symmetric(horizontal: 8.w),
                  //       ),
                  //       child: const Text(
                  //         'Invite',
                  //         style: TextStyle(
                  //           color: Color(0xFFD3CF8B),
                  //           fontWeight: FontWeight.w500,
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
