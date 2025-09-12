// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sage/app/components/loading_widget.dart';
// import 'package:sage/app/components/my_button.dart';
// import 'package:sage/app/components/my_dialog.dart';
// import 'package:sage/app/components/my_text_button.dart';
// import 'package:sage/app/utils/extensions/context_extensions.dart';
// import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
// import 'package:sage/generated/assets/assets.gen.dart';
// import 'package:sage/services/views/subscription_services.dart';

// class ActiveSubscriptionScreen extends StatefulWidget {
//   const ActiveSubscriptionScreen({super.key});

//   @override
//   State<ActiveSubscriptionScreen> createState() =>
//       _ActiveSubscriptionScreenState();
// }

// class _ActiveSubscriptionScreenState extends State<ActiveSubscriptionScreen> {
//   bool isLoaded = false;

//   final _subscriptionService = SubscriptionService();
//   Map<String, dynamic> subscriptionDetails = {};

//   bool isSubscriptionActive = true;

//   bool errorFetchingSubscription =
//       false; // happens when isPremium = true but no subscription in server

//   Future<void> fetchSubscription() async {
//     debugPrint('Fetching Subscription...');
//     try {
//       final response = await _subscriptionService.getSubscriptionDetails();
//       final sub = response['subscription'];

//       if (sub == null || sub is! Map<String, dynamic>) {
//         debugPrint('No active subscription found.');
//         setState(() {
//           isLoaded = true;
//           errorFetchingSubscription = true;
//         });
//         return;
//       }

//       subscriptionDetails = sub;

//       if (subscriptionDetails['cancel_at_period_end'] == true) {
//         setState(() {
//           isSubscriptionActive = false;
//         });
//       }

//       debugPrint(
//         'Subscription details fetched successfully: $subscriptionDetails',
//       );
//     } on Exception catch (e) {
//       if (mounted) {
//         debugPrint('Error fetching subscription details: $e');
//         context.flushBarErrorMessage(message: 'Something went wrong..');
//       }
//     }

//     if (mounted) {
//       setState(() {
//         isLoaded = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchSubscription();
//   }

//   String toCamelCaseWithLy(String? input) {
//     if (input == null || input.isEmpty) return 'No';
//     final camelCase = input[0].toUpperCase() + input.substring(1).toLowerCase();
//     return '${camelCase}ly';
//   }

//   String _formatSubscriptionEndDate(String? isoDate) {
//     if (isoDate == null || isoDate.isEmpty) return 'Unknown';
//     try {
//       final dateTime = DateTime.parse(isoDate);
//       final day = dateTime.day.toString().padLeft(2, '0');
//       final month = dateTime.month.toString().padLeft(2, '0');
//       final year = dateTime.year.toString();
//       return '$day/$month/$year';
//     } catch (_) {
//       return 'Unknown';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           color: context.colors.mainGreenLight,
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Subscription Plan',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: isLoaded
//           ? errorFetchingSubscription
//               ? Center(
//                   child: Text(
//                     'Something went wrong!',
//                     style: TextStyle(fontSize: 16.sp),
//                   ),
//                 )
//               : Padding(
//                   padding: EdgeInsets.all(16.w),
//                   child: ListView(
//                     children: [
//                       _subscriptionTile(context),
//                       SizedBox(height: 20.h),
//                       _planDetailsCard(
//                         context,
//                         isSubscriptionActive: isSubscriptionActive,
//                       ),
//                       SizedBox(height: 100.h),
//                       MyButton(
//                         label: isSubscriptionActive
//                             ? 'Change Membership'
//                             : 'Subscribe',
//                         onPressed: () {
//                           if (isSubscriptionActive) {
//                             showDialog<void>(
//                               context: context,
//                               builder: (_) => MyDialog(
//                                 titleFirst: 'Change ',
//                                 titleSecond: 'Subscription?',
//                                 subtitle:
//                                     '''Changing subscription will discard your current subscription.''',
//                                 confirmLabel: 'Continue',
//                                 onConfirm: () {
//                                   SubscriptionService.goToChangeSubscription(
//                                     context,
//                                   );
//                                 },
//                               ),
//                             );
//                           } else {
//                             SubscriptionService.goToChangeSubscription(context);
//                           }
//                         },
//                       ),
//                       SizedBox(height: 16.h),
//                       if ((Platform.isAndroid ||
//                               Platform.isWindows ||
//                               Platform.isLinux) &&
//                           isSubscriptionActive)
//                         MyTextButton(
//                           label: 'Cancel Membership',
//                           onPressed: () async {
//                             setState(() {
//                               isLoaded = false;
//                             });
//                             await showDialog<void>(
//                               context: context,
//                               builder: (_) => MyDialog(
//                                 titleFirst: 'Cancel ',
//                                 titleSecond: 'Subscription?',
//                                 subtitle: '''Your subscription will''',
//                                 confirmLabel: 'Cancel',
//                                 onConfirm: () {
//                                   SubscriptionService.goToChangeSubscription(
//                                     context,
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       SizedBox(height: 24.h),
//                     ],
//                   ),
//                 )
//           : const Center(
//               child: LoadingWidget(),
//             ),
//     );
//   }

