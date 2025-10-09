import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/services/session_manager/session_controller.dart';
// import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/view/ideas/explore_ideas.dart';
import 'package:sage/view/ideas/saved_ideas.dart';

class IdeaScreen extends StatefulWidget {
  const IdeaScreen({super.key});

  @override
  State<IdeaScreen> createState() => _IdeaScreenState();
}

class _IdeaScreenState extends State<IdeaScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionController = SessionController();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Ideas',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          actions: [
            // MyTextButton(
            //   label: 'My Added Ideas',
            //   isDark: false,
            //   onPressed: () {
            //     final isPremium = sessionController.user!.isPremium;

            //     if (!isPremium!) {
            //       IdeasServices.showSubscriptionDialog(context);
            //     } else {
            //       IdeasServices.gotoMyAddedIdeas(context);
            //     }
            //   },
            // ),
            IconButton(
              onPressed: () {
                final isPremium = sessionController.user!.isPremium;

                if (!isPremium!) {
                  IdeasServices.showSubscriptionDialog(context);
                } else {
                  IdeasServices.gotoMyAddedIdeas(context);
                }
              },
              icon: Icon(
                Icons.add_circle,
                size: 28.w,
                color: context.colors.mainGreenLight,
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
          ],
          centerTitle: true,
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: context.colors.mainGreenLight,
              indicatorWeight: 2.5,
              labelColor: context.colors.mainGreenLight,
              unselectedLabelColor: Colors.grey[700],
              labelStyle:
                  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Explore Ideas'),
                Tab(text: 'Saved Ideas'),
              ],
            ),
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    // Center(child: Text("Explore Ideas Content")),
                    ExploreIdeasScreen(),
                    SavedIdeasScreen(
                      loadOnTabChanged: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
