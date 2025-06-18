import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// A widget representing the password input field.

class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({super.key});

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController(
    text: 'cityslicka',
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    focusNode.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyFormTextField(
      controller: passwordController,
      // focusNode: focusNode, // Setting focus node
      // decoration: InputDecoration(
      //   icon: const Icon(Icons.lock), // Icon for password input field
      //
      //   // Helper text for password input field
      //   helperMaxLines: 2, // Maximum lines for helper text
      //   labelText: context
      //       .l10n.login_password_label, // Label text for password input field
      //   errorMaxLines: 2, // Maximum lines for error text
      // ),
      obscureText: true,
      // Making the text input obscure (i.e., showing dots instead of actual characters)
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter password';
        }
        if (value.length < 6) {
          return 'please enter password greater than 6 char';
        }
        return null;
      },
      // onChanged: (value) {
      //   // Dispatching PasswordChanged event when password input changes
      //   //TODO: Fix this
      //   // context.read<LoginBloc>().add(PasswordChanged(password: value));
      // },
      textInputAction: TextInputAction.done,
    );
  }
}
