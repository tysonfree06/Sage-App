import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class SubscriptionScreen extends StatelessWidget {
//   const SubscriptionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Subscription Plans'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           // Background image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/your_background_image.png', // Replace with your background image path
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           // Blurred overlay
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),
//           ),
//
//           // Content on top of the blurred background
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Subscription Options
//                 SubscriptionOption(
//                   label: 'Yearly',
//                   price: '\$67.99',
//                   discount: 60,
//                 ),
//                 SizedBox(height: 12.h),
//                 SubscriptionOption(
//                   label: 'Monthly',
//                   price: '\$6.99',
//                   discount: 50,
//                 ),
//                 SizedBox(height: 12.h),
//                 SubscriptionOption(
//                   label: 'Weekly',
//                   price: '\$2.99',
//                   discount: 0,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SubscriptionOption extends StatelessWidget {
  final String label;
  final String price;
  final int discount;

  const SubscriptionOption({
    required this.label,
    required this.price,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Radio<int>(
            value: 1,
            groupValue: null,
            onChanged: (_) {},
            activeColor: Colors.teal,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (discount > 0)
            Container(
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                '$discount%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
