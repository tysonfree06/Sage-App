import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyFormTextField extends StatelessWidget {
  const MyFormTextField({
    this.onChanged,
    super.key,
    this.controller,
    this.hint,
    this.label = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.words,
    this.textInputAction = TextInputAction.done,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.validator,
    this.autovalidateMode,
    this.onSaved,
    this.initialValue,
    this.readOnly = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? hint;
  final bool label;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final int? maxLength;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final void Function(String?)? onSaved;
  final String? initialValue;
  final bool readOnly;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    if (readOnly) {
      focusNode?.canRequestFocus = false;
    }
    return TextFormField(
      onChanged: onChanged,
      controller: controller ?? TextEditingController(text: initialValue),
      // readOnly: readOnly,
      enabled: !readOnly,
      focusNode: focusNode,
      cursorColor: context.colors.mainGreenLight,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      textAlign: textAlign,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        errorMaxLines: 3,
        hintText: !label ? hint : null,
        labelText: label ? hint : null,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: suffixIcon,
              )
            : null,
      ),
    );
  }
}
