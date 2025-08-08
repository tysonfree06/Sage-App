import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/app/utils/log_manager.dart';
import 'package:sage/services/session_manager/session_controller.dart';

/// Class for handling network API requests.
class NetworkApiService implements BaseApiServices {
  final SessionController _sessionController = SessionController();

  // Do not use token in headers for the following API calls
  final List<String> unauthenticatedEndpoints = [
    AppUrl.login,
    AppUrl.signup,
    AppUrl.sendOtp,
    AppUrl.verifyOtp,
    AppUrl.forgotPassword,
    AppUrl.resetPassword,
  ];

  /// Utility method to check if API needs token in headers
  bool _needsAuth(String url) {
    return !unauthenticatedEndpoints.contains(url);
  }

  /// Utility function to handle errors and debugPrint stack traces
  void _handleError(dynamic error, {String? message, StackTrace? stackTrace}) {
    if (error is FormatException) {
      debugPrint('FormatException: $message');
      if (stackTrace != null) {
        debugPrint('Stack Trace: $stackTrace');
      }
      throw FetchDataException('Failed to parse response');
    } else if (error is SocketException) {
      debugPrint('SocketException: No Internet Connection');
      throw NoInternetException('No Internet Connection');
    } else if (error is TimeoutException) {
      debugPrint('TimeoutException: Network Request Timeout');
      throw FetchDataException('Network Request time out');
    } else {
      debugPrint('Unknown Error: $message');
      if (stackTrace != null) {
        debugPrint('Stack Trace: $stackTrace');
      } else {
        debugPrint('No stack trace available');
      }
      throw FetchDataException('An unknown error occurred');
    }
  }

  /// Utility function for adding headers, including token if needed
  Map<String, String> _getHeaders(String url, {bool isMultipart = false}) {
    final Map<String, String> headers = {};
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
    }

    if (_needsAuth(url)) {
      final String? token = _sessionController.token;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    debugPrint('Request Headers: $headers');
    return headers;
  }

  // Map<String, dynamic> _parseResponse(http.Response response) {
  //   try {
  //     final Map<String, dynamic> responseJson =
  //         jsonDecode(response.body) as Map<String, dynamic>;
  //     return responseJson;
  //   } catch (e) {
  //     _handleError(e, message: 'Error parsing response: ${response.body}');
  //     rethrow;
  //   }
  // }

  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      final dynamic decodedJson = jsonDecode(response.body);

      // If it's already a Map<String, dynamic>, return as is
      if (decodedJson is Map<String, dynamic>) {
        return decodedJson;
      }

