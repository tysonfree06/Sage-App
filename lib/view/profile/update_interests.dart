import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/backButton.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_chip.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/settings_service.dart';

class UpdateInterestsScreen extends StatefulWidget {
  const UpdateInterestsScreen({super.key});

  @override
  State<UpdateInterestsScreen> createState() => _UpdateInterestsScreenState();
}

class _UpdateInterestsScreenState extends State<UpdateInterestsScreen> {
  TextEditingController pinController = TextEditingController();
  List<String> allInterests = [
    'Fitness',
    'Science and Math',
    'Outdoors',
    'Travel',
    'Wellness',
    'Food',
    'Games',
    'Tech',
    'Home',
    'Art',
    'Learning',
    'Entertainment',
    'Community',
    'Fashion',
    'Shopping',
    'Sports',
    'Movies',
    'Parenting',
    'Spirituality & Religion', //previously: 'Spirituality & Religion',
    'Music',
    'Finances',
    'Animals',
    'Dancing',
    'History',
    'Photography',
  ];

  final SessionController _sessionController = SessionController();
  final SettingService _settingService = SettingService();
  final UserRepository _userRepo = UserRepository();

  // Set<String> selectedInterests = {};
  Set<String> selectedInterests = {};
  bool _busy = false;
  bool isLoading = false;

  bool get _canProceed => selectedInterests.isNotEmpty;

  @override
  @override
  void initState() {
    super.initState();
    //set interests from session

    selectedInterests =
        (_sessionController.user?.interests ?? []).toSet().cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: MyBackButton(
          color: !_busy && !isLoading
              ? context.colors.mainGreenLight
              : Colors.grey,
          onPressed: !_busy && !isLoading ? () => Navigator.pop(context) : null,
        ),
        title: Text(
          context.l10n.update_interests,
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: context.colors.textDarkGreen,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  context.l10n.update_interests_choose_upto_5_interests,
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: context.colors.textDarkGreen,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 10.h,
                children: allInterests
                    .map(
                      (item) => MyChip(
                        label: item,
                        isSelected: selectedInterests.contains(item),
                        onChanged: (selected) {
                          if (mounted) {
                            setState(() {
                              if (selected) {
                                if (selectedInterests.length < 5) {
                                  selectedInterests.add(item);
                                } else {
                                  // Optional: Show a toast or alert to limit 5
                                  context.flushBarErrorMessage(
                                    message:
                                        'You can select up to 5 interests only',
                                  );
                                }
                              } else {
                                selectedInterests.remove(item);
                              }
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
              const Spacer(),
              MyButton(
                label: context.l10n.interests_update,
                isLoading: isLoading,
                onPressed: !_busy && !isLoading && _canProceed
                    ? () async {
                        if (mounted) {
                          setState(() {
                            _busy = true;
                            isLoading = true;
                          });
                        }
                        // OnboardingService.goToStep3(context);
                        await _settingService.updateProfile(
                          context: context,
                          interests: selectedInterests.toList(),
                          // interests: [selectedInterests.join(', ')],
                          popScreen: true,
                        );
                        if (mounted) {
                          setState(() {
                            _busy = false;
                            isLoading = false;
                          });
                        }
                      }
                    : null,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
