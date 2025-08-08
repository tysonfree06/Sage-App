import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sage/app/components/custom_radio_group.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_datepicker_button.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/image_picker.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/services/views/signup_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
  late String _city;
  late String _state;
  late String _country;
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
  static const _apologyLanguages = [
    'Expressing Regret',
    'Accepting Responsibility',
    'Making Restitution',
    'Genuinely Repenting',
    'Requesting Forgiveness',
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
  static const _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
  ];
  static const _states = [
    'California',
    'Texas',
    'New York',
    'Florida',
    'Illinois',
  ];
  static const _countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
  ];

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
    _city = user?.location?.city ?? _cities.first;
    _state = user?.location?.state ?? _states.first;
    _country = user?.location?.country ?? _countries.first;
    _uploadedUrl = user?.image;
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
    if (!SignupService().isAtLeast18YearsOld(_dob!)) {
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
      _dob!,
      _anniversaryDate!,
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

    setState(() => _busy = true);

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
    setState(() {
      _busy = false;
      isLoading = false;
    });
  }

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
                label: context.l10n.onboarding_step1_what_is_your_love_language,
                value: _loveLanguage,
                items: _loveLanguages,
                onChanged: (v) => setState(() => _loveLanguage = v!),
              ),
              SizedBox(height: 16.h),
              _buildDropdown(
                label:
                    context.l10n.onboarding_step1_what_is_your_apology_language,
                value: _apologyLanguage,
                items: _apologyLanguages,
                onChanged: (v) => setState(() => _apologyLanguage = v!),
              ),
              SizedBox(height: 16.h),
              _buildDropdown(
                label: context
                    .l10n.onboarding_step1_what_is_your_communication_style,
                value: _communicationStyle,
                items: _communicationStyles,
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
              _buildDropdown(
                value: _city,
                items: _cities,
                onChanged: (v) => setState(() => _city = v!),
                hint: _city,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      value: _state,
                      items: _states,
                      onChanged: (v) => setState(() => _state = v!),
                      hint: _state,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildDropdown(
                      value: _country,
                      items: _countries,
                      onChanged: (v) => setState(() => _country = v!),
                      hint: _country,
                    ),
                  ),
                ],
              ),
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
            child:
                _busy ? const Center(child: CircularProgressIndicator()) : null,
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
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? label,
    String? hint,
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
        MyDropdown(items: items, hint: hint ?? value, onChanged: onChanged),
      ],
    );
  }
}
