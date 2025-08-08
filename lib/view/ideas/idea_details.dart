import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/services/views/notifications_services.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/view/ideas/widgets/idea_label.dart';

class IdeaDetailsScreen extends StatefulWidget {
  const IdeaDetailsScreen({
    this.isAddedIdea = false,
    super.key,
    this.ideaDetails,
  });
  final bool isAddedIdea;
  final Map<String, dynamic>? ideaDetails;
  @override
  State<IdeaDetailsScreen> createState() => _IdeaDetailsScreenState();
}

Future<void> deleteAddeIdea(BuildContext context, String ideaId) async {
  await IdeasServices().deleteAddedIdea(context, ideaId);
  debugPrint('DELETE IDEA: $ideaId');
}

class _IdeaDetailsScreenState extends State<IdeaDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdeasServices.buildIdeaDetailsAppBar(
        isAddedIdea: widget.isAddedIdea,
        context,
        ideaDetails: widget.ideaDetails,
        onIdeaDeletePressed: () async {
          await deleteAddeIdea(context, widget.ideaDetails?['_id'] as String);
        },
      ) as PreferredSizeWidget,
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            // Top image
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(16),
            //   child: Image.network(
            //     'https://picsum.photos/200/300',
            //     height: 190,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  if (widget.ideaDetails?['image'] != null &&
                      widget.ideaDetails?['image'] != '')
                    Image.network(
                      widget.ideaDetails?['image'] as String,
                      width: double.infinity,
                      height: 190.h,
                    ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.black38,
                    width: double.infinity,
                    height: 190.h,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tags
            Row(
              children: [
                IdeaTag(
                  fontSize: 14,
                  verticalPadding: 6,
                  label: widget.ideaDetails?['type'].toString() ?? '',
                ),
                // SizedBox(width: 8),
                // IdeaTag(
                //   fontSize: 14,
                //   verticalPadding: 6,
                // ),
              ],
            ),

            const SizedBox(height: 12),

            // Title & Price
            Text(
              widget.ideaDetails?['title'] == null
                  ? ''
                  : widget.ideaDetails?['title'] as String,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              widget.ideaDetails?['description'] == null
                  ? r'$0'
                  : '\$${widget.ideaDetails?['cost']}',
              style: TextStyle(
                fontSize: 18.sp,
                color: context.colors.textLightGreen,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 20.h),

            // Location Row
            Row(
              children: [
                Assets.icons.locationGrey.svg(
                  color: context.colors.textDarkGreen,
                  height: 16.h,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    widget.ideaDetails?['location'] == null
                        ? ''
                        : widget.ideaDetails?['location'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Link Row
            GestureDetector(
              onTap: () async {
                if (widget.ideaDetails?['link'] == null ||
                    widget.ideaDetails?['link'] == '') {
                  return;
                }
                await SettingService()
                    .sageLaunchUrl(widget.ideaDetails?['link'] as String);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    color: context.colors.textDarkGreen,
                    size: 24.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    widget.ideaDetails?['link'] == null
                        ? 'No link provided'
                        : widget.ideaDetails?['link'] as String,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: context.colors.textDarkGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              widget.ideaDetails?['description'] == null
                  ? ''
                  : widget.ideaDetails?['description'] as String,
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
            ),
            if (widget.isAddedIdea)
              MyAddedIdeaInfo(
                dateCreated: widget.ideaDetails?['createdAt'] as String,
              ),
          ],
        ),
      ),
    );
  }
}

class MyAddedIdeaInfo extends StatelessWidget {
  const MyAddedIdeaInfo({required this.dateCreated, super.key});
  final String dateCreated;

  @override
  Widget build(BuildContext context) {
    final sessionController = SessionController();
    final UserModel user = sessionController.user!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16.h,
        ),
        const Divider(),
        SizedBox(
          height: 16.h,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 25.w,
              backgroundColor: Colors.grey[200],
              backgroundImage: (user.image != null && user.image!.isNotEmpty)
                  ? NetworkImage(user.image!)
                  : null,
              child: (user.image == null || user.image!.isEmpty)
                  ? Assets.icons.user.svg(height: 40.w, width: 40.w)
                  : null,
            ),
            SizedBox(
              width: 8.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  NotificationsServices.getTimeAgo(dateCreated),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
