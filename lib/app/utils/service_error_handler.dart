import 'package:flutter/material.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/splash_services.dart';

class ErrorHandler {
  static Future<void> handle(
    BuildContext context,
    Object error, {
    String? defaultMessage,
    String? serviceName,
  }) async {
    final label = serviceName != null ? '[$serviceName]' : '[ErrorHandler]';
    String message =
        defaultMessage ?? 'Something went wrong. Please try again.';

    if (error is AppException) {
      debugPrint('$label ❌ ${error.debugMessage}');
      message = error.userMessage;

      ///START: Handle specific case for UnauthorisedException
      ///When the error code is 401, log out the user and navigate to Welcome
      ///Because of offline mode, we do not verify token on splash and navigate
      ///the home screen directly. In case of expired token, it shows a grey
      ///screen. So, in that case, we will clear the session.
      if (message.contains('Invalid or expired token') ||
          message.contains('token') ||
          message.contains('expired')) {
        message = 'Session expired. Please log in again.';
        if (context.mounted) await SplashServices().goToWelcome(context);
        return;
      }
      //END: Handle specific case for UnauthorisedException
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
 
