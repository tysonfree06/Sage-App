import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/custom_radio_group.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_datepicker_button.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/constants/countries.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/repository/settings_repo.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/services/views/signup_service.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({
    required this.onNext,
    super.key,
    this.initialLoveLanguage,
    this.initialApologyLanguage,
    this.initialCommunicationStyle,
    this.initialBudgetLevel,
    this.initialRelationshipStatus,
    this.initialAnniversaryDate,
    this.initialDateOfBirth,
    this.initialCity,
    this.initialState,
    this.initialCountry,
  });

  final String? initialLoveLanguage;
  final String? initialApologyLanguage;
  final String? initialCommunicationStyle;
  final String? initialBudgetLevel;
  final String? initialRelationshipStatus;
  final String? initialAnniversaryDate;
  final String? initialDateOfBirth;
  final String? initialCity;
  final String? initialState;
  final String? initialCountry;

  /// onNext returns all step-1 values
  final void Function(
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
  ) onNext;

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  // local state fields
  String? selectedLoveLanguage;
  String? selectedApologyLanguage;
  String? selectedCommunicationStyle;
  String? selectedBudgetLevel;
  late String selectedRelationshipStatus;
  DateTime? anniversaryDate;
  DateTime? dob;
  String? selectedCity;
  String? selectedState;
  String? selectedCountry;
  final _service = SettingService();

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
  List<dynamic> cities = [];
  List<dynamic> states = [];
  List<dynamic> countries = Countires.allCountries;

  @override
  void initState() {
    super.initState();

    // load initial values or pick first option as default
    // selectedLoveLanguage = widget.initialLoveLanguage ?? loveLanguages.first;
    // selectedApologyLanguage =
    //     widget.initialApologyLanguage ?? apologyLanguages.first;
    // selectedCommunicationStyle =
    //     widget.initialCommunicationStyle ?? communicationStyles.first;
    // selectedBudgetLevel = widget.initialBudgetLevel ?? budgetLevels.first;
    selectedRelationshipStatus =
        widget.initialRelationshipStatus ?? relationshipStatuses.first;

    anniversaryDate = widget.initialAnniversaryDate != null
        ? DateTime.tryParse(widget.initialAnniversaryDate!)
        : null;
    dob = widget.initialDateOfBirth != null
        ? DateTime.tryParse(widget.initialDateOfBirth!)
        : null;
    //get countries on init

    // selectedCity = widget.initialCity ?? cities.first;
    // selectedState = widget.initialState ?? states.first;
    // selectedCountry = widget.initialCountry ?? countries.first;
  }

  //get locations from api
  final _settingsRepo = SettingsRepository();

  Future<void> getStates(String countryCode) async {
    try {
      setState(() {
        states = [];
        cities = [];
      });
      selectedState = null;
      selectedCity = null;
      final statesResponse = await _settingsRepo.getStates(
        countryCode,
      );
      final statesList = statesResponse['data'] as List<dynamic>;
      if (mounted) {
        setState(() {
          states = statesList;
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch states Error: $e');
      setState(() {});
    }
  }

  Future<void> getCities(String countryCode, String stateCode) async {
    debugPrint(
      'HERE, MY ARGUMENTS: CONCODE: $countryCode, STATE CODE: $stateCode',
    );
    if (stateCode.isEmpty) return;
    try {
      setState(() {
        cities = [];
      });
      selectedCity = null;
      final citiesResponse = await _settingsRepo.getCities(
        countryCode,
        stateCode,
      );

      final citiesList = citiesResponse['data'] as List<dynamic>;

      if (mounted) {
        setState(() {
          cities = citiesList;
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch cities Error: $e');
    }
  }

  //END: get locations from api

  String _formatDate(DateTime? d) => d == null
      ? ''
      : "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void _validateAndProceed() {
    if (selectedLoveLanguage == null ||
        selectedApologyLanguage == null ||
        selectedCommunicationStyle == null ||
        selectedBudgetLevel == null ||
        anniversaryDate == null ||
        dob == null ||
        // selectedCity == null ||
        // selectedState == null ||
        selectedCountry == null) {
      return;
    }

    // check that no field is "empty"
    if (selectedLoveLanguage!.isEmpty ||
        selectedApologyLanguage!.isEmpty ||
        selectedCommunicationStyle!.isEmpty ||
        selectedBudgetLevel!.isEmpty ||
        selectedRelationshipStatus.isEmpty ||
        anniversaryDate == null ||
        dob == null ||
        // selectedCity!.isEmpty ||
        // selectedState!.isEmpty ||
        selectedCountry!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.onboarding_error_complete_all_fields),
        ),
      );
      return;
    }

    //date of birth and anniversary date validation
    if (!SignupService().isAtLeast18YearsOld(dob)) {
      context.flushBarErrorMessage(
        message: 'You should be at least 18 years old!',
      );
      return;
    }

    if (!SignupService().isAnniversaryDateLessThanDOB(
      dob!,
      anniversaryDate,
    )) {
      context.flushBarErrorMessage(
        message: 'Date of Birth should be before Anniversary Date!',
      );
      return;
    }
    //END: date of birth and anniversary date validation

    widget.onNext(
      selectedLoveLanguage!,
      selectedApologyLanguage!,
      selectedCommunicationStyle!,
      selectedBudgetLevel!,
      selectedRelationshipStatus,
      _formatDate(anniversaryDate),
      _formatDate(dob),
      selectedCity ?? '',
      selectedState ?? '',
      selectedCountry!,
    );
  }

  bool get _isFormComplete =>
      selectedLoveLanguage != null &&
      selectedLoveLanguage!.isNotEmpty &&
      selectedApologyLanguage != null &&
      selectedApologyLanguage!.isNotEmpty &&
      selectedCommunicationStyle != null &&
      selectedCommunicationStyle!.isNotEmpty &&
      selectedBudgetLevel != null &&
      selectedBudgetLevel!.isNotEmpty &&
      selectedRelationshipStatus.isNotEmpty &&
      anniversaryDate != null &&
      dob != null &&
      // selectedCity != null &&
      // selectedCity!.isNotEmpty &&
      // selectedState != null &&
      // selectedState!.isNotEmpty &&
      selectedCountry != null &&
      selectedCountry!.isNotEmpty;

  //Show/Hide Cities/States dropdown
  bool showCitiesDropdown = true;
  bool showStatesDropdown = true;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typography.title.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      color: context.colors.textDarkGreen,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Center(
                child: ColoredRichText(
                  first: context.l10n.onboarding_step1,
                  second: context.l10n.onboarding_steps_4,
                  firstFontSize: 15.sp,
                  secondFontSize: 15.sp,
                  firstFontWeight: FontWeight.w600,
                  secondFontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  context.l10n.onboarding_step1_lets_get_started,
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: context.colors.textDarkGreen,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Love Language
              Text(
                context.l10n.onboarding_step1_what_is_your_love_language,
                style: labelStyle,
              ),
              SizedBox(height: 10.h),
              MyDropdown(
                items: loveLanguages,
                value: selectedLoveLanguage,
                hint: 'Select your love language?',
                onChanged: (v) => setState(() => selectedLoveLanguage = v),
              ),
              SizedBox(height: 16.h),

              // Apology Language
              Text(
                context.l10n.onboarding_step1_what_is_your_apology_language,
                style: labelStyle,
              ),
              SizedBox(height: 10.h),
              MyDropdown(
                items: apologyLanguages,
                value: selectedApologyLanguage,
                hint: 'Select your apology languge',
                onChanged: (v) => setState(() => selectedApologyLanguage = v),
              ),
              SizedBox(height: 16.h),

              // Communication Style
              Text(
                context.l10n.onboarding_step1_what_is_your_communication_style,
                style: labelStyle,
              ),
              SizedBox(height: 10.h),
              MyDropdown(
                items: communicationStyles,
                value: selectedCommunicationStyle,
                hint: 'Select your communication style?',
                onChanged: (v) =>
                    setState(() => selectedCommunicationStyle = v),
              ),
              SizedBox(height: 16.h),

              // Budget Level
              Text(
                context.l10n.onboarding_step1_budget_level,
                style: labelStyle,
              ),
              SizedBox(height: 10.h),
              MyDropdown(
                items: budgetLevels,
                value: selectedBudgetLevel,
                hint: 'Select your budget level',
                onChanged: (v) => setState(() => selectedBudgetLevel = v),
              ),
              SizedBox(height: 16.h),

              // Relationship Status
              Text(
                context.l10n.onboarding_step1_relationship_status,
                style: labelStyle,
              ),
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
              Text(
                context.l10n.onboarding_step1_anniversary_date,
                style: labelStyle,
              ),
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
              Text(
                context.l10n.onboarding_step1_date_of_birth,
                style: labelStyle,
              ),
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
              Row(
                children: [
                  Expanded(
                    child: MyDropdown(
                      // items: countries,
                      items: countries.map((country) {
                        return country['name'].toString();
                      }).toList(),
                      value: selectedCountry,
                      hint: 'Select Country',
                      // onChanged: (v) => setState(() => selectedCountry = v!),
                      onChanged: (v) {
                        setState(() {
                          showStatesDropdown = true;
                          selectedCountry = v;
                        });
                        final String countryCode =
                            _service.getCodeByName(countries, v!);
                        getStates(countryCode).then((_) {
                          if (states.isEmpty) {
                            setState(() {
                              showStatesDropdown = false;
                            });
                            if (context.mounted) {
                              context.flushBarErrorMessage(
                                message: 'No States found for this Country.',
                              );
                            }
                          }
                        });
                      },
                    ),
                  ),
                  if (showStatesDropdown) ...[
                    SizedBox(width: 16.w),
                    Expanded(
                      child: MyDropdown(
                        //itemType and ctx are used to show error messages
                        itemType: 'state',
                        ctx: context,
                        // items: states,
                        value: selectedState,
                        hint: 'Select State',
                        // onChanged: (v) => setState(() => selectedState = v!),
                        items: states.map((state) {
                          return state['name'].toString();
                        }).toList(),
                        onChanged: (v) {
                          if (mounted) {
                            showCitiesDropdown = true;
                            setState(() => selectedState = v);
                          }
                          if (selectedCountry != null) {
                            final String countryCode = _service.getCodeByName(
                              countries,
                              selectedCountry!,
                            );
                            final String stateCode =
                                _service.getCodeByName(states, v!);
                            getCities(countryCode, stateCode).then((_) {
                              if (cities.isEmpty) {
                                setState(() {
                                  showCitiesDropdown = false;
                                });
                                if (context.mounted) {
                                  context.flushBarErrorMessage(
                                    message: 'No Cities found for this State.',
                                  );
                                }
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 10.h),
              if (showCitiesDropdown)
                MyDropdown(
                  //itemType and ctx are used to show error messages
                  itemType: 'city',
                  ctx: context,
                  // items: cities,
                  value: selectedCity,
                  hint: 'Select City',
                  // onChanged: (v) => setState(() => selectedCity = v!),
                  items: cities.map((city) {
                    return city['name'].toString();
                  }).toList(),
                  onChanged: (v) {
                    if (mounted) {
                      setState(() => selectedCity = v);
                    }
                  },
                ),

              SizedBox(height: 24.h),
              // NEXT button
              MyButton(
                label: context.l10n.onboarding_step1_next,
                onPressed: _isFormComplete
                    ? () {
                        if (!SignupService()
                            .isAtLeast18YearsOld(dob ?? DateTime.now())) {
                          context.flushBarErrorMessage(
                            message: 'You should be at least 18 years old!',
                          );
                          return;
                        }
                        _validateAndProceed();
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
