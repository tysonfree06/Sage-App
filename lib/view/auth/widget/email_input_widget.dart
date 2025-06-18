import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// A widget representing the email input field.

class EmailInputWidget extends StatefulWidget {
  const EmailInputWidget({super.key});

  @override
  State<EmailInputWidget> createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController emailController = TextEditingController(
    text: 'eve.holt@reqres.in',
  );

  @override
  Widget build(BuildContext context) {
    return MyFormTextField(
      controller: emailController,
      // focusNode: focusNode, // Setting focus node
      // decoration: InputDecoration(
      //   icon: const Icon(Icons.email), // Icon for email input field
      //   labelText:
      //       context.l10n.login_email_label, // Label text for email input field
      //
      //   // Helper text for email input field
      // ),
      keyboardType:
          TextInputType.emailAddress, // Setting keyboard type to email address
      // onChanged: (value) {
      //   // Dispatching EmailChanged event when email input changes
      //   //TODO: Fixme
      //   // context.read<LoginBloc>().add(EmailChanged(email: value));
      // },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter email';
        }

        if (!value.emailValidator()) {
          return 'Email is not correct';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }
}
