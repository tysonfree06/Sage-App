import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/network/base_api_services.dart';
import 'package:sage/app/utils/app_url.dart';
import 'package:sage/app/utils/log_manager.dart';
import 'package:sage/services/storage/local_storage.dart';

/// Class for handling network API requests.
class NetworkApiService implements BaseApiServices {
  final LocalStorage _localStorage = LocalStorage();

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
  Future<Map<String, String>> _getHeaders(String url) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (_needsAuth(url)) {
      final String? token = await _localStorage.readValue('auth_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Utility function to parse responses
  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      final Map<String, dynamic> responseJson =
          jsonDecode(response.body) as Map<String, dynamic>;
      return responseJson;
    } catch (e) {
      _handleError(e, message: 'Error parsing response: ${response.body}');
      rethrow;
    }
  }

  /// Handles GET request
  @override
  Future<Map<String, dynamic>> get({
    required String url,
  }) async {
    LogManager.logRequest('GET', url, null);

    try {
      final response = await http
          .get(Uri.parse(url), headers: await _getHeaders(url))
          .timeout(const Duration(seconds: 20));

      LogManager.logResponse(response.statusCode.toString(), response.body);
      return returnResponse(response);
    } on Exception catch (e) {
      _handleError(e, message: 'GET request failed');
      rethrow;
    }
  }

  /// Handles POST request
  @override
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('POST', url, data);

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: await _getHeaders(url),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      LogManager.logResponse(response.statusCode.toString(), response.body);
      //On status code 400 code should not reach here else go straight to exception but code is reaching here and thats the problem
      // How did i know the response is printing in terminal that should not happen if status code is not 200/201
      return returnResponse(response);
    } on Exception catch (e) {
      _handleError(e, message: 'POST request failed');
      rethrow;
    }
  }

  /// Handles PUT request
  @override
  Future<Map<String, dynamic>> put({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('PUT', url, data);

    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: await _getHeaders(url),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      LogManager.logResponse(response.statusCode.toString(), response.body);
      return _parseResponse(response);
    } on Exception catch (e) {
      _handleError(e, message: 'PUT request failed');
      rethrow;
    }
  }

  /// Handles PATCH request
  @override
  Future<Map<String, dynamic>> patch({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('PATCH', url, data);

    try {
      final response = await http
          .patch(
            Uri.parse(url),
            headers: await _getHeaders(url),
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      LogManager.logResponse(response.statusCode.toString(), response.body);
      return returnResponse(response);
    } on Exception catch (e) {
      _handleError(e, message: 'PATCH request failed');
      rethrow;
    }
  }

  /// Handles DELETE request
  @override
  Future<Map<String, dynamic>> delete({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    LogManager.logRequest('DELETE', url, params ?? {});

    try {
      final response = await http
          .delete(Uri.parse(url), headers: await _getHeaders(url))
          .timeout(const Duration(seconds: 10));

      LogManager.logResponse(response.statusCode.toString(), response.body);
      return returnResponse(response);
    } on Exception catch (e) {
      _handleError(e, message: 'DELETE request failed');
      rethrow;
    }
  }

  /// Utility function for parsing the response and handling errors
  /// Not called anywhere fix this issue
  Map<String, dynamic> returnResponse(http.Response response) {
    if (kDebugMode) {
      debugPrint(response.statusCode.toString());
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
        throw FetchDataException(
          'Error occurred while communicating with the server',
        );
      default:
        throw FetchDataException('Unexpected error occurred');
    }
  }
}
