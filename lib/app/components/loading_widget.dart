import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.size = 32.0,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.mainGreenLight;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
                color: effectiveColor,
              )
            : CircularProgressIndicator(
                strokeWidth: 2,
                color: effectiveColor,
              ),
      ),
    );
  }
}
