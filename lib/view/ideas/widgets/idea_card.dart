import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/view/ideas/widgets/idea_label.dart';

class IdeaCard extends StatefulWidget {
  const IdeaCard({
    required this.data,
    this.showOptionsButton = true,
    this.isAddedIdeaScreen = false,
    this.onBookmarkPressed,
    this.onReturnFromDetails,
    super.key,
  });
  final bool showOptionsButton;
  final Map<String, dynamic> data;
  final bool isAddedIdeaScreen;
  final VoidCallback? onBookmarkPressed;
  final VoidCallback?
      onReturnFromDetails; //this function is used when user deltes an idea, it is required to load the previous screen

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard> {
  @override
  Widget build(BuildContext context) {
    final sessionController = SessionController();

    final userId = sessionController.user?.id;
    final List<dynamic> savedBy =
        widget.data['savedBy'] as List<dynamic>? ?? [];

    final String imageUrl = widget.data['image'].toString();

    final bool isBookmarked = savedBy.contains(userId.toString());

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: SizedBox(
        height: 152.h,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with category pill
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: imageUrl.isNotEmpty ||
                          imageUrl == 'null' //don't remove it
                      ? Image.network(
                          // 'https://picsum.photos/200/300',
                          imageUrl,
                          height: 116.h,
                          width: 113.w,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey,
                          width: 113.w,
                          height: 116.h,
                        ),
                ),

                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: 185.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IdeaTag(
                            label: widget.data['type'].toString(),
                          ),
                          if (widget.showOptionsButton)
                            Padding(
                              padding: EdgeInsets.only(right: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  IdeasServices.showIdeaSheet(
                                    context,
                                    widget.data['_id'] as String,
                                    () {
                                      widget.onBookmarkPressed?.call();
                                    },
                                    () {},
                                    isBookmarked: isBookmarked,
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 18.w,
                                  height: 16.h,
                                  child:
                                      Assets.icons.threeDots.svg(height: 14.h),
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 160.w,
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        widget.data['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    //
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.icons.locationGrey.svg(),
                        SizedBox(
                          width: 2.w,
                        ),
                        SizedBox(
                          width: 160.w,
                          child: Text(
                            widget.data['location'] == null
                                ? ''
                                : widget.data['location'] as String,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    //
                    SizedBox(height: 8.h),
                    Text(
                      widget.data['cost'] == null
                          ? r'$0'
                          : r'$' + widget.data['cost'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: context.colors.textDarkGreen,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!widget.isAddedIdeaScreen) ...[
                          //InkWell as a replacement to Gesture Detector
                          InkWell(
                            onTap: () async {
                              final isPremium =
                                  sessionController.user!.isPremium;
                              if (!isPremium!) {
                                IdeasServices.showSubscriptionDialog(context);
                              } else {
                                if (isBookmarked) {
                                  await IdeasServices().removeBookmark(
                                    context,
                                    widget.data['_id'] as String,
                                  );
                                  widget.onBookmarkPressed?.call();
                                } else {
                                  await IdeasServices().addBookmark(
                                    context,
                                    widget.data['_id'] as String,
                                  );
                                  widget.onBookmarkPressed?.call();
                                }
                                debugPrint('Bookmark icon tapped!');
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(2.w),
                              child: isBookmarked
                                  ? Assets.icons.bookmarkFilled.svg(height: 18)
                                  : Assets.icons.bookmark.svg(height: 17),
                            ),
                          ),
                          SizedBox(
                            width: 100.w,
                          ),
                        ] else
                          const SizedBox.shrink(),
                        MyTextButton(
                          label: 'View Details',
                          fontSize: 12.sp,
                          onPressed: () async {
                            await IdeasServices.gotoIdeaDetails(
                              context,
                              isAddedIdea: widget.isAddedIdeaScreen,
                              ideaDetails: widget.data,
                              callBackFlag: false,
                            );
                            widget.onReturnFromDetails?.call();
                          },
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
