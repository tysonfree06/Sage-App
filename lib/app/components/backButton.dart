import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key, this.color, this.onPressed});
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      //  ??
      //     () {
      //       Navigator.of(context).pop();
      //     },
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
        color: color ?? context.colors.white,
      ),
    );
  }
}
