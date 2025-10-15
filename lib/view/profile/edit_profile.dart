import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sage/app/components/custom_radio_group.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_datepicker_button.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/constants/countries.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/env.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/image_picker.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/services/views/signup_service.dart';
import 'package:sage/view/onboarding/widgets/address_autocomplete.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() {
    return EditProfileScreenState();
  }
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _session = SessionController();
  final _pickerService = ImagePickerService();
  final _service = SettingService();

  bool isLoading = false;

  // Controllers & state
  late TextEditingController _nameController;
  late String _loveLanguage;
  late String _apologyLanguage;
  late String _communicationStyle;
  late String _budgetLevel;
  late String _relationshipStatus;
  DateTime? _anniversaryDate;
  DateTime? _dob;
  String? _city;
  String? _state;
  String? _country;
  File? _localImage;
  String? _uploadedUrl;
  bool _busy = false;

  // Static options
  static const _loveLanguages = [
    'Words of Affirmation',
    'Acts of Service',
    'Receiving Gifts',
    'Quality Time',
    'Physical Touch',
  ];
  // static const _apologyLanguages = [
  //   'Expressing Regret',
  //   'Accepting Responsibility',
  //   'Making Restitution',
  //   'Genuinely Repenting',
  //   'Requesting Forgiveness',
  // ];
  static const _apologyLanguages = [
    "Saying I'm Sorry",
    'Owning Up',
    'Making It Right',
    'Changing Behaviour',
    'Asking to Be Forgiven',
  ];
  static const _communicationStyles = [
    'Assertive',
    'Passive',
    'Aggressive',
    'Passive-Aggressive',
  ];
  static const _budgetLevels = [
    r'$0 - $50',
    r'$50 - $100',
    r'$100 - $200',
    r'$200+',
  ];
  static const _relationshipStatuses = [
    'Dating',
    'Engaged',
    'Married',
  ];
  List<dynamic> cities = [];
  List<dynamic> states = [];
  // List<dynamic> countries = [];
  List<dynamic> countries = Countires.allCountries;

  final TextEditingController _locationController = TextEditingController();
  double _lat = 0;
  double _lng = 0;

  @override
  void initState() {
    super.initState();
    final user = _session.user;
    _nameController = TextEditingController(text: user?.name);
    _loveLanguage = user?.loveLanguage ?? _loveLanguages.first;
    _apologyLanguage = user?.apologyLanguage ?? _apologyLanguages.first;
    _communicationStyle =
        user?.communicationStyle ?? _communicationStyles.first;
    _budgetLevel = user?.budgetLevel ?? _budgetLevels.first;
    _relationshipStatus =
        user?.relationshipStatus ?? _relationshipStatuses.first;
    _anniversaryDate = user?.anniversaryDate;
    _dob = user?.dateOfBirth;
    setLocations(); //remove comment #muttas
    _uploadedUrl = user?.image;

    //get countries on init
    // getCountries();
  }

  void setLocations() {
    //old
    // final user = _session.user;
    // if (user?.location?.city != null && user?.location?.city != '') {
    //   cities.add({'code': '', 'name': user?.location?.city});
    //   _city = user?.location?.city;
    // }

    // if (user?.location?.state != null && user?.location?.state != '') {
    //   states.add({'code': '', 'name': user?.location?.state});
    //   _state = user?.location?.state;
    // }
    // _country = user?.location?.country;
    //end: old

    final user = _session.user;
    String address = '';
    if (user?.location?.city != null && user?.location?.city != '') {
      cities.add({'code': '', 'name': user?.location?.city});
      // _city = user?.location?.city;
      address = '$address ${user?.location?.city},';
    }

    if (user?.location?.state != null && user?.location?.state != '') {
      states.add({'code': '', 'name': user?.location?.state});
      // _state = user?.location?.state;
      address = '$address ${user?.location?.state},';
    }
    // _country = user?.location?.country;
    address = '$address ${user?.location?.country}';

    _locationController.text = address;
  }

  Future<void> _pickAndUploadImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final file = await _pickerService.pickImage(source: source);
    if (file == null || !mounted) return;

    setState(() => _busy = true);

    // Service now handles all error display internally
    final url = await _service.uploadImage(context, file: file);

    if (mounted) {
      setState(() {
        _busy = false;
        if (url != null) {
          _localImage = file;
          _uploadedUrl = url;
        }
      });
    }
  }

  String _formatDate(DateTime? d) => d == null
      ? ''
      : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _submit() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    if (!_formKey.currentState!.validate()) return;
    if (!SignupService().isAtLeast18YearsOld(_dob)) {
      context.flushBarErrorMessage(
        message: 'You should be at least 18 years old!',
      );
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      return;
    }

    if (!SignupService().isAnniversaryDateLessThanDOB(
      _dob ?? DateTime.now(),
      _anniversaryDate,
    )) {
      context.flushBarErrorMessage(
        message: 'Date of Birth should be before Anniversary Date!',
      );
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() => _busy = true);
    }

    await _service.updateProfile(
      context: context,
      name: _nameController.text,
      loveLanguage: _loveLanguage,
      apologyLanguage: _apologyLanguage,
      communicationStyle: _communicationStyle,
      budgetLevel: _budgetLevel,
      relationshipStatus: _relationshipStatus,
      anniversaryDate: _anniversaryDate,
      dateOfBirth: _dob,
      city: _city,
      state: _state,
      country: _country,
      image: _uploadedUrl,
      popScreen: true,
    );
    if (mounted) {
      setState(() {
        _busy = false;
        isLoading = false;
      });
    }
  }

  //get locations from api
  // final _settingsRepo = SettingsRepository();
  // Future<void> getCountries() async {
  //   final countriesResponse = await _settingsRepo.getCountries();
  //   final countriesList = countriesResponse['data'] as List<dynamic>;

  //   if (mounted) {
  //     setState(() {
  //       countries = countriesList;
  //     });
  //   }
  // }

  // Future<void> getStates(String countryCode) async {
  //   try {
  //     setState(() {
  //       states = [];
  //       cities = [];
  //     });
  //     _state = null;
  //     _city = null;
  //     final statesResponse = await _settingsRepo.getStates(
  //       countryCode,
  //     );
  //     final statesList = statesResponse['data'] as List<dynamic>;
  //     if (mounted) {
  //       setState(() {
  //         states = statesList;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Failed to fetch states Error: $e');
  //     setState(() {});
  //   }
  // }

  // Future<void> getCities(String countryCode, String stateCode) async {
  //   if (stateCode.isEmpty) return;
  //   try {
  //     setState(() {
  //       cities = [];
  //     });
  //     _city = null;
  //     final citiesResponse = await _settingsRepo.getCities(
  //       countryCode,
  //       stateCode,
  //     );

  //     final citiesList = citiesResponse['data'] as List<dynamic>;
  //     if (mounted) {
  //       setState(() {
  //         cities = citiesList;
  //       });
  //     }
  //   } catch (e) {
  //     debugPrint('Failed to fetch cities Error: $e');
  //   }
  // }

  //END: get locations from api

  // bool showCitiesDropdown = true;
  // bool showStatesDropdown = true;

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
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            children: [
              _buildAvatarPicker(),
              SizedBox(height: 24.h),
              _buildTextField(
                label: context.l10n.lets_name_label,
                controller: _nameController,
                hint: context.l10n.lets_name_hint,
              ),
              SizedBox(height: 16.h),
              _buildDropdown(
                // label: context.l10n.onboarding_step1_what_is_your_love_language,
                label: 'How do you like your partner to show you love?',
                value: _loveLanguage,
                items: _loveLanguages,
                onChanged: (v) => setState(() => _loveLanguage = v!),
                hint: 'Select your love language',
              ),
              SizedBox(height: 16.h),
              _buildDropdown(
                // label:
                //     context.l10n.onboarding_step1_what_is_your_apology_language,
                label: 'How do you like your partner to apologize to you?',
                value: _apologyLanguage,
                items: _apologyLanguages,
                onChanged: (v) => setState(() => _apologyLanguage = v!),
                hint: 'Select your apology language',
              ),
              SizedBox(height: 16.h),
              _buildDropdown(
                label: 'How do you communicate with your partner?',
                // label: context
                //     .l10n.onboarding_step1_what_is_your_communication_style,
                value: _communicationStyle,
                items: _communicationStyles,
                hint: 'Select your communication style',
                onChanged: (v) => setState(() {
                  _communicationStyle = v!;
                }),
              ),
              SizedBox(height: 16.h),
              _buildDropdown(
                label: context.l10n.onboarding_step1_budget_level,
                value: _budgetLevel,
                items: _budgetLevels,
                onChanged: (v) => setState(() => _budgetLevel = v!),
              ),
              SizedBox(height: 16.h),
              Text(
                context.l10n.onboarding_step1_relationship_status,
                style: labelStyle,
              ),
              SizedBox(height: 10.h),
              CustomRadioGroup<String>(
                options: _relationshipStatuses,
                selectedValue: _relationshipStatus,
                onChanged: (v) => setState(() => _relationshipStatus = v),
                labelBuilder: (v) => v,
              ),
              SizedBox(height: 16.h),
              Text(
                context.l10n.onboarding_step1_anniversary_date,
                style: labelStyle,
              ),
              MyDatePickerButton(
                hintText: _anniversaryDate == null
                    ? context.l10n.onboarding_step1_select_a_date
                    : _formatDate(_anniversaryDate),
                selectedDate: _anniversaryDate,
                onChanged: (d) => setState(() => _anniversaryDate = d),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Assets.icons.calander.svg(),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                context.l10n.onboarding_step1_date_of_birth,
                style: labelStyle,
              ),
              MyDatePickerButton(
                hintText: _dob == null
                    ? context.l10n.onboarding_step1_select_a_date
                    : _formatDate(_dob),
                selectedDate: _dob,
                onChanged: (d) => setState(() => _dob = d),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Assets.icons.calander.svg(),
                ),
              ),
              SizedBox(height: 16.h),
              Text(context.l10n.onboarding_step1_location, style: labelStyle),
              SizedBox(height: 10.h),
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildDropdown(
              //         value: _country,
              //         // items: countries,
              //         items: countries.map((country) {
              //           return country['name'].toString();
              //         }).toList(),
              //         onChanged: (v) {
              //           setState(() {
              //             showStatesDropdown = true;
              //             _country = v;
              //           });
              //           final String countryCode =
              //               _service.getCodeByName(countries, v!);
              //           getStates(countryCode).then((_) {
              //             if (states.isEmpty) {
              //               setState(() {
              //                 showStatesDropdown = false;
              //               });
              //               if (context.mounted) {
              //                 context.flushBarErrorMessage(
              //                   message: 'No States found for this country.',
              //                 );
              //               }
              //             }
              //           });
              //         },
              //         hint: 'Select Country',
              //       ),
              //     ),
              //     if (showStatesDropdown) ...[
              //       SizedBox(width: 16.w),
              //       Expanded(
              //         child: _buildDropdown(
              //           itemType: 'state',
              //           ctx: context,
              //           value: _state,
              //           // items: states,
              //           items: states.map((state) {
              //             return state['name'].toString();
              //           }).toList(),
              //           onChanged: (v) {
              //             if (mounted) {
              //               showCitiesDropdown = true;
              //               setState(() => _state = v);
              //             }
              //             if (_country != null) {
              //               final String countryCode = _service.getCodeByName(
              //                 countries,
              //                 _country!,
              //               );
              //               final String stateCode =
              //                   _service.getCodeByName(states, v!);
              //               getCities(countryCode, stateCode).then((_) {
              //                 if (cities.isEmpty) {
              //                   setState(() {
              //                     showCitiesDropdown = false;
              //                   });
              //                   if (context.mounted) {
              //                     context.flushBarErrorMessage(
              //                       message: 'No Cities found for this state.',
              //                     );
              //                   }
              //                 }
              //               });
              //             }
              //           },
              //           // hint: _state,
              //           hint: 'Select State',
              //         ),
              //       ),
              //     ],
              //   ],
              // ),
              // SizedBox(height: 10.h),
              // if (showCitiesDropdown)
              //   _buildDropdown(
              //     itemType: 'city',
              //     ctx: context,
              //     value: _city,
              //     // items: cities,
              //     items: cities.map((city) {
              //       return city['name'].toString();
              //     }).toList(),
              //     onChanged: (v) {
              //       if (mounted) {
              //         setState(() => _city = v);
              //       }
              //     },
              //     hint: 'Select City',
              //   ),
              // SizedBox(height: 24.h),
              //Places api
              AddressAutocompleteTextField(
                controller: _locationController,
                apiKey: Env.placesApiKey,
                hint: 'Enter Your Location',
                readOnly: isLoading,
                onAddressSelected: (AddressResult result) {
                  _locationController.text = result.address;
                  debugPrint('Address: ${result.address}');
                  debugPrint('City: ${result.city}');
                  _city = result.city;
                  debugPrint('State: ${result.state}');
                  _state = result.state;
                  debugPrint('Country: ${result.country}');
                  _country = result.country;
                },
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return context.l10n.error_address_required;
                //   }
                //   if (value.isNotEmpty && _lat == 0 && _lng == 0) {
                //     return context.l10n.error_address_invalid;
                //   }
                //   return null;
                // },
              ),
              //END Places api
              SizedBox(height: 24.h),
              MyButton(
                isLoading: isLoading,
                label: context.l10n.edit_update,
                onPressed: _busy ? null : _submit,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
              // color: Colors.grey[200],
            ),
            child: Assets.icons.user.svg(),
          ),
          Container(
            width: 100.w,
            height: 100.h,
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // color: Colors.grey[200],
              image: _localImage != null || _uploadedUrl != null
                  ? DecorationImage(
                      image: _localImage != null
                          ? FileImage(_localImage!)
                          : NetworkImage(_uploadedUrl!) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage(
                        Assets.icons.user.path,
                      ),
                    ),
            ),
            child: _busy
                ? Center(
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      ),
                      child: const LoadingWidget(
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Assets.icons.editFilled.svg(),
              onPressed: _busy ? null : _pickAndUploadImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typography.title
              .copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        MyFormTextField(
          controller: controller,
          hint: hint,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          validator: (val) => (val == null || val.isEmpty)
              ? context.l10n.error_name_required
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
    String? label,
    String? hint,
    String? itemType,
    BuildContext?
        ctx, //context and item type are only given from location dropdowns
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label,
            style: context.typography.title
                .copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
          ),
        if (label != null) SizedBox(height: 10.h),
        MyDropdown(
          items: items,
          hint: hint,
          value: value,
          onChanged: onChanged,
          itemType: itemType,
          ctx: ctx,
        ),
      ],
    );
  }
}
