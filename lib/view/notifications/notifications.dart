import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/notifications_services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isLoaded = false;
  final sessionController = SessionController();
  final NotificationsServices _notificationServices = NotificationsServices();
  late List<dynamic> notificationsList;

  void getNotificationsFromSession() {
    notificationsList = sessionController.notifications ?? [];
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  Future<void> markRead() async {
    await _notificationServices.markNotificationsRead();
  }

  @override
  void initState() {
    super.initState();
    getNotificationsFromSession();
    markRead();
    // fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: context.colors.mainGreenLight,
        ),
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: isLoaded
            ? notificationsList.isEmpty
                ? _buildEmptyNotifications(context)
                : ListView(
                    children: notificationsList
                        .map(
                          (notification) => NotificationTile(
                            notification: notification,
                          ),
                        )
                        .toList(),
                  )
            : const Center(
                child: LoadingWidget(),
              ),
      ),
    );
  }

  Center _buildEmptyNotifications(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.noNotifications.svg(
            width: 100.w,
            height: 100.h,
          ),
          SizedBox(height: 16.h),
          Text(
            'No New Notifications!!',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    required this.notification,
    super.key,
  });
  final dynamic notification;
  @override
  Widget build(BuildContext context) {
    Widget notificationIcon = Assets.images.logo.greenLogo.svg();
    //icon condition
    switch (notification['type']) {
      case 'partner_added':
        notificationIcon = Assets.icons.user.svg(
          color: context.colors.greenBg,
        );
      case 'partner_removed':
        notificationIcon = Assets.icons.user.svg(
          color: context.colors.greenBg,
        );
      case 'daily_tip':
        notificationIcon = Assets.icons.ideaSelected.svg(
          color: context.colors.greenBg,
        );
      case 'anniversary':
        notificationIcon = Assets.icons.calander.svg(
          color: context.colors.greenBg,
        );
      case 'points_earned':
        notificationIcon = Image.asset(Assets.icons.pointsPng.path);
      case 'mutual_saved_idea':
        notificationIcon = Assets.icons.ideaSelected.svg(
          color: context.colors.greenBg,
        );
      case 'welcome':
        notificationIcon = Assets.images.logo.greenLogo.svg();
      case 'add_partner':
        notificationIcon = Assets.icons.user.svg(
          color: context.colors.greenBg,
        );
      case 'gift_ideas':
        notificationIcon = Assets.icons.ideaSelected.svg(
          color: context.colors.greenBg,
        );
      case 'redeem_offer':
        notificationIcon = Assets.icons.starGreen.svg(
          color: context.colors.greenBg,
        );
      default:
        notificationIcon = Assets.images.logo.greenLogo.svg();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            // child: Icon(
            //   notificationIcon,
            //   color: context.colors.greenBg,
            // ),
            child: notificationIcon,
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 14,
                      child: Text(
                        maxLines: 2,
                        // ignore: avoid_dynamic_calls
                        notification['title'] as String,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 9,
                      child: Text(
                        NotificationsServices.getTimeAgo(
                          // ignore: avoid_dynamic_calls
                          notification['createdAt'] as String,
                        ),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  // ignore: avoid_dynamic_calls
                  notification['message'] as String,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
