import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/custom_radio_group.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_datepicker_button.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfileScreen> {
  final sessionController = SessionController();
  final TextEditingController nameController = TextEditingController();
  late String selectedLoveLanguage;
  late String selectedApologyLanguage;
  late String selectedCommunicationStyle;
  late String selectedBudgetLevel;
  late String selectedRelationshipStatus;
  DateTime? anniversaryDate;
  DateTime? dob;
  late String selectedCity;
  late String selectedState;
  late String selectedCountry;
  bool isLoading = false;

  // dropdown options
  final List<String> loveLanguages = [
    'Words of Affirmation',
    'Acts of Service',
    'Receiving Gifts',
    'Quality Time',
    'Physical Touch',
  ];
  final List<String> apologyLanguages = [
    'Expressing Regret',
    'Accepting Responsibility',
    'Making Restitution',
    'Genuinely Repenting',
    'Requesting Forgiveness',
  ];
  final List<String> communicationStyles = [
    'Assertive',
    'Passive',
    'Aggressive',
    'Passive-Aggressive',
  ];
  final List<String> budgetLevels = [
    r'$0 - $50',
    r'$50 - $100',
    r'$100 - $200',
    r'$200+',
  ];
  final List<String> relationshipStatuses = [
    'Dating',
    'Engaged',
    'Married',
  ];
  final List<String> cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
  ];
  final List<String> states = [
    'California',
    'Texas',
    'New York',
    'Florida',
    'Illinois',
  ];
  final List<String> countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
  ];
  @override
  void initState() {
    super.initState();

    // load initial values or pick first option as default
    selectedLoveLanguage =
        sessionController.user?.loveLanguage ?? loveLanguages.first;
    selectedApologyLanguage =
        sessionController.user?.apologyLanguage ?? apologyLanguages.first;
    selectedCommunicationStyle =
        sessionController.user?.communicationStyle ?? communicationStyles.first;
    selectedBudgetLevel =
        sessionController.user?.budgetLevel ?? budgetLevels.first;
    selectedRelationshipStatus = sessionController.user?.relationshipStatus ??
        relationshipStatuses.first;

    anniversaryDate = sessionController.user?.anniversaryDate;
    dob = sessionController.user?.dateOfBirth;

    selectedCity = sessionController.user?.location.city ?? cities.first;
    selectedState = sessionController.user?.location.state ?? states.first;
    selectedCountry =
        sessionController.user?.location.country ?? countries.first;
  }

  String _formatDate(DateTime? d) => d == null
      ? ''
      : "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  bool get _isFormComplete =>
      selectedLoveLanguage.isNotEmpty &&
      selectedApologyLanguage.isNotEmpty &&
      selectedCommunicationStyle.isNotEmpty &&
      selectedBudgetLevel.isNotEmpty &&
      selectedRelationshipStatus.isNotEmpty &&
      anniversaryDate != null &&
      dob != null &&
      selectedCity.isNotEmpty &&
      selectedState.isNotEmpty &&
      selectedCountry.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typography.title.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      color: context.colors.textDarkGreen,
    );

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: context.colors.mainGreenLight),
        title: Text(
          context.l10n.edit_profile,
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            color: context.colors.textDarkGreen,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(8.w),
                        height: 100.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.colors.mainGreenLight
                              .withValues(alpha: .2),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {},
                          icon: Assets.icons.editFilled.svg(),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.lets_name_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(
                  controller: nameController,
                  hint: context.l10n.lets_name_hint,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  readOnly: isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.error_name_required;
                    } else if (!value.nameValidator()) {
                      return context.l10n.error_name_invalid;
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10.h),
                // Love Language
                Text(
                  context.l10n.onboarding_step1_what_is_your_love_language,
                  style: labelStyle,
                ),
                SizedBox(height: 10.h),
                MyDropdown(
                  items: loveLanguages,
                  hint: selectedLoveLanguage,
                  onChanged: (v) => setState(() => selectedLoveLanguage = v!),
                ),
                SizedBox(height: 16.h),

                // Apology Language
                Text(
                    context.l10n.onboarding_step1_what_is_your_apology_language,
                    style: labelStyle),
                SizedBox(height: 10.h),
                MyDropdown(
                  items: apologyLanguages,
                  hint: selectedApologyLanguage,
                  onChanged: (v) =>
                      setState(() => selectedApologyLanguage = v!),
                ),
                SizedBox(height: 16.h),

                // Communication Style
                Text(
                    context
                        .l10n.onboarding_step1_what_is_your_communication_style,
                    style: labelStyle),
                SizedBox(height: 10.h),
                MyDropdown(
                  items: communicationStyles,
                  hint: selectedCommunicationStyle,
                  onChanged: (v) =>
                      setState(() => selectedCommunicationStyle = v!),
                ),
                SizedBox(height: 16.h),

                // Budget Level
                Text(context.l10n.onboarding_step1_budget_level,
                    style: labelStyle),
                SizedBox(height: 10.h),
                MyDropdown(
                  items: budgetLevels,
                  hint: selectedBudgetLevel,
                  onChanged: (v) => setState(() => selectedBudgetLevel = v!),
                ),
                SizedBox(height: 16.h),

                // Relationship Status
                Text(context.l10n.onboarding_step1_relationship_status,
                    style: labelStyle),
                SizedBox(height: 10.h),
                CustomRadioGroup<String>(
                  options: relationshipStatuses,
                  selectedValue: selectedRelationshipStatus,
                  onChanged: (v) =>
                      setState(() => selectedRelationshipStatus = v),
                  labelBuilder: (v) => v,
                ),
                SizedBox(height: 16.h),

                // Anniversary Date
                Text(context.l10n.onboarding_step1_anniversary_date,
                    style: labelStyle),
                SizedBox(height: 10.h),
                MyDatePickerButton(
                  hintText: anniversaryDate == null
                      ? context.l10n.onboarding_step1_select_a_date
                      : _formatDate(anniversaryDate),
                  selectedDate: anniversaryDate,
                  onChanged: (v) => setState(() => anniversaryDate = v),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Assets.icons.calander.svg(),
                  ),
                ),
                SizedBox(height: 16.h),

                // Date of Birth
                Text(context.l10n.onboarding_step1_date_of_birth,
                    style: labelStyle),
                SizedBox(height: 10.h),
                MyDatePickerButton(
                  hintText: dob == null
                      ? context.l10n.onboarding_step1_select_a_date
                      : _formatDate(dob),
                  selectedDate: dob,
                  onChanged: (v) => setState(() => dob = v),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Assets.icons.calander.svg(),
                  ),
                ),
                SizedBox(height: 16.h),

                // Location: City / State / Country
                Text(context.l10n.onboarding_step1_location, style: labelStyle),
                SizedBox(height: 10.h),
                MyDropdown(
                  items: cities,
                  hint: selectedCity,
                  onChanged: (v) => setState(() => selectedCity = v!),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: MyDropdown(
                        items: states,
                        hint: selectedState,
                        onChanged: (v) => setState(() => selectedState = v!),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: MyDropdown(
                        items: countries,
                        hint: selectedCountry,
                        onChanged: (v) => setState(() => selectedCountry = v!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // NEXT button
                MyButton(
                  label: context.l10n.edit_update,
                  onPressed: _isFormComplete
                      ? () {
                          //Call Api from service
                        }
                      : null,
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
