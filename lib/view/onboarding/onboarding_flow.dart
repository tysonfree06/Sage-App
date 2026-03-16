import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/components/step_progress_bar.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/onboarding_service.dart';
import 'package:sage/view/views.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  OnboardingFlowScreenState createState() => OnboardingFlowScreenState();
}

class OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final _pageController = PageController();
  final sessionController = SessionController();
  final _onboardingService = OnboardingService();
  int _currentStep = 0;

  // Step 1
  String? loveLanguage;
  String? apologyLanguage;
  String? communicationStyle;
  String? budgetLevel;
  String? relationshipStatus;
  String? anniversaryDate;
  String? dateOfBirth;
  String? city;
  String? stateName;
  String? country;

  // Step 2 & 3
  Set<String> interests = {};
  Set<String> giftPreferences = {};

  // Step 4
  String? partnerId;

  Future<void> nextStep() async {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // await _submitAllData();
      ///Flow changed: Data will be submitted from the Step 4: Add Partner
      ///Screen. If error adding partner, will show flushbar there, otherwise,
      // proced to analyize data (which will only make a delay)..
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final payload = {
      'userId': sessionController.user?.id ?? '',
      'name': sessionController.user?.name ?? '',
      'image': sessionController.user?.image ?? '',
      'loveLanguage': loveLanguage,
      'apologyLanguage': apologyLanguage,
      'communicationStyle': communicationStyle,
      'budgetLevel': budgetLevel,
      'relationshipStatus': relationshipStatus,
      'anniversaryDate': anniversaryDate,
      'dateOfBirth': dateOfBirth,
      'city': city,
      'state': stateName,
      'country': country,
      // 'partnerCode': partnerId,
      'interests': interests.toList(),
      'giftPreferences': giftPreferences.toList(),
    };

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentStep > 0) previousStep();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.colors.white,
          leading: BackButton(
            onPressed: previousStep,
            color: context.colors.mainGreenLight,
          ),
          centerTitle: true,
          actions: [
            MyTextButton(
              onPressed: () {
                if (_currentStep < 3) {
                  nextStep();
                } else {
                  _onboardingService.submitAllData(context, payload);
                }
              },
              label: 'Skip',
            ),
            SizedBox(
              width: 16.w,
            ),
          ],
          title: SizedBox(
            width: context.mediaQueryWidth / 2,
            child: StepProgressBar(
              totalSteps: 4,
              currentStep: _currentStep,
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // ─── STEP 1 ───
            Step1Screen(
              initialLoveLanguage: loveLanguage,
              initialApologyLanguage: apologyLanguage,
              initialCommunicationStyle: communicationStyle,
              initialBudgetLevel: budgetLevel,
              initialRelationshipStatus: relationshipStatus,
              initialAnniversaryDate: anniversaryDate,
              initialDateOfBirth: dateOfBirth,
              initialCity: city,
              initialState: stateName,
              initialCountry: country,
              onNext: (
                String loveLang,
                String apologyLang,
                String commStyle,
                String budget,
                String relStatus,
                String annivDate,
                String dob,
                String cityVal,
                String stateVal,
                String countryVal,
              ) {
                loveLanguage = loveLang;
                apologyLanguage = apologyLang;
                communicationStyle = commStyle;
                budgetLevel = budget;
                relationshipStatus = relStatus;
                anniversaryDate = annivDate;
                dateOfBirth = dob;
                city = cityVal;
                stateName = stateVal;
                country = countryVal;
                nextStep();
              },
            ),

            // ─── STEP 2 ───
            Step2Screen(
              initialSelectedInterests: interests,
              onNext: (Set<String> selectedInterests) {
                interests = selectedInterests;
                nextStep();
              },
            ),

            // ─── STEP 3 ───
            Step3Screen(
              initialSelectedPrefs: giftPreferences,
              onNext: (Set<String> selectedPrefs) {
                giftPreferences = selectedPrefs;
                nextStep();
              },
            ),

            // ─── STEP 4 ───
            Step4Screen(
              initialPartnerId: partnerId,
              payload: payload,
              // onNext: (String? selectedPartnerId) {
              //   setState(() {
              //     partnerId = selectedPartnerId;
              //   });
              //   nextStep();
              // },
            ),
          ],
        ),
      ),
    );
  }
}
