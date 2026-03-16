/*
  NOTE:AutomaticKeepAliveClientMixin is used to keep the state of the widget
  alive when navigating away from it.
  This is useful for maintaining the state of the ExploreIdeasScreen when 
  navigating to other screens and returning back to it, preventing the need
  to reload the data.
*/

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/free_user_alert.dart';
import 'package:sage/app/components/global_unfocus_keyboard.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/components/profile_incomplete_alert.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
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

class _ExploreIdeasScreenState extends State<ExploreIdeasScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isLoaded = false;
  Map<String, dynamic> feed = {}; //for api
  List<dynamic> topPicks = [];
  List<dynamic> moreIdeas = [];
  final searchController = TextEditingController();
  bool noResults = false;

  Future<void> loadFeed() async {
    try {
      if (feed.isEmpty) {
        if (mounted) {
          setState(() {
            isLoaded = false;
          });
        }
      }

      final response = await IdeasServices().getFeed(context);
      if (mounted) {
        setState(() {
          isLoaded = true;
          feed = response as Map<String, dynamic>;
          topPicks = response['topPicks'] as List<dynamic>;
          moreIdeas = response['moreIdeas'] as List<dynamic>;
        });
      }
    } catch (e) {
      debugPrint('Failed to load feed Error: $e');
      if (mounted) {
        context.flushBarErrorMessage(message: 'Something went wrong..');
      }
    }
  }

  void resetFeed() {
    if (mounted) {
      setState(() {
        topPicks = feed['topPicks'] as List<dynamic>;
        moreIdeas = feed['moreIdeas'] as List<dynamic>;
      });
    }
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
        .where(
          (item) => (item['title'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();

    final List<dynamic> moreIdeasFiltered = moreIdeas
        .where(
          (item) => (item['title'] as String)
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
    if (mounted) {
      setState(() {
        topPicks = topPicksFiltered;
        moreIdeas = moreIdeasFiltered;
      });
    }

    if (topPicksFiltered.isEmpty && moreIdeasFiltered.isEmpty) {
      if (mounted) {
        setState(() {
          noResults = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          noResults = false;
        });
      }
    }
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

    if (mounted) {
      setState(() {
        topPicks = topPicksFiltered;
        moreIdeas = moreIdeasFiltered;
      });
    }
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
    super.build(context); // 👈 required for keep alive
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
        ? GlobalUnfocusKeyboard(
            child: ListView(
              children: [
                SizedBox(height: 16.h),
                //profile completion status will be checked
                //within the widget
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: const ProfileIncompleteAlert(),
                ),
                SizedBox(height: 10.h),
                if (isPremium != null && isPremium == true)
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
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const FreeUserAlert(
                      title: 'Get More Ideas!',
                      subtitle:
                          '''You are not subscribed, so you can only see 5 ideas per day. Upgrade now to see more ideas!''',
                      buttonText: 'Unlock more Ideas',
                    ),
                  ),
                //END: search box

                SizedBox(height: 20.h),
                _buildCategories(categories),
                if (moreIdeas.isEmpty && topPicks.isEmpty) ...[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80.h,
                        ),
                        Assets.icons.noItems.svg(),
                        const SizedBox(height: 16),
                        const Text(
                          'No Ideas Today!',
                        ),
                      ],
                    ),
                  ),
                ],
                if (noResults == false) ...[
                  if (topPicks.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        'Top Picks',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
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
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    //More Ideas
                    ...moreIdeas.map(
                      (item) {
                        return IdeaCard(
                          // onBookmarkOrDislikePressed: () async {
                          //   await loadFeed();
                          // },
                          onBookmarkOrDislikePressed: loadFeed,
                          onReturnFromDetails: () {
                            loadFeed();
                            debugPrint('ON RETURN FROM DETAILS CALLED');
                          },
                          data: item as Map<String, dynamic>,
                        );
                      },
                    ),
                  ],
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 140.h,
                        ),
                        Text(
                          'No results...',
                          style: TextStyle(fontSize: 14.h),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          )
        : const Center(
            child: LoadingWidget(),
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
              if (mounted) {
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
              }
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
                            // ? const Color.fromARGB(255, 193, 193, 193)
                            ? context.colors.mainGreenLight.withValues(
                                alpha: 0.7,
                              )
                            : Colors.transparent,
                        width: 4.w,
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
    return SizedBox(
      height: 265.h,
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

          return GestureDetector(
            onTap: () async {
              await _gotoIdeaDetails(context, topPicks, index);
            },
            child: SizedBox(
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
                            // child: imageUrl.isNotEmpty && imageUrl != 'null'
                            //     ?
                            // child: Image.network(
                            //   imageUrl,
                            //   height: 127.h,
                            //   width: 152.w,
                            //   fit: BoxFit.cover,
                            //   errorBuilder: (context, error, stackTrace) =>
                            //       Container(
                            //     color: context.colors.white,
                            //     width: 152.w,
                            //     height: 127.h,
                            //   ),
                            // ),
                            //TODO: replace with network image above (on client's go ahead)
                            child: Container(
                              color: context.colors.mainGreenLight
                                  .withValues(alpha: 0.2),
                              height: 127.h,
                              width: 152.w,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                              ),
                              // child: Image.asset(
                              //   Assets.images.logo.launcherIcon.path,
                              //   fit: BoxFit.contain,
                              //   errorBuilder: (context, error, stackTrace) =>
                              //       Container(
                              //     color: context.colors.white,
                              //     width: 152.w,
                              //     height: 127.h,
                              //   ),
                              // ),
                              child: Assets.images.logo.logoHorizontal.svg(),
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
                                fontWeight: FontWeight.w700,
                              ),
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
                              final isPremium =
                                  sessionController.user!.isPremium;
                              if (!isPremium!) {
                                IdeasServices.showSubscriptionDialog(context);
                              } else {
                                if (isBookmarked) {
                                  // setState(() {
                                  //   isBookmarked = false;
                                  // });
                                  await IdeasServices().removeBookmark(
                                    context,
                                    topPicks[index]['_id'] as String,
                                  );
                                  await loadFeed();
                                } else {
                                  // setState(() {
                                  //   isBookmarked = true;
                                  // });
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
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              child: isBookmarked
                                  ? Assets.icons.bookmarkFilled.svg(height: 18)
                                  : Assets.icons.bookmark.svg(height: 17),
                            ),
                          ),
                          SizedBox(
                            width: 3.w,
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
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              width: 24.w,
                              height: 20.h,
                              child: Assets.icons.threeDots.svg(),
                            ),
                          ),
                          const Spacer(),
                          MyTextButton(
                            onPressed: () async {
                              await _gotoIdeaDetails(context, topPicks, index);
                            },
                            fontSize: 12.sp,
                            label: 'View Details',
                          ),
                        ],
                      ),
                    ],
                  ),
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

  //for top picks
  Future<void> _gotoIdeaDetails(
    BuildContext context,
    List<dynamic> topPicks,
    int index,
  ) async {
    await IdeasServices.gotoIdeaDetails(
      context,
      isAddedIdea: false,
      ideaDetails: topPicks[index] as Map<String, dynamic>,
    ).then((_) {
      loadFeed();
    });
  }
}
