import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/settings_service.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool get isFilled => _emailController.text.isEmpty;
  bool isLoading = false;

  final _settingService = SettingService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: context.colors.mainGreenLight),
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              _buildContactUsSection(context, 'Email Address',
                  textController: _emailController, hint: 'alex123@gmail.com',),
              _buildContactUsSection(
                context,
                'Subject Line',
                textController: _subjectController,
                hint: 'Enter Subject Line',
                // suffixIcon: const Icon(
                //   Icons.attach_money,

                // ),
                suffixIcon: Assets.icons.email.svg(),
              ),
              _buildContactUsSection(
                context,
                'Description',
                textController: _descriptionController,
                hint: 'Type Here...',
                maxLines: 5,
              ),
              // const Expanded(
              //   child: SizedBox(),
              // ),
              SizedBox(
                height: 200.h,
              ),
              MyButton(
                label: 'Submit',
                isLoading: isLoading,
                onPressed: isFilled && !isLoading
                    ? () async {
                        if (!formKey.currentState!.validate()) return;
                        setState(() => isLoading = true);
                        await _settingService.contactUs(
                          context,
                          email: _emailController.text,
                          subjectLine: _subjectController.text,
                          description: _descriptionController.text,
                        );
                        setState(() => isLoading = false);
                      }
                    : null,
              ),
              SizedBox(
                height: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactUsSection(
    BuildContext context,
    String title, {
    dynamic textController,
    String hint = '',
    Widget suffixIcon = const SizedBox.shrink(),
    int maxLines = 1,
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
        if (title == 'Email Address')
          MyFormTextField(
            controller: textController as TextEditingController,
            hint: hint,
            suffixIcon: suffixIcon,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.error_email_required;
              } else if (!value.emailValidator()) {
                return context.l10n.error_email_invalid;
              }
              return null;
            },
          )
        else
          MyTextField(
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
}
