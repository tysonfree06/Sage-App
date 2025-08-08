import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/view/ideas/widgets/idea_card.dart';
import 'package:sage/view/ideas/widgets/idea_label.dart';

class ExploreIdeasScreen extends StatefulWidget {
  const ExploreIdeasScreen({super.key});
  @override
  State<ExploreIdeasScreen> createState() => _ExploreIdeasScreenState();
}

class _ExploreIdeasScreenState extends State<ExploreIdeasScreen> {
  bool isLoaded = false;
  Map<String, dynamic> feed = {}; //for api
  List<dynamic> topPicks = [];
  List<dynamic> moreIdeas = [];
  final searchController = TextEditingController();

  Future<void> loadFeed() async {
    if (feed.isEmpty) {
      setState(() {
        isLoaded = false;
      });
    }

    final response = await IdeasServices().getFeed();
    if (mounted) {
      setState(() {
        isLoaded = true;
        feed = response as Map<String, dynamic>;
        topPicks = response['topPicks'] as List<dynamic>;
        moreIdeas = response['moreIdeas'] as List<dynamic>;
      });
    }
  }

  void resetFeed() {
    setState(() {
      topPicks = feed['topPicks'] as List<dynamic>;
      moreIdeas = feed['moreIdeas'] as List<dynamic>;
    });
  }

  // void searchFilter(
  //   String keyword,
  // ) {
  //   resetFeed();
  //   final List<dynamic> topPicksFiltered =
  //       topPicks.where((item) => item['title'] == keyword).toList();
  //   final List<dynamic> moreIdeasFiltered = moreIdeas
  //       .where((item) => item['title'].toString().contains(keyword))
  //       .toList();

  //   setState(() {
  //     topPicks = topPicksFiltered;
  //     moreIdeas = moreIdeasFiltered;
  //   });
  // }

  void searchFilter(String query) {
    resetFeed();
    final List<dynamic> topPicksFiltered = topPicks
        .where((item) => (item['title'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()),)
        .toList();

    final List<dynamic> moreIdeasFiltered = moreIdeas
        .where((item) => (item['title'] as String)
            .toLowerCase()
            .contains(query.toLowerCase()),)
        .toList();

    setState(() {
      topPicks = topPicksFiltered;
      moreIdeas = moreIdeasFiltered;
    });
  }

  //filter by category
  void filterByCategory(
    String category,
  ) {
    resetFeed();
    final List<dynamic> topPicksFiltered =
        topPicks.where((item) => item['type'] == category).toList();
    final List<dynamic> moreIdeasFiltered =
        moreIdeas.where((item) => item['type'] == category).toList();

    setState(() {
      topPicks = topPicksFiltered;
      moreIdeas = moreIdeasFiltered;
    });
  }
  //END: filter by category

  @override
  void initState() {
    super.initState();
    loadFeed();
  }

  final sessionController = SessionController();

  @override
  Widget build(BuildContext context) {
    final isPremium = sessionController.user!.isPremium;

    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Gift',
        'image': Assets.images.giftCategory.path,
      },
      {
        'name': 'Activity',
        'image': Assets.images.activityCategory.path,
      },
      {
        'name': 'Restaurant',
        'image': Assets.images.restaurantCategory.path,
      },
      {
        'name': 'Travel',
        'image': Assets.images.travelCategory.path,
      },
    ];

    // final List<String> topPicks = [
    //   'Love Jar Kit',
    //   '1st Birthday Gift',
    //   'Food',
    //   'Test Top Pick',
    //   'Another Top Pick',
    // ];

