import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';

class IdeaSheet extends StatelessWidget {
  const IdeaSheet({
    required this.isBookmarked,
    required this.ideaId,
    super.key,
    this.onBookmarkPressedInSheet,
  });
  final bool isBookmarked;
  final String ideaId;
  final VoidCallback? onBookmarkPressedInSheet;

  @override
  Widget build(BuildContext context) {
    final sessionController = SessionController();
    final isPremium = sessionController.user!.isPremium;
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (!isPremium!) {
                IdeasServices.showSubscriptionDialog(context);
              } else {
                if (isBookmarked) {
                  IdeasServices().removeBookmark(
                    context,
                    ideaId,
                  );
                } else {
                  IdeasServices().addBookmark(
                    context,
                    ideaId,
                  );
                }
                onBookmarkPressedInSheet?.call();
                Navigator.of(context).pop();
              }
            },
            child: Row(
              children: [
                if (isBookmarked)
                  Assets.icons.bookmarkFilled.svg(height: 22.h)
                else
                  Assets.icons.bookmark.svg(height: 20.h),
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  !isBookmarked ? 'Save To Ideas' : 'Remove from Ideas',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          GestureDetector(
            onTap: () {
              IdeasServices().dislikeIdea(
                context,
                ideaId,
              );
              onBookmarkPressedInSheet?.call();
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Assets.icons.dislike.svg(height: 24),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  "I'm not interested",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
        ],
      ),
    );
  }
}