      // If it's not a Map, wrap it in a "data" key
      return {
        'data': decodedJson,
      };
    } catch (e) {
      _handleError(e, message: 'Error parsing response: ${response.body}');
      rethrow;
    }
  }

  /// Utility function for parsing the response and handling errors
  Map<String, dynamic> returnResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint('From Return Response: ${response.statusCode}');
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        return _parseResponse(response);
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorisedException(response.body);
      case 500:
      case 404:
        throw FetchDataException(response.body);
      default:
        throw FetchDataException(response.body);
    }
  }

  /// Handles GET request
  @override
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? queryParams,
  }) async {
    LogManager.logRequest('GET', url, null);

    final response = await http
        .get(
          Uri.parse(url).replace(queryParameters: queryParams),
          headers: _getHeaders(url),
        )
        .timeout(const Duration(seconds: 60));

    LogManager.logResponse(response.statusCode.toString(), response.body);
    // This is handling all the errors so no need for try catch
    return returnResponse(response);
  }

  /// Handles POST request
  @override
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('POST', url, data);

    final response = await http
        .post(
          Uri.parse(url),
          headers: _getHeaders(url),
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 60));

    LogManager.logResponse(response.statusCode.toString(), response.body);
    return returnResponse(response);
  }

  //This function in temporarily replaced with the actual function above to bypass SSL verification issue : #muttas
  /// Handles POST request with IOClient to ignore SSL issues
  // @override
  // Future<Map<String, dynamic>> post({
  //   required String url,
  //   required Map<String, dynamic> data,
  //   Map<String, dynamic>? params,
  // }) async {
  //   LogManager.logRequest('POST', url, data);

  //   // 👇 Custom HttpClient that ignores bad SSL certs
  //   final HttpClient httpClient = HttpClient()
  //     ..badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;

  //   final IOClient ioClient = IOClient(httpClient);

  //   final response = await ioClient
  //       .post(
  //         Uri.parse(url),
  //         headers: await _getHeaders(url),
  //         body: jsonEncode(data),
  //       )
  //       .timeout(const Duration(seconds: 60));

  //   LogManager.logResponse(response.statusCode.toString(), response.body);
  //   return returnResponse(response);
  // }

  /// Handles PUT request
  @override
  Future<Map<String, dynamic>> put({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('PUT', url, data);

    final response = await http
        .put(
          Uri.parse(url),
          headers: _getHeaders(url),
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 60));

    LogManager.logResponse(response.statusCode.toString(), response.body);
    return _parseResponse(response);
  }

  /// Handles PATCH request
  @override
  Future<Map<String, dynamic>> patch({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('PATCH', url, data);

    final response = await http
        .patch(
          Uri.parse(url),
          headers: _getHeaders(url),
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 60));

    LogManager.logResponse(response.statusCode.toString(), response.body);
    return returnResponse(response);
  }

  /// Handles DELETE request
  @override
  Future<Map<String, dynamic>> delete({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('DELETE', url, data);

    final response = await http
        .delete(
          Uri.parse(url),
          headers: _getHeaders(url),
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 60));

    LogManager.logResponse(response.statusCode.toString(), response.body);
    return returnResponse(response);
  }

  // /// Handles Multipart request
  // @override
  // Future<Map<String, dynamic>> multipartUpload({
  //   required String url,
  //   required String filePath,
  //   required String fileFieldName,
  // }) async {
  //   // 1. Ensure file exists
  //   final file = File(filePath);
  //   if (!await file.exists()) {
  //     throw FetchDataException('File not found at path: $filePath');
  //   }

  //   // 2. Build URI with any query params
  //   final uri = Uri.parse(url);

  //   // 3. Create and populate request
  //   final request = http.MultipartRequest('POST', uri)
  //     ..files.add(await http.MultipartFile.fromPath(fileFieldName, filePath))
  //     ..headers.addAll(await _getHeaders(url)) // auth, etc
  //     ..headers.remove('Content-Type'); // let MultipartRequest set it

  //   // 5. Log full details (including size, name)
  //   final stat = await file.stat();
  //   LogManager.logRequest('MULTIPART', uri.toString(), {
  //     // 'fileName': 'Image', //basename(filePath),
  //     'fileSize': stat.size,
  //     'fieldName': fileFieldName,
  //   });

  //   try {
  //     // 6. Send + read with a single timeout
  //     final streamed = await request.send();
  //     final responseStr = await streamed.stream
  //         .transform(utf8.decoder)
  //         .join()
  //         .timeout(const Duration(seconds: 120));

  //     LogManager.logResponse(
  //       streamed.statusCode.toString(),
  //       responseStr,
  //     );

  //     // 7. Parse & handle errors
  //     return returnResponse(
  //       http.Response(responseStr, streamed.statusCode),
  //     );
  //   } catch (e, st) {
  //     _handleError(e, message: 'Multipart upload failed', stackTrace: st);
  //     // no rethrow needed
  //     rethrow; // (unreachable, but keeps the analyzer happy)
  //   }
  // }

  /// Handles Multipart request
  @override
  Future<Map<String, dynamic>> multipartUpload({
    required String url,
    required File file,
  }) async {
    LogManager.logRequest('POST (Multipart)', url, {'filePath': file.path});

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(_getHeaders(url, isMultipart: true));

    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final mimeParts = mimeType.split('/');

    final multipartFile = await http.MultipartFile.fromPath(
      'image',
      file.path,
      contentType: MediaType(mimeParts[0], mimeParts[1]),
      filename: basename(file.path),
    );

    request.files.add(multipartFile);

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 100));
    final response = await http.Response.fromStream(streamedResponse);
    LogManager.logResponse(response.statusCode.toString(), response.body);

    return returnResponse(response);
  }
}
