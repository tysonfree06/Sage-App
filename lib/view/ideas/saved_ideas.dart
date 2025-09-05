/*
  NOTE:AutomaticKeepAliveClientMixin is used to keep the state of the widget
  alive when navigating away from it.
  This is useful for maintaining the state of the ExploreIdeasScreen when 
  navigating to other screens and returning back to it, preventing the need
  to reload the data.
*/
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/view/ideas/widgets/idea_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SavedIdeasScreen extends StatefulWidget {
  const SavedIdeasScreen({
    required this.loadOnTabChanged,
    super.key,
  });
  final bool loadOnTabChanged;
  @override
  State<SavedIdeasScreen> createState() => _SavedIdeasScreenState();
}

class _SavedIdeasScreenState extends State<SavedIdeasScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool noMineIdea = false;
  bool noMutualIdea = false;
  late List<dynamic> mineSavedIdeas = [];
  List<dynamic> mutualSavedIdeas = [];
  bool isLoaded = false;
  final sessionController = SessionController();

  Future<void> fetchSavedIdeas(String type, {bool showLoading = true}) async {
    try {
      if (showLoading) {
        setState(() {
          isLoaded = false;
        });
      }

      if (type == 'mutual') {
        if (mutualSavedIdeas.isEmpty && !noMutualIdea) {
          debugPrint('IN : mutualSavedIdeas.isEmpty && !noMutualIdea');
          final response = await IdeasServices().getSavedIdeas(type);
          if (response['ideas'] != null) {
            mutualSavedIdeas = response['ideas'] as List<dynamic>;
          }
          if (mutualSavedIdeas.isEmpty) {
            noMutualIdea = true;
          }
        }
        if (mounted) {
          setState(() {
            displaySavedIdeas = mutualSavedIdeas;
            isLoaded = true;
          });
        }
      } else {
        if (mineSavedIdeas.isEmpty && !noMineIdea) {
          final response = await IdeasServices().getSavedIdeas(type);
          mineSavedIdeas = response['ideas'] as List<dynamic>;
          // if (mineSavedIdeas.isEmpty) {
          //   noMineIdea = true;
          // }
        }
        if (mounted) {
          setState(() {
            displaySavedIdeas = mineSavedIdeas;
            isLoaded = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load saved ideas');
      if (mounted) {
        context.flushBarErrorMessage(message: 'Something went wrong..');
      }
    }
  }

  List<dynamic> displaySavedIdeas = [];

  void resetList() {
    setState(() {
      if (selectedToggle == 'Mine Only') {
        displaySavedIdeas = mineSavedIdeas;
      } else {
        displaySavedIdeas = mutualSavedIdeas;
      }
    });
  }

  //filter by category
  void filterByCategory(
    String category,
  ) {
    //resest list
    resetList();

    final List<dynamic> filtered =
        displaySavedIdeas.where((item) => item['type'] == category).toList();
    setState(() {
      displaySavedIdeas = filtered;
    });
  }
  //END: filter by category

  Future<void> reloadSaveIdeas() async {
    if (selectedToggle == 'Mine Only') {
      setState(() {
        mineSavedIdeas = [];
      });
      await fetchSavedIdeas('mine', showLoading: false);
    } else {
      setState(() {
        mutualSavedIdeas = [];
      });
      await fetchSavedIdeas('mutual', showLoading: false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSavedIdeas('mine'); //initially fetch mine saved ideas
    displaySavedIdeas = mineSavedIdeas;
  }

  String selectedToggle = 'Mine Only';
  String selectedDropdown = 'All';
  //this list is unchangeable, so we can define it as a constant
  static const List<String> dropdownItems = [
    'All',
    'Gift',
    'Restaurant',
    'Travel',
    'Activity',
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context); // 👈 required for AutomaticKeepAliveClientMixin
    final bool isPartnerConnected = sessionController.partner != null;
    final bool? isPremium = sessionController.user!.isPremium;
    if (isPremium != null && isPremium == false) {
      return _buildNoSubscription(context, isPremium);
    }

    return VisibilityDetector(
      key: const Key('MySavedIdeasTab'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0) {
          debugPrint('MySavedIdeasTab is visible');
          reloadSaveIdeas();
        } else {
          debugPrint('MySavedIdeasTab is NOT visible');
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 16.h,
          ),
          //Top Controls
          Row(
            children: [
              SizedBox(
                width: 16.w,
              ),
              // Toggle Buttons
              Container(
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                    224,
                    231,
                    232,
                    1,
                  ), // light background
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _buildToggleButton('Mine Only'),
                    _buildToggleButton('Mutual'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Dropdown
              _buildSavedIdeasDropdown(context),
              SizedBox(
                width: 16.w,
              ),
            ],
          ),
          //END: Top Controls
          SizedBox(
            height: 16.h,
          ),
          if (isLoaded)
            Expanded(
              child: ListView(
                children: [
                  if (displaySavedIdeas.isNotEmpty)
                    ...displaySavedIdeas.map(
                      (item) {
                        return IdeaCard(
                          onBookmarkOrDislikePressed: reloadSaveIdeas,
                          onReturnFromDetails: reloadSaveIdeas,
                          showOptionsButton: false,
                          data: item as Map<String, dynamic>,
                        );
                      },
                    )
                  else if (displaySavedIdeas.isEmpty &&
                      selectedToggle == 'Mutual' &&
                      !isPartnerConnected)
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160.h,
                          ),
                          Assets.icons.noItems.svg(),
                          const SizedBox(height: 16),
                          const Text(
                            'No Parnter Connected',
                          ),
                        ],
                      ),
                    )
                  else
                    //no item
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160.h,
                          ),
                          Assets.icons.noItems.svg(),
                          const SizedBox(height: 16),
                          Text(
                            'No $selectedToggle Saved Ideas!!',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            )
          else
            const Expanded(
              child: Center(
                child: LoadingWidget(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoSubscription(BuildContext context, bool? isPremium) {
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Text(
    //       maxLines: 2,
    //       'Subscription Required to enable this feature.',
    //       style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    //     ),
    //     SizedBox(
    //       height: 24.h,
    //     ),
    //     TextButton(
    //       style: TextButton.styleFrom(
    //         backgroundColor: context.colors.mainGreenLight,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(12),
    //         ),
    //       ),
    //       onPressed: () async {
    //         await SettingService.goToSubscriptionScreen(context, false);
    //         setState(() {
    //           isPremium = sessionController.user!.isPremium;
    //         });
    //         // Navigator.of(context).pop();
    //       },
    //       child: const Text(
    //         'Subscribe',
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     ),
    //   ],
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 37.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.dialog.infoBlue.svg(
            height: 100.h,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 20.h),
          const ColoredRichText(
            first: 'Subscription ',
            second: 'Not Found',
          ),
          SizedBox(height: 7.h),
          Text(
            'You have to subscribe in order to use this feature!',
            textAlign: TextAlign.center,
            style: context.typography.subtitle.copyWith(),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: MyButton(
                  label: 'Subscribe',
                  onPressed: () async {
                    await SettingService.goToSubscriptionScreen(context, false);
                    setState(() {
                      isPremium = sessionController.user!.isPremium;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded _buildSavedIdeasDropdown(BuildContext context) {
    return Expanded(
      child: Container(
        height: 46.h,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFA),
          border: Border.all(color: const Color(0xFFDDE5E6)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedDropdown,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: context.colors.mainGreenLight,
            ),
            dropdownColor: Colors.white,
            style: const TextStyle(
              color: Color(0xFF4C5C5D),
              fontSize: 16,
            ),
            items: dropdownItems.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                if (value == 'All') {
                  resetList();
                  setState(() {
                    selectedDropdown = value;
                  });
                } else {
                  setState(() {
                    filterByCategory(value);
                    selectedDropdown = value;
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label) {
    final bool isSelected = selectedToggle == label;
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     selectedToggle = label;
      //     if (selectedToggle == 'Mutual') {
      //       displaySavedIdeas = mutualSavedIdeas;
      //     } else if (selectedToggle == 'Mine Only') {
      //       displaySavedIdeas = mineSavedIdeas;
      //     }
      //   });
      //   debugPrint('Label: $label AND List = $displaySavedIdeas');
      // },

      onTap: () {
        setState(() {
          selectedDropdown = 'All';
          selectedToggle = label;
          if (selectedToggle == 'Mutual') {
            fetchSavedIdeas('mutual');
          } else if (selectedToggle == 'Mine Only') {
            fetchSavedIdeas('mine');
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isSelected ? context.colors.mainGreenLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? Colors.white : context.colors.textDarkGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
