import 'package:flutter/material.dart';
import 'package:sage/app/components/my_button.dart';

/// A widget representing the submit button for the auth form.
class SubmitButton extends StatelessWidget {
  const SubmitButton({required this.formKey, super.key});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return MyButton(
      label: 'Login',
      // isDark: true,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // context.read<LoginBloc>().add(const LoginApi());
        }
      },
    );
  }
}
