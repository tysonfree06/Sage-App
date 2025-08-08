import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/view/ideas/widgets/idea_card.dart';

class MyAddedIdeasScreen extends StatefulWidget {
  const MyAddedIdeasScreen({super.key});

  @override
  State<MyAddedIdeasScreen> createState() => _MyAddedIdeasScreenState();
}

class _MyAddedIdeasScreenState extends State<MyAddedIdeasScreen> {
  List<dynamic> addedIdeas = [];

  bool isLoaded = false;

  Future<void> fetchMyAddedIdeas() async {
    debugPrint('FETHING MY ADDED IDEAS...');
    final response = await IdeasServices().getAddedIdeas();
    if (mounted) {
      setState(() {
        addedIdeas = response['data'] as List<dynamic>;
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMyAddedIdeas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: context.colors.mainGreenLight),
        title: Text(
          'My Added ideas',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: isLoaded
          ? ListView(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                if (addedIdeas.isNotEmpty)
                  ...addedIdeas.map(
                    (item) {
                      return IdeaCard(
                        isAddedIdeaScreen: true,
                        showOptionsButton: false,
                        data: item as Map<String, dynamic>,
                        onReturnFromDetails: () async {
                          await fetchMyAddedIdeas();
                        },
                      );
                    },
                  )
                else
                  //no item
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250.h,
                        ),
                        Assets.icons.noItems.svg(),
                        const SizedBox(height: 16),
                        const Text(
                          'No ideas added yet!!',
                        ),
                      ],
                    ),
                  ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: IconButton(
        onPressed: () async {
          await IdeasServices.gotoAddIdea(context);
          await fetchMyAddedIdeas();
        },
        icon: CircleAvatar(
          radius: 30.r,
          backgroundColor: context.colors.mainGreenLight,
          child: Assets.icons.addFilled.svg(height: 35.h),
        ),
      ),
    );
  }
}