    return isLoaded
        ? ListView(
            children: [
              SizedBox(height: 16.h),
              if (isPremium == true) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: MyFormTextField(
                    controller: searchController,
                    hint: 'Search Ideas',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 24.w,
                      color: Colors.teal.shade400, // similar to the image
                    ),
                    onChanged: searchFilter,
                  ),
                ),
              ],
              //END: search box
              SizedBox(height: 20.h),
              _buildCategories(categories),
              if (topPicks.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    'Top Picks',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
                  ),
                ),
                SizedBox(height: 5.h),
                _buildTopPicks(topPicks),
              ],
              if (moreIdeas.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    'More Ideas',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
                  ),
                ),
                SizedBox(height: 5.h),
                //More Ideas
                ...moreIdeas.map(
                  (item) {
                    return IdeaCard(
                      onBookmarkPressed: () async {
                        await loadFeed();
                      },
                      data: item as Map<String, dynamic>,
                    );
                  },
                ),
              ],
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              color: context.colors.textLightGreen,
            ),
          );
  }

  int? selectedIndex;
  Widget _buildCategories(List<Map<String, dynamic>> categories) {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        padding: EdgeInsets.only(left: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          //Long way
          // bool isSelected = false;
          // if (selectedIndex == index) {
          //   isSelected = true;
          // }
          //END: Long way
          return GestureDetector(
            onTap: () {
              setState(() {
                if (selectedIndex == index) {
                  // Already selected -> reset
                  selectedIndex = null;
                  resetFeed();
                } else {
                  // New selection
                  selectedIndex = index;
                  //filter by category
                  filterByCategory(categories[index]['name'] as String);
                }
              });
            },
            child: CircleAvatar(
              backgroundColor: context.colors.white,
              // backgroundImage:
              //     const NetworkImage('https://picsum.photos/200/300'),
              backgroundImage: AssetImage(categories[index]['image'] as String),
              radius: 40.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? const Color.fromARGB(255, 193, 193, 193)
                            : Colors.transparent,
                        width: 5.w,
                      ),
                      borderRadius: BorderRadius.circular(150.r),
                    ),
                  ),
                  Text(
                    categories[index]['name'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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

  SizedBox _buildTopPicks(List<dynamic> topPicks) {
    final isPremium = sessionController.user!.isPremium;
    return SizedBox(
      height: 257.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: topPicks.length,
        itemBuilder: (context, index) {
          final userId = sessionController.user?.id;
          final List<dynamic> savedBy =
              topPicks[index]['savedBy'] as List<dynamic>? ?? [];
          final bool isBookmarked = savedBy.contains(userId.toString());
          final String imageUrl = topPicks[index]['image'].toString();
          return SizedBox(
            width: 182.w,
            child: Card(
              color: Colors.white,
              // margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  12.r,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with category pill
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl.isNotEmpty && imageUrl != 'null'
                              ? Image.network(
                                  imageUrl,
                                  height: 127.h,
                                  width: 152.w,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey,
                                  width: 152.w,
                                  height: 127.h,
                                ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IdeaTag(
                            label: topPicks[index]['type'].toString(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      topPicks[index]['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                    ),

                    Row(
                      children: [
                        Assets.icons.locationGrey.svg(),
                        SizedBox(
                          width: 2.w,
                        ),
                        Expanded(
                          child: Text(
                            topPicks[index]['location'] as String,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      // ignore: avoid_dynamic_calls
                      r'$' + topPicks[index]['cost'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.colors.textDarkGreen,
                        fontSize: 11.sp,
                      ),
                    ),

                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            if (!isPremium!) {
                              IdeasServices.showSubscriptionDialog(context);
                            } else {
                              if (isBookmarked) {
                                await IdeasServices().removeBookmark(
                                  context,
                                  topPicks[index]['_id'] as String,
                                );
                                await loadFeed();
                              } else {
                                await IdeasServices().addBookmark(
                                  context,
                                  topPicks[index]['_id'] as String,
                                );
                                await loadFeed();
                              }
                            }
                          },
                          // child: Assets.icons.bookmark.svg(),
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: isBookmarked
                                ? Assets.icons.bookmarkFilled.svg(height: 18)
                                : Assets.icons.bookmark.svg(height: 17),
                          ),
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            IdeasServices.showIdeaSheet(
                              context,
                              topPicks[index]['_id'] as String,
                              loadFeed,
                              () {},
                              isBookmarked: isBookmarked,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Assets.icons.threeDots.svg(),
                          ),
                        ),
                        SizedBox(
                          width: 38.w,
                        ),
                        MyTextButton(
                          onPressed: () => IdeasServices.gotoIdeaDetails(
                            context,
                            isAddedIdea: false,
                            ideaDetails:
                                topPicks[index] as Map<String, dynamic>,
                          ),
                          fontSize: 12.sp,
                          label: 'View Details',
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
