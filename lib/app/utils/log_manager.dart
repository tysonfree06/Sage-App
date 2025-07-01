import 'package:logger/logger.dart';

class LogManager {
  // Initialize the Logger with conditional coloring
  static Logger logger = Logger(
    level: Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      colors: false,
    ),
  );

  // Logs HTTP request
  static void logRequest(
    String method,
    String url,
    Map<String, dynamic>? body,
  ) {
    logger.i('$method Request: $url\nBody: $body');
  }

  // Logs HTTP response
  static void logResponse(String statusCode, String response) {
    logger.i('Status Code: $statusCode\nResponse: $response');
  }
}
