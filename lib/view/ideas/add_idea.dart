import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/image_picker.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/ideas_service.dart';
import 'package:sage/services/views/settings_service.dart';

class AddIdeaScreen extends StatefulWidget {
  const AddIdeaScreen({
    required this.isEditIdea,
    required this.ideaDetails,
    super.key,
  });
  final bool isEditIdea;
  final Map<String, dynamic>? ideaDetails;
  @override
  State<AddIdeaScreen> createState() => _AddIdeaScreenState();
}

TextEditingController _titleController = TextEditingController();
TextEditingController _costController = TextEditingController();
TextEditingController _locationController = TextEditingController();
TextEditingController _linkController = TextEditingController();
TextEditingController _descriptionController = TextEditingController();
final _pickerService = ImagePickerService();
final _sessionController = SessionController();
final _service = SettingService();

String? _uploadedUrl;
bool _busy = false;
bool isLoading = false;
File? _localImage;

class _AddIdeaScreenState extends State<AddIdeaScreen> {
  String selectedType = 'Gift';
  final List<String> typeItems = [
    'Gift',
    'Activity',
    'Restaurant',
    'Travel',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditIdea) {
      //assign values
      _titleController.text = widget.ideaDetails?['title'] as String? ?? '';
      _costController.text = widget.ideaDetails?['cost'].toString() ?? '';
      _locationController.text =
          widget.ideaDetails?['location'] as String? ?? '';
      _linkController.text = widget.ideaDetails?['link'] as String? ?? '';
      _descriptionController.text =
          widget.ideaDetails?['description'] as String? ?? '';
      selectedType = widget.ideaDetails?['type'] as String? ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.text = '';
    _costController.text = '';
    _locationController.text = '';
    _linkController.text = '';
    _descriptionController.text = '';
    _localImage = null;
    _uploadedUrl = null;
    super.dispose();
  }

  //Add Idea
  Future<void> addOrUpdateIdea() async {
    String imageUrl = '';
    if (widget.ideaDetails?['image'] != null &&
        widget.ideaDetails?['image'] != '') {
      imageUrl = widget.ideaDetails?['image'] as String;
    } else if (_uploadedUrl != null && _uploadedUrl != '') {
      imageUrl = _uploadedUrl!;
    }
    //widget.ideaDetails?['image']
    // String imageUrl = _uploadedUrl;

    setState(() {
      _busy = true;
      isLoading = true;
    });
    final userId = _sessionController.user!.id;
    final Map<String, dynamic> ideaData = {
      'title': _titleController.text,
      'image': imageUrl,
      'type': selectedType,
      'description': _descriptionController.text,
      'cost': _costController.text,
      'location': _locationController.text,
      'link': _linkController.text,
      'userId': userId,
    };

    //all fields are mandatory

    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _costController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _linkController.text.isEmpty ||
        imageUrl == '') {
      context.flushBarErrorMessage(message: 'Please fill all fields.');
      setState(() {
        _busy = false;
        isLoading = false;
      });
      return;
    }

    //END: fields validation

    if (widget.isEditIdea) {
      await IdeasServices().editIdea(
        context,
        widget.ideaDetails?['_id'] as String? ?? '',
        ideaData,
      );
    } else {
      await IdeasServices().uploadIdea(context, ideaData);
    }

    setState(() {
      _busy = false;
      isLoading = false;
    });
  }

  //pick and upload image
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
        _localImage = file;
        if (url != null) {
          _localImage = file;
          _uploadedUrl = url;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: context.colors.mainGreenLight),
        title: Text(
          !widget.isEditIdea ? 'Add Idea' : 'Edit Idea',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            // Image box
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  if (!widget.isEditIdea && _localImage == null)
                    Image.asset(
                      Assets.images.onboardingBg.path,
                      height: 190.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else if (_localImage != null)
                    Image.file(
                      _localImage!,
                      height: 190.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  else if (widget.ideaDetails?['image'] != null &&
                      widget.ideaDetails?['image'] != '')
                    Image.network(
                      widget.ideaDetails?['image'] as String,
                      width: double.infinity,
                      height: 190.h,
                    ),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.black38,
                    width: double.infinity,
                    height: 190.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_busy)
                          const CircularProgressIndicator()
                        else ...[
                          IconButton(
                            onPressed: _pickAndUploadImage,
                            icon: Assets.icons.editImage.svg(
                              height: 36.h,
                              color: context.colors.textLightGreen,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            !widget.isEditIdea ||
                                    widget.ideaDetails?['image'] == '' ||
                                    widget.ideaDetails?['image'] == null
                                ? 'Add Image'
                                : 'Change Image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //END: Image Box
            SizedBox(
              height: 16.h,
            ),
            _buildAddIdeaSection(context, 'Idea Type', isDropdown: true),
            _buildAddIdeaSection(
              context,
              'Title',
              textController: _titleController,
              hint: 'Enter Title',
            ),
            _buildAddIdeaSection(
              context,
              'Cost',
              textController: _costController,
              hint: 'Enter Cost',
              suffixIcon: const Icon(
                Icons.attach_money,
              ),
              inputType: TextInputType.number,
            ),
            _buildAddIdeaSection(
              context,
              'Location',
              textController: _locationController,
              hint: 'Location',
              suffixIcon: Icon(
                Icons.location_pin,
                color: context.colors.greenBg,
              ),
            ),
            _buildAddIdeaSection(
              context,
              'Link',
              textController: _linkController,
              hint: 'Enter Link',
            ),
            _buildAddIdeaSection(
              context,
              'Description',
              textController: _descriptionController,
              hint: 'Enter Description',
              maxLines: 5,
            ),
            SizedBox(
              height: 16.h,
            ),
            MyButton(
              isLoading: isLoading,
              label: !widget.isEditIdea ? 'Add' : 'Update',
              onPressed: !_busy ? addOrUpdateIdea : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIdeaSection(
    BuildContext context,
    String title, {
    dynamic textController,
    bool isDropdown = false,
    String hint = '',
    Widget suffixIcon = const SizedBox.shrink(),
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        if (isDropdown) ...[
          _buildAddIdeaDropdown(context),
        ] else
          MyTextField(
            keyboardType: inputType,
            textCapitalization: TextCapitalization.none,
            controller: textController as TextEditingController,
            hint: hint,
            suffixIcon: suffixIcon,
            maxLines: maxLines,
          ),
        // _buildAddIdeaField(context),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }

  Widget _buildAddIdeaDropdown(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46.h,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDE5E6)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedType,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: context.colors.mainGreenLight,
          ),
          dropdownColor: Colors.white,
          style: const TextStyle(
            color: Color(0xFF4C5C5D),
            fontSize: 16,
          ),
          items: typeItems.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedType = value;
              });
            }
          },
        ),
      ),
    );
  }
}
