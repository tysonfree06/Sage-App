import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: color ?? context.colors.white,
        ),
    );
  }
}
