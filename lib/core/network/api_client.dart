import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../storage/local_storage.dart';
import 'api_endpoints.dart';
import 'api_exceptions.dart';

/// Centralized API Client with full request/response console logging.
/// All outgoing requests (GET, POST, PUT, PATCH, DELETE, MULTIPART) and
/// responses (including status code, latency, and full response body) are
/// printed formatted to the console/terminal for inspection and debugging.
class ApiClient {
  static final http.Client _client = http.Client();
  static const Duration _timeout = Duration(seconds: 25);

  // Singleton instance
  static final ApiClient instance = ApiClient._internal();
  ApiClient._internal();

  Map<String, String> _buildHeaders({Map<String, String>? extraHeaders, bool isJson = true}) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };
    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    final token = LocalStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    return headers;
  }

  // --- LOGGING UTILITIES ---
  static void _log(String message) {
    debugPrint(message);
  }

  static String _prettyPrint(dynamic data, {String prefix = ''}) {
    if (data == null) return '${prefix}null';
    try {
      dynamic objectToEncode;
      if (data is String) {
        final trimmed = data.trim();
        if (trimmed.isEmpty) return '${prefix}(empty response body)';
        try {
          objectToEncode = jsonDecode(trimmed);
        } catch (_) {
          return trimmed.split('\n').map((line) => '$prefix$line').join('\n');
        }
      } else {
        objectToEncode = data;
      }
      const encoder = JsonEncoder.withIndent('  ');
      final pretty = encoder.convert(objectToEncode);
      return pretty.split('\n').map((line) => '$prefix$line').join('\n');
    } catch (_) {
      return '$prefix$data';
    }
  }

  static void _logRequest({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    dynamic body,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────────────────────────────────────────');
    buffer.writeln('│ 🚀 [API REQUEST] $method $uri');
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers:');
      headers.forEach((k, v) => buffer.writeln('│   $k: $v'));
    }
    if (body != null) {
      buffer.writeln('│ Request Body:');
      buffer.writeln(_prettyPrint(body, prefix: '│   '));
    }
    buffer.writeln('└─────────────────────────────────────────────────────────────────────────────');
    _log(buffer.toString());
  }

  static void _logResponse({
    required String method,
    required Uri uri,
    required int statusCode,
    required Duration duration,
    required String responseBody,
  }) {
    final isSuccess = statusCode >= 200 && statusCode < 300;
    final icon = isSuccess ? '✅' : '❌';
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────────────────────────────────────────');
    buffer.writeln('│ $icon [API RESPONSE] $statusCode (${duration.inMilliseconds}ms) -> $method $uri');
    buffer.writeln('│ Response Body:');
    buffer.writeln(_prettyPrint(responseBody, prefix: '│   '));
    buffer.writeln('└─────────────────────────────────────────────────────────────────────────────');
    _log(buffer.toString());
  }

  static void _logError({
    required String method,
    required Uri uri,
    required Object error,
    Duration? duration,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────────────────────────────────────────');
    buffer.writeln('│ ⚠️ [API NETWORK/CLIENT EXCEPTION] $method $uri');
    if (duration != null) {
      buffer.writeln('│ Elapsed: ${duration.inMilliseconds}ms');
    }
    buffer.writeln('│ Error: $error');
    buffer.writeln('└─────────────────────────────────────────────────────────────────────────────');
    _log(buffer.toString());
  }

  // --- GET ---
  Future<dynamic> get(String url, {Map<String, String>? queryParams, Map<String, String>? headers}) async {
    final uri = _buildUri(url, queryParams);
    final requestHeaders = _buildHeaders(extraHeaders: headers);
    _logRequest(method: 'GET', uri: uri, headers: requestHeaders);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client.get(uri, headers: requestHeaders).timeout(_timeout);
      stopwatch.stop();
      _logResponse(
        method: 'GET',
        uri: uri,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );
      return await _handleResponse(response, () => get(url, queryParams: queryParams, headers: headers));
    } on SocketException catch (e) {
      stopwatch.stop();
      _logError(method: 'GET', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      _logError(method: 'GET', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException(e.message);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'GET', uri: uri, error: e, duration: stopwatch.elapsed);
      rethrow;
    }
  }

  // --- POST ---
  Future<dynamic> post(String url, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final requestHeaders = _buildHeaders(extraHeaders: headers);
    final encodedBody = body != null ? (body is String ? body : jsonEncode(body)) : null;
    _logRequest(method: 'POST', uri: uri, headers: requestHeaders, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client
          .post(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          )
          .timeout(_timeout);
      stopwatch.stop();
      _logResponse(
        method: 'POST',
        uri: uri,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );
      return await _handleResponse(response, () => post(url, body: body, headers: headers));
    } on SocketException catch (e) {
      stopwatch.stop();
      _logError(method: 'POST', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      _logError(method: 'POST', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException(e.message);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'POST', uri: uri, error: e, duration: stopwatch.elapsed);
      rethrow;
    }
  }

  // --- PATCH ---
  Future<dynamic> patch(String url, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final requestHeaders = _buildHeaders(extraHeaders: headers);
    final encodedBody = body != null ? (body is String ? body : jsonEncode(body)) : null;
    _logRequest(method: 'PATCH', uri: uri, headers: requestHeaders, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client
          .patch(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          )
          .timeout(_timeout);
      stopwatch.stop();
      _logResponse(
        method: 'PATCH',
        uri: uri,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );
      return await _handleResponse(response, () => patch(url, body: body, headers: headers));
    } on SocketException catch (e) {
      stopwatch.stop();
      _logError(method: 'PATCH', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      _logError(method: 'PATCH', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException(e.message);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PATCH', uri: uri, error: e, duration: stopwatch.elapsed);
      rethrow;
    }
  }

  // --- PUT ---
  Future<dynamic> put(String url, {dynamic body, Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final requestHeaders = _buildHeaders(extraHeaders: headers);
    final encodedBody = body != null ? (body is String ? body : jsonEncode(body)) : null;
    _logRequest(method: 'PUT', uri: uri, headers: requestHeaders, body: body);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client
          .put(
            uri,
            headers: requestHeaders,
            body: encodedBody,
          )
          .timeout(_timeout);
      stopwatch.stop();
      _logResponse(
        method: 'PUT',
        uri: uri,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );
      return await _handleResponse(response, () => put(url, body: body, headers: headers));
    } on SocketException catch (e) {
      stopwatch.stop();
      _logError(method: 'PUT', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      _logError(method: 'PUT', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException(e.message);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'PUT', uri: uri, error: e, duration: stopwatch.elapsed);
      rethrow;
    }
  }

  // --- DELETE ---
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    final uri = Uri.parse(url);
    final requestHeaders = _buildHeaders(extraHeaders: headers);
    _logRequest(method: 'DELETE', uri: uri, headers: requestHeaders);
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _client.delete(uri, headers: requestHeaders).timeout(_timeout);
      stopwatch.stop();
      _logResponse(
        method: 'DELETE',
        uri: uri,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );
      return await _handleResponse(response, () => delete(url, headers: headers));
    } on SocketException catch (e) {
      stopwatch.stop();
      _logError(method: 'DELETE', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      _logError(method: 'DELETE', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException(e.message);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'DELETE', uri: uri, error: e, duration: stopwatch.elapsed);
      rethrow;
    }
  }

  // --- MULTIPART (Upload files/photos) ---
  Future<dynamic> multipartRequest(
    String method,
    String url, {
    Map<String, String>? fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    final requestHeaders = _buildHeaders(extraHeaders: headers, isJson: false);
    _logRequest(
      method: 'MULTIPART $method',
      uri: uri,
      headers: requestHeaders,
      body: {
        if (fields != null && fields.isNotEmpty) 'fields': fields,
        if (files != null && files.isNotEmpty)
          'files': files.map((k, v) => MapEntry(k, '${v.path} (${v.existsSync() ? "${v.lengthSync()} bytes" : "file not found"})')),
      },
    );
    final stopwatch = Stopwatch()..start();
    try {
      final request = http.MultipartRequest(method, uri);
      request.headers.addAll(requestHeaders);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      if (files != null) {
        for (final entry in files.entries) {
          final file = entry.value;
          if (await file.exists()) {
            request.files.add(await http.MultipartFile.fromPath(entry.key, file.path));
          }
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);
      stopwatch.stop();
      _logResponse(
        method: 'MULTIPART $method',
        uri: uri,
        statusCode: response.statusCode,
        duration: stopwatch.elapsed,
        responseBody: response.body,
      );
      return await _handleResponse(response, null);
    } on SocketException catch (e) {
      stopwatch.stop();
      _logError(method: 'MULTIPART $method', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException('Unable to connect to server. Please check internet connection.');
    } on http.ClientException catch (e) {
      stopwatch.stop();
      _logError(method: 'MULTIPART $method', uri: uri, error: e, duration: stopwatch.elapsed);
      throw NetworkException(e.message);
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'MULTIPART $method', uri: uri, error: e, duration: stopwatch.elapsed);
      rethrow;
    }
  }

  // --- RESPONSE HANDLER & TOKEN REFRESH ---
  Future<dynamic> _handleResponse(http.Response response, Future<dynamic> Function()? retryCall) async {
    final statusCode = response.statusCode;
    dynamic decoded;

    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(utf8.decode(response.bodyBytes));
      } catch (_) {
        decoded = response.body;
      }
    }

    // Success: 200..299
    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    // 401 Unauthorized -> Attempt Token Refresh
    if (statusCode == 401) {
      _log('🔄 [API CLIENT] 401 Unauthorized encountered. Attempting token refresh...');
      final refreshed = await _tryRefreshToken();
      if (refreshed && retryCall != null) {
        _log('🔄 [API CLIENT] Token refresh succeeded. Retrying original request...');
        return await retryCall();
      }
      await LocalStorage.clearAuth();
      final msg = _extractErrorMessage(decoded) ?? 'Session expired. Please log in again.';
      _log('❌ [API CLIENT] 401 Session expired: $msg');
      throw UnauthorizedException(msg);
    }

    // 400 Bad Request -> Validation Errors
    if (statusCode == 400) {
      if (decoded is Map<String, dynamic>) {
        final valEx = ValidationException(decoded, _extractErrorMessage(decoded) ?? 'Validation error.');
        _log('❌ [API CLIENT] 400 Validation Error: ${valEx.firstError}');
        throw valEx;
      }
      final msg = decoded?.toString() ?? 'Bad request.';
      _log('❌ [API CLIENT] 400 Bad Request: $msg');
      throw ApiException(msg, statusCode: 400);
    }

    // 404 Not Found
    if (statusCode == 404) {
      final msg = _extractErrorMessage(decoded) ?? 'Resource not found.';
      _log('❌ [API CLIENT] 404 Not Found: $msg');
      throw NotFoundException(msg);
    }

    // Other Server Errors
    final message = _extractErrorMessage(decoded) ?? 'An error occurred with status code $statusCode.';
    _log('❌ [API CLIENT] $statusCode Server Error: $message');
    throw ApiException(message, statusCode: statusCode, data: decoded);
  }

  Future<bool> _tryRefreshToken() async {
    final refresh = LocalStorage.getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      _log('🔄 [API REFRESH] No refresh token found in LocalStorage.');
      return false;
    }

    final stopwatch = Stopwatch()..start();
    final refreshUri = Uri.parse(ApiEndpoints.refreshToken);
    _logRequest(
      method: 'POST',
      uri: refreshUri,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: {'refresh': '${refresh.substring(0, refresh.length > 10 ? 10 : refresh.length)}...'},
    );
    try {
      final res = await _client.post(
        refreshUri,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );
      stopwatch.stop();
      _logResponse(
        method: 'POST',
        uri: refreshUri,
        statusCode: res.statusCode,
        duration: stopwatch.elapsed,
        responseBody: res.body,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = data['access']?.toString();
        if (newAccess != null && newAccess.isNotEmpty) {
          await LocalStorage.saveTokens(access: newAccess);
          _log('🔄 [API REFRESH] Access token refreshed and persisted to LocalStorage.');
          return true;
        }
      }
    } catch (e) {
      stopwatch.stop();
      _logError(method: 'POST', uri: refreshUri, error: e, duration: stopwatch.elapsed);
    }
    return false;
  }

  String? _extractErrorMessage(dynamic body) {
    if (body == null) return null;
    if (body is Map) {
      if (body['detail'] != null) return body['detail'].toString();
      if (body['message'] != null) return body['message'].toString();
      if (body['error'] != null) return body['error'].toString();
      // Look at first entry
      for (final value in body.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String) return value;
      }
    }
    if (body is String) return body;
    return null;
  }

  Uri _buildUri(String url, Map<String, String>? queryParams) {
    final uri = Uri.parse(url);
    if (queryParams == null || queryParams.isEmpty) return uri;
    return uri.replace(queryParameters: {...uri.queryParameters, ...queryParams});
  }
}
