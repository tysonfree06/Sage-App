import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';

class ExploreIdeasScreen extends StatefulWidget {
  const ExploreIdeasScreen({super.key});

  @override
  State<ExploreIdeasScreen> createState() => _ExploreIdeasScreenState();
}

class _ExploreIdeasScreenState extends State<ExploreIdeasScreen> {
  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Gifts',
      'Activities',
      'Food',
      'Travel',
      'Gifts',
      'Activities',
      'Food',
    ];

    final List<String> topPicks = [
      'Love Jar Kit',
      '1st Birthday Gift',
      'Food',
      'Test Top Pick',
      'Another Top Pick',
    ];

    final List<String> moreGifts = [
      'Couple Portraitt',
      'Subscription Box',
      'Subscription Boxx',
      'Couple Portrait',
    ];
    // return Center(
    //   child: Text('Explore Ideas Screen'),
    // );
    return ListView(
      children: [
        _buildCategories(categories),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text(
            'Top Picks',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
          ),
        ),
        SizedBox(height: 5.h),
        _buildTopPicks(topPicks),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: Text(
            'More Gifts',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
          ),
        ),
        SizedBox(height: 5.h),
        ...moreGifts.map((item) {
          return const MoreGiftsCard();
        }),
      ],
    );
  }

  Widget _buildCategories(List<String> categories) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CircleAvatar(
            backgroundColor: Colors.green,
            radius: 40.w,
            child: Text(
              categories[index],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 9.w);
        },
      ),
    );
  }

  SizedBox _buildTopPicks(List<String> topPicks) {
    return SizedBox(
      height: 310.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: topPicks.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 190.w,
            child: Card(
              // margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with category pill
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://picsum.photos/200/300',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Positioned(
                          bottom: 8,
                          left: 8,
                          child: IdeaLabel(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Love Jar Kit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Pg 232, block 07, Johar town...',
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      '\$120.00',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Assets.icons.bookmark.svg(),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View Details',
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 5.w);
        },
      ),
    );
  }
}

class IdeaLabel extends StatelessWidget {
  const IdeaLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.shade600,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Emotions',
        style: TextStyle(
          color: context.colors.yellow,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }
}

//more gifts widget
class MoreGiftsCard extends StatelessWidget {
  const MoreGiftsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: SizedBox(
        height: 148.h,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with category pill
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://picsum.photos/200/300',
                    height: 120.h,
                    width: 117.w,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IdeaLabel(),
                    SizedBox(height: 8.h),
                    const Text(
                      'Couple Portrait',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    //
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4.w),
                        SizedBox(
                          width: 160.w,
                          child: Text(
                            'Pg 232, block 07, Johar town, Lahore, Pakistan',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    //
                    SizedBox(height: 8.h),
                    Text(
                      r'$120.00',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Assets.icons.bookmark.svg(),
                        const SizedBox(
                          width: 100,
                        ),
                        MyTextButton(
                          label: 'View Details',
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
