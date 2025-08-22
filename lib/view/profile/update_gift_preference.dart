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
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/settings_service.dart';

class UpdateGiftPreferenceScreen extends StatefulWidget {
  const UpdateGiftPreferenceScreen({super.key});

  @override
  State<UpdateGiftPreferenceScreen> createState() =>
      _UpdateGiftPreferenceScreenState();
}

class _UpdateGiftPreferenceScreenState
    extends State<UpdateGiftPreferenceScreen> {
  TextEditingController pinController = TextEditingController();
  List<String> preferences = [
    'Experiences',
    'Tech & Gadgets',
    'Jewelry',
    'Fashion & Accessories',
    'Books',
    'Handmade & DIY',
    'Events',
    'Personalized Gifts',
    'Subscription Services',
    'Wellness & Self-Care',
    'Home & Decor',
    'Food & Gourmet',
    'Travel & Adventure',
    'Event Tickets',
  ];

  final SessionController _sessionController = SessionController();
  final SettingService _settingService = SettingService();

  Set<String> selectedPreferences = {};
  bool _busy = false;
  bool isLoading = false;
  bool get _canProceed => selectedPreferences.isNotEmpty;

  @override
  @override
  void initState() {
    super.initState();
    selectedPreferences =
        (_sessionController.user?.giftPreferences ?? []).toSet().cast<String>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: BackButton(color: context.colors.mainGreenLight),
        leading: MyBackButton(
          color: !_busy && !isLoading
              ? context.colors.mainGreenLight
              : Colors.grey,
          onPressed: !_busy && !isLoading ? () => Navigator.pop(context) : null,
        ),
        title: Text(
          context.l10n.update_gift_preferences,
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
                  context.l10n.update_gift_choose_upto_5_preferences,
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
                children: preferences
                    .map(
                      (item) => MyChip(
                        label: item,
                        isSelected: selectedPreferences.contains(item),
                        onChanged: (selected) {
                          setState(() {
                            if (selected) {
                              if (selectedPreferences.length < 5) {
                                selectedPreferences.add(item);
                              } else {
                                // Optional: Show a toast or alert to limit 5
                                context.flushBarErrorMessage(
                                  message:
                                      // ignore: lines_longer_than_80_chars
                                      'You can select up to 5 gift preferences only',
                                );
                              }
                            } else {
                              selectedPreferences.remove(item);
                            }
                          });
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
                        setState(() {
                          _busy = true;
                          isLoading = true;
                        });
                        await _settingService.updateProfile(
                          context: context,
                          giftPreferences: selectedPreferences.toList(),
                          popScreen: true,
                        );
                        setState(() {
                          _busy = false;
                          isLoading = false;
                        });
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