//   /// Amount is returned as double (e.g. 67.99), so we handle both int/double.
//   String formatToDecimal(num? amount) {
//     if (amount == null) return '0.00';
//     return amount.toStringAsFixed(2);
//   }

//   Widget _subscriptionTile(BuildContext context) {
//     final amount = formatToDecimal(subscriptionDetails['amount'] as num?);
//     return Container(
//       decoration: BoxDecoration(
//         color: context.colors.greenBg,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       padding: EdgeInsets.all(16.w),
//       child: Row(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 11.h),
//             child: Assets.images.logo.onlyLogo.svg(width: 32, height: 32),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Subscription Plan',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   '${toCamelCaseWithLy(subscriptionDetails['interval']?.toString())} Subscription',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Text(
//             r'$' + amount,
//             style: TextStyle(
//               color: const Color.fromRGBO(243, 229, 171, 1),
//               fontWeight: FontWeight.bold,
//               fontSize: 16.sp,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _planDetailsCard(
//     BuildContext context, {
//     required bool isSubscriptionActive,
//   }) {
//     final String activeSubscriptionText =
//         '''Your plan will automatically renew on ${_formatSubscriptionEndDate(subscriptionDetails['current_period_end']?.toString())}. You can change your subscription plan after this or renew this plan.''';

//     final String canceledSubscriptionText =
//         '''Your subscription is ending on ${_formatSubscriptionEndDate(subscriptionDetails['current_period_end']?.toString())} and will not be renewed. If you want to subscribe again, please press the "Subscribe" button below.''';

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.r),
//       ),
//       padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isSubscriptionActive) ...[
//             Row(
//               children: [
//                 Text(
//                   'Subscription Status:',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 13.sp,
//                   ),
//                 ),
//                 SizedBox(width: 7.w),
//                 Assets.icons.error.svg(),
//                 SizedBox(width: 7.w),
//                 Text(
//                   'Cancelled',
//                   style: TextStyle(
//                     fontSize: 13.sp,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10.h),
//           ],
//           Text(
//             isSubscriptionActive
//                 ? activeSubscriptionText
//                 : canceledSubscriptionText,
//             style: TextStyle(fontSize: 15.sp, color: Colors.black54),
//           ),
//           SizedBox(height: 20.h),
//           Text(
//             'Plan Includes',
//             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
//           ),
//           SizedBox(height: 15.h),
//           _planBullet(
//             title: 'Discounts & Prizes for Healthy Habits:',
//             subtitle:
//                 '''Just by practicing healthy relationship habits you’ll earn points for discounts and prizes!''',
//             context: context,
//           ),
//           SizedBox(height: 12.h),
//           _planBullet(
//             title: 'Unlimited AI Generated Ideas:',
//             subtitle:
//                 '''Sage AI will use your preferences to create ideas tailored to you and your partner''',
//             context: context,
//           ),
//           SizedBox(
//             height: 42.h,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _planBullet({
//     required String title,
//     required String subtitle,
//     required BuildContext context,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(Icons.check_circle, color: context.colors.greenBg, size: 20.w),
//         SizedBox(width: 8.w),
//         Expanded(
//           child: RichText(
//             text: TextSpan(
//               text: '$title ',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54,
//                 fontSize: 14.sp,
//               ),
//               children: [
//                 TextSpan(
//                   text: subtitle,
//                   style: TextStyle(
//                     fontWeight: FontWeight.normal,
//                     color: Colors.black54,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
