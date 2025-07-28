import 'package:flutter/material.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';

class ErrorHandler {
  static void handle(
    BuildContext context,
    Object error, {
    String? defaultMessage,
    String? serviceName,
  }) {
    final label = serviceName != null ? '[$serviceName]' : '[ErrorHandler]';
    String message =
        defaultMessage ?? 'Something went wrong. Please try again.';

    if (error is AppException) {
      debugPrint('$label ❌ ${error.debugMessage}');
      message = error.userMessage;
    } else {
      debugPrint('$label ❌ Unexpected error: $error');

      // Print 5 lines of current stack trace
      final trace =
          StackTrace.current.toString().split('\n').take(5).join('\n');
      debugPrint('$label 🧵 Stack trace:\n$trace');
    }

    if (context.mounted) {
      context.flushBarErrorMessage(message: message);
    }
  }
}
 //new file added #muttas
 
