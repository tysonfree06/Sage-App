import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/views/notifications_services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isLoaded = false;
  final NotificationsServices _notificationServices = NotificationsServices();
  List<dynamic> notificationsList = [];

  Future<void> fetchNotifications() async {
    final response = await _notificationServices.getNotifications();
    notificationsList = response['data'] as List<dynamic>;
    if (mounted) {
      setState(() {
        isLoaded = true;
      });
    }
    debugPrint('Notifications refreshed: $notificationsList');
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }
  // final List<Map<String, dynamic>> notificationsList = [
  //   {
  //     '_id': '687f78c5ba2510dfeb34d437',
  //     'userId': '687f77a6ba2510dfeb34d434',
  //     'title': 'Welcome to Sage',
  //     'message':
  //         'Sage: The future of healthy relationshipts start exploring ideas',
  //     // "icon": "🔔",
  //     'icon': Icons.notifications_active,
  //     'isRead': true,
  //     'createdAt': '2025-09-02T15:30:00.000Z',
  //     '__v': 0,
  //   },
  //   {
  //     '_id': '687f78c5ba2510dfeb34d437',
  //     'userId': '687f77a6ba2510dfeb34d434',
  //     'title': 'New Gift Ideas',
  //     'message': 'Hey, we have some new gift ideas for you go and check',
  //     // "icon": "🔔",
  //     'icon': Icons.notifications_active_outlined,
  //     'isRead': true,
  //     'createdAt': '2025-08-03T14:25:00.000Z',
  //     '__v': 0,
  //   },
  //   {
  //     '_id': '687f78c5ba2510dfeb34d437',
  //     'userId': '687f77a6ba2510dfeb34d434',
  //     'title': 'Add Your Partner',
  //     'message':
  //         'Hey, it looks like you have not added your partner add your',
  //     // "icon": "🔔",
  //     'icon': Icons.notifications_active_outlined,
  //     'isRead': true,
  //     'createdAt': '2025-03-02T15:30:00.000Z',
  //     '__v': 0,
  //   },
  //   {
  //     '_id': '687f78c5ba2510dfeb34d437',
  //     'userId': '687f77a6ba2510dfeb34d434',
  //     'title': 'New Gift Ideas',
  //     'message': 'Hey, we have some new gift ideas for you go and check',
  //     // "icon": "🔔",
  //     'icon': Icons.notifications_active_outlined,
  //     'isRead': true,
  //     'createdAt': '2024-08-02T15:30:00.000Z',
  //     '__v': 0,
  //   },
  //   // Add more notifications here
  // ];

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
            : Center(
                child: CircularProgressIndicator(
                  color: context.colors.mainGreenLight,
                ),
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
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.notifications_active,
              color: context.colors.greenBg,
            ),
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
                    Text(
                      // ignore: avoid_dynamic_calls
                      notification['title'] as String,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
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
